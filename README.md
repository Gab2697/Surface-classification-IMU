# Surface-classification-IMU
Classification of different running surface using deep learning methods and IMU sensors

## 1. Data Pre-processing Steps
Pre-processing steps were done with the raw signals using Matlab (The Mathworks, Inc., Natick, USA) and the biomechZoo toolbox (https://github.com/PhilD001/biomechZoo).  The main code for step A to D can be found in the function Main_preprocessing. 
The final reshaping of signals into tensors were conducted in Python software (Python Software Foundation, https://www.pyton.org/) on Google’s Colaboratory Pro+ GPU (GPU: 1xTesla P100, 54.8 GB RAM) (Steps E). 
All the functions used in the above steps can be found in the GitHub https://github.com/Gab2697/Surface-classification-EMG-IMU .
Figure 1 summarizes the pre-processing steps discussed in the next section of this thesis.
 
 <img width="465" alt="image" src="https://user-images.githubusercontent.com/83525182/171494809-c292e8fb-22a4-4d72-86d5-025acc0e841b.png">
Figure 1: Flow chart for pre-processing steps.

### Step A) Conversion and channel selection 

The outputted Excel files from the data collection software (Xsens MVN) were converted to zoo files (functions: Xsens2zoo) in MATLAB to use the functions in the toolbox BiomecZoo (P. C. Dixon et al., 2017).

### Step B) Cut trials and Gait cycle segmentation
This is the first element that was tested in the results section of this thesis. Two different signal separation approaches were compared using the lower body sensors combination. The first one was a four second section of the trials without the acceleration and deceleration phases. The second one was to extract gait cycles from those trials and use them as the inputs for the model. Two functions were used to separate the trials into gait cycles (function: gait_event_knee, outdoor_gait_cycle_data_Knee). The first function was used to create events to identify knee flexion at heel strike which is the minimum value between two peaks (P. C. Dixon et al., 2017). 
Has it can be observed in Figure 2, peak knee flexions can easily be identified. Then, the first local minimum between each peak are identified as heel strikes. 

 <img width="222" alt="image" src="https://user-images.githubusercontent.com/83525182/171494768-580e2031-a910-417e-b440-fe4c93a53ec2.png">
Figure 2: Peak Knee flexion for gait event identification.

The second function segmented the trials into gait cycles. All gait cycles were time normalized to 101 sample points (function: bmech_normalize).

### Step C) Normalization
The second pre-processing step that was evaluated in the result section is the impact of max-normalization on the input signals. To do so, all signals were normalized using the max value of each gait cycles to bring them to a common scale between zero and one (function: normMax_data).

### Step D) Table extraction
In this last step, two columns were added at the end of the table for the surface type and the participant number, respectively (function: extract_filestruct). Finally, table data were exported to a .mat file for further processing in python (function: table2struct).

### Step E) Reshaping in python
One main function was used for all the steps conducted in python (THE_CODE_IMU) and this code can be found in the GitHub https://github.com/Gab2697/Surface-classification-EMG-IMU .
First the .mat files were loaded into python and converted into the correct tensor shape demonstrated in Figure 3, which is #trials  #frames  # channels (function: mat_to_tensor). The labels were one hot encoded (function: one_hot).

  <img width="252" alt="image" src="https://user-images.githubusercontent.com/83525182/171494727-96003363-28ac-4163-ad37-c2faab9e9dd8.png">
Figure 3:  Tensor format for CNN input.


## 2. Developing the CNN Model

The following steps were conducted with Python software (Python Software Foundation, https://www.pyton.org/) on Google’s Colaboratory Pro+ GPU (GPU: 1xTesla P100, 54.8 GB RAM). Machine learning and data analysis Python packages (e.g., Tensorflow, PyTorch, Numpy, Scipy, Scikit-learn, Pandas) were used for the deep learning task.
One main function was used for all the following steps (THE_CODE_IMU) and this code can be found in the GitHub https://github.com/Gab2697/Surface-classification-EMG-IMU .

### Step A) Basic CNN model for sensor type/location testing
Figure 4 demonstrate the initial basic model that was used to determine which sensor combination is optimal for this classification task.

 <img width="180" alt="image" src="https://user-images.githubusercontent.com/83525182/171494691-4317616f-00bc-45ea-8485-1c55c3819820.png">
Figure 4: Basic model for premilary testing.

Multiple functions were created to test different combinations of sensors. Temporary files were created to save the two main dataset subsections:
-	Acceleration (list of all signals in Appendix D)
-	Angular velocity (list of all signals in Annex D)

Only the subject-dependent approach was tested for the four sensor combinations (Table 1). All four-sensor combinations were tested for the acceleration and angular velocity signals.

Table 1:  Sensor combinations tested for acceleration and angular velocity.
![image](https://user-images.githubusercontent.com/83525182/171495405-4f36d63f-0713-4af2-986b-489bdc4276a7.png)


### Step B) Tuning CNN models with validation set

First, one to four convolutional layers were tested to determine the optimal general CNN architecture. Then, three different optimizers (Adam, RMSprop and SGD) and different batch sizes were evaluated for this classification task.
Second, the model hyperparameters were tuned, using KerasTuner and a callback function for early stop (using the validation loss with a patience of 50). The learning rate, number of filters, kernel size, dropout and regularization ratio were tuned using the kerasTuner. The regularization parameter was also initially tested with KerasTuner but then removed due to lower performance on the validation accuracy when included in the model. The following steps were conducted using the optimal combination of sensors found in the previous section. The parameters evaluated can be found in Table 2.

Table 2: Tuning the CNN model.
![image](https://user-images.githubusercontent.com/83525182/171495363-5c91e1f8-4353-4127-9057-b921de8041a4.png)


### Step C) Train, validation, and test split

Two different splitting approaches were tested in this thesis: Subject-wise and Subject-dependent split. The subject-wise split (leave-n-subject-out) splits the datasets with different participant in train, test, and validation sets (inter-subject split). The subject-dependent split shuffled all trials between different dataset subsections to train, validate and test the accuracy of the trained models (intra-subject split) (Funciton: subject_wise_split).

### Step D) Final model evaluated with testing set
Both the acceleration and angular velocity were tested with the final optimized model using the best sensor combination from Table 2. Precision, recall and f1-score were obtained for both surfaces (see following equations).

(1) 𝑃𝑟𝑒𝑐𝑖𝑠𝑖𝑜𝑛= 𝑇𝑟𝑢𝑒 𝑃𝑜𝑠𝑖𝑡𝑖𝑣𝑒 / (𝑇𝑟𝑢𝑒 𝑃𝑜𝑠𝑖𝑡𝑖𝑣𝑒 + 𝐹𝑎𝑙𝑠𝑒 𝑃𝑜𝑠𝑖𝑡𝑖𝑣𝑒)
(2) 𝑅𝑒𝑐𝑎𝑙𝑙= 𝑇𝑟𝑢𝑒 𝑃𝑜𝑠𝑖𝑡𝑖𝑣𝑒 / (𝑇𝑟𝑢𝑒 𝑃𝑜𝑠𝑖𝑡𝑖𝑣𝑒 + 𝐹𝑎𝑙𝑠𝑒 𝑁𝑒𝑔𝑎𝑡𝑖𝑣𝑒)
(3) 𝐹1 𝑠𝑐𝑜𝑟𝑒= 2 𝑥 (𝑃𝑟𝑒𝑐𝑖𝑠𝑖𝑜𝑛 𝑥 𝑅𝑒𝑐𝑎𝑙𝑙) / (𝑃𝑟𝑒𝑐𝑖𝑠𝑖𝑜𝑛 + 𝑅𝑒𝑐𝑎𝑙𝑙)

The final model with the optimal sensor combination, splitting approach and pre-processing steps, was tested with a 5-fold cross validation approach using the testing set (Figure 5). 
 
 <img width="328" alt="image" src="https://user-images.githubusercontent.com/83525182/171495580-92b42e23-7d5c-45fe-ad4d-ade7e2f31d40.png">
Figure 5: 5-fold cross validation split organization.



