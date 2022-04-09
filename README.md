# Surface-classification-EMG/IMU
Classification of different running surface using deep learning methods and sEMG/IMU sensors

Pre-processing of signals
For the following steps the tool box BiomechZoo was used in matlab to facilitate batch processing. To run this code it is necessary to add to the MATLAB path the BiomechZoo-master (https://github.com/PhilD001/biomechZoo).
1. The outputted excel files were converted to zoo files. To do so, the function Xsens2zoo (for the IMU signals ) and the function EMG2zoo (for the EmG signals) were used.
2. Specific channels were selected from all the different output signals of the sensors using the function bmech_removechannel. More specifically, for the IMU sensors, the acceleration, angular velocity and joint angle data for all seventeen sensors with 3 degree of freedom motions ( x-y-z axis and flexion-extension, abduction-adduction and internal-external rotation). For the EMG sensors the time and muscle contraction of Tibialis anterior, Gastrocnemius, Rectus Femoris and Bicep Femoris were kept.
3. A few more steps were conducted on the EMG signal for pre-processing. The raw signals were first high pass filtered (XXX), then low pass filtered, the rectified EMG was calculated, the EMG envelop was found and finally the EMG RMS. To filter, rectify and find the RMS of the signal the function bmech_emgprocess was used. To find the emg envelop the function EMG_envelop was used. To normalize the data using the maximum muscle contraction of each trial, the function normMax_data was used.
4. Then the IMU data and the EMG data were merged into a common library. The function MoCapIMU_merge was used. To do so three steps have to be executed:
    - Resample the data into a common sample frequency which was 240Hz (the original sample frequency of the IMU data).
    - Synchronize both signals removing the delay between the data collected with EMGworks Aquisition and Xsens MVM using a cross corolation function.
    - Finally, both sensors could be merged into a common table.
6. Afterwards, the data could be seperated into gait cycles. The function gait_event_knee and outdoor_gait_cycle_data_Knee were used for gait cycle identification and data seperation.
7. Some channles were removed to lighten the final exported table using the same function has step 2.
8. The gait cycle were normalized into a common length of 100 data points using the function bmech_normalize.
9. Remove the bad trials with the function remove_sweat.
10. Add a column for the surface type and the participant number into the final table with the function extract_filestruct.
11. Create the table to be exported into a .mat file.

Classification task
The following steps were conducted in python to use the machine learning and data analysis Python packages (e.g., Tensorflow, PyTorch, Numpy, Scipy, Scikit-learn, Pandas).
1. Load the .mat files and convert them into tensors with the correct format of (#trials, #frames, # channels) using the function mat_to_tensor.
2. Seperate the different signal types into different datasets (acceleration, angular velocity, EMG).
3. Seperate the train, validation and test set subject-wise using the subject_wise_split function.
4. One hot encoding of the labels using the function one_hot.
5. Test 1D-CNN models
  - Tune hyperparameters (epoch, batch size, learning rate, optimization function)
  - Tune the model architecture ( number layers, filter, kernel, dropout, regularization)
  - Test different signal and combination of signal type/location
  - 
7. Test different sampling rate?? 1926hz
