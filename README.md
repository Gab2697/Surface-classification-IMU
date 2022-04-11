# Surface-classification-EMG/IMU
Classification of different running surface using deep learning methods and sEMG/IMU sensors

*****IMPORTANT: This is still a work in progress (for the Classification task section). The codes should be completed in the following weeks.*****

Pre-processing of signals
For the following steps the toolbox BiomechZoo was used in MATLAB to facilitate batch processing. To run the preprocessing steps, it is necessary to add to the MATLAB path of the BiomechZoo-master (https://github.com/PhilD001/biomechZoo).
The main function to run for preprocessing steps is called Main_processing.
1. The outputted excel files from the data collection softwares (Xsens MVN and EMGworks Acquisition) were converted to zoo files. To do so, the function Xsens2zoo (for the IMU signals) and the function EMG2zoo (for the EMG signals) were used.

2. Specific channels were selected from all the different output signals of the sensors using the function bmech_removechannel. More specifically, for the 17 IMU sensors, the x-y-z acceleration, x-y-z angular velocity and joint angle data (flexion extension, abduction-adduction and internal-external rotation). For the 4 EMG sensors the time and muscle contraction of Tibialis anterior, Gastrocnemius, Rectus Femoris and Bicep Femoris were kept.

3. A few more steps were conducted on the EMG signals for pre-processing. The raw signals were first high pass filtered (20) and low pass filtered (500). Then, rectified EMG, the EMG envelope and the EMG Root Mean Square (RMS) was calculated. To filter, rectify and find the RMS of the signal the function bmech_emgprocess was used. To find the EMG envelope the function EMG_envelop was used. To normalize the data using the maximum muscle contraction of each trial, the function normMax_data was used.

4. Then the IMU data and the EMG data were merged into a common library. The function IMU_EMG_RS240_sync_merge was used. To do so three steps have to be executed:
- Resample the data into a common sample frequency which was 240 Hz (the original sample frequency of the IMU data).
*Option to test a different sampling rate with function IMU_EMG_RS1926_sync_merge.
- Synchronize both signals removing the delay between the data collected using a cross correlation function.
*Data collected on two different software and there was a delay between pressing start on the recording of one software and then the other). The data collection was always done in this order: Start EMGworks Acquisition, start Xsens MVN, stop EMGworks Acquisition, stop Xsens MVN.
- Finally, both sensors could be merged into a common table.

5. Afterwards, the data could be separated into gait cycles. The function gait_event_knee and outdoor_gait_cycle_data_Knee were used for gait cycle identification and data separation.

6. Some channels were removed to lighten the final exported table using the same function has step 2 (bmech_removechannel).

7. The gait cycles were normalized into a common length of 100 data points using the function bmech_normalize.

8. During the trials, the participant had to run for a prolonged period. Some trials had to be removed due to sweat accumulation between the electrode and the skin. To clean those bad trials, a function called remove_sweat was created. This function compares each EMG envelop of each gait cycles to the wanted EMG envelope found in previously published literature. The function only keeps the signals with a similar pattern to the what the EMG envelope should look like for those muscles while running.

9. Finaly, the function extract_filestruct adds a column for the surface type and the participant number into the final table.

10. And the function table2struct creates the table to be exported into a .mat file.


Classification task
The following steps were conducted in python to use the machine learning and data analysis Python packages (e.g., Tensorflow, PyTorch, Numpy, Scipy, Scikit-learn, Pandas) to build the CNN model.
1. Load the .mat files and convert them into tensors with the correct format of (#trials, #frames, # channels) using the function mat_to_tensor.

2. Seperate the different signal types into different datasets (acceleration, angular velocity, EMG).
*Also seperate into individual sensors (17 different for IMU and 4 for EMG) to test wich sensor type/location combination gives the best classification results (Functions: seperate_EMG_signals,seperate_acc_signals,seperate_gyro_signals). 

3. Separate the train, validation, and test set subject-wise using the subject_wise_split function. This allows us to both split the datasets with completely different participant in train, test and validation sets or to shuffle all trials and have a few trials of each participant's testing in all the different subsets.

4. One hot encoding of the labels using the function one_hot.
<img width="422" alt="Screen Shot 2022-04-11 at 10 19 52 AM" src="https://user-images.githubusercontent.com/83525182/162760371-224654a8-820f-4df9-8fff-452ae476f16d.png">

5. Tuning 1D-CNN models with validation set:
- Tune hyperparameters (epoch, batch size, learning rate, optimization function) with SearchGrid (function EMG_GC_tuningCNN) and keras tuner (to be added). 
- Tune the model architecture (number layers, filter, kernel, dropout, regularization) (function EMG_GC_tuningCNN)

6. Test different combinations of signal type/location with function Sensor_opt.


