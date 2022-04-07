%% Convert excel to .zoo file (Raw data folder)
%Xsens: convert to zoo
% fld=uigetfolder;
% xsens2zoo(fld, '.xlsx');

% EMG: convert to zoo
fld=uigetfolder;
EMG2zoo(fld)

%% Create Particiapnt and conditions variables
% fld=uigetfolder;
% surfaces_keep = {'grass','asphalt','gravel'};
%   
% IMU_outdoor_organize(fld, surfaces_keep); %moves zoo files into correct folder-condition
% 

%% Xsens IMU: select specific channels: here it is acc, gyro, angle joints
fld=uigetfolder;
action='keep'; % add channel you want to keep
ch={'SegmentAngularVelocity_Pelvis_x','SegmentAngularVelocity_Pelvis_y','SegmentAngularVelocity_Pelvis_z','SegmentAngularVelocity_Right_Shoulder_x',...
    'SegmentAngularVelocity_Right_Shoulder_y','SegmentAngularVelocity_Right_Shoulder_z','SegmentAngularVelocity_Right_Forearm_x','SegmentAngularVelocity_Right_Forearm_y',...
    'SegmentAngularVelocity_Right_Forearm_z','SegmentAngularVelocity_Right_Hand_x','SegmentAngularVelocity_Right_Hand_y','SegmentAngularVelocity_Right_Hand_z',...
    'SegmentAngularVelocity_Left_Shoulder_x','SegmentAngularVelocity_Left_Shoulder_y','SegmentAngularVelocity_Left_Shoulder_z',...
    'SegmentAngularVelocity_Left_Forearm_x','SegmentAngularVelocity_Left_Forearm_y','SegmentAngularVelocity_Left_Forearm_z','SegmentAngularVelocity_Left_Hand_x',...
    'SegmentAngularVelocity_Left_Hand_y','SegmentAngularVelocity_Left_Hand_z','SegmentAngularVelocity_Right_Lower_Leg_x','SegmentAngularVelocity_Right_Lower_Leg_y',...
    'SegmentAngularVelocity_Right_Lower_Leg_z','SegmentAngularVelocity_Right_Foot_x','SegmentAngularVelocity_Right_Foot_y','SegmentAngularVelocity_Right_Foot_z',...
    'SegmentAngularVelocity_Left_Upper_Leg_x','SegmentAngularVelocity_Left_Upper_Leg_y','SegmentAngularVelocity_Left_Upper_Leg_z','SegmentAngularVelocity_Left_Lower_Leg_x',...
    'SegmentAngularVelocity_Left_Lower_Leg_y','SegmentAngularVelocity_Left_Lower_Leg_z','SegmentAngularVelocity_Left_Foot_x','SegmentAngularVelocity_Left_Foot_y','SegmentAngularVelocity_Left_Foot_z',...
    'JointAnglesZXY_C1_Head_Lateral_Bending','JointAnglesZXY_C1_Head_Axial_Rotation','JointAnglesZXY_C1_Head_Flexion_Extension','JointAnglesZXY_Right_Shoulder_Abduction_Adduction',...
    'JointAnglesZXY_Right_Shoulder_Internal_External_Rotation','JointAnglesZXY_Right_Shoulder_Flexion_Extension', 'JointAnglesZXY_Right_Elbow_Ulnar_Deviation_Radial_Deviation', ...
    'JointAnglesZXY_Right_Elbow_Pronation_Supination', 'JointAnglesZXY_Right_Elbow_Flexion_Extension','JointAnglesZXY_Right_Wrist_Ulnar_Deviation_Radial_Deviation',...
    'JointAnglesZXY_Right_Wrist_Pronation_Supination','JointAnglesZXY_Right_Wrist_Flexion_Extension','JointAnglesZXY_Left_Shoulder_Abduction_Adduction','JointAnglesZXY_Left_Shoulder_Internal_External_Rotation',...
    'JointAnglesZXY_Left_Shoulder_Flexion_Extension','JointAnglesZXY_Left_Elbow_Ulnar_Deviation_Radial_Deviation', 'JointAnglesZXY_Left_Elbow_Pronation_Supination', 'JointAnglesZXY_Left_Elbow_Flexion_Extension',...
    'JointAnglesZXY_Left_Wrist_Ulnar_Deviation_Radial_Deviation','JointAnglesZXY_Left_Wrist_Pronation_Supination', 'JointAnglesZXY_Left_Wrist_Flexion_Extension', 'JointAnglesZXY_Right_Hip_Abduction_Adduction',...
    'JointAnglesZXY_Right_Hip_Internal_External_Rotation', 'JointAnglesZXY_Right_Hip_Flexion_Extension', 'JointAnglesZXY_Right_Knee_Abduction_Adduction', 'JointAnglesZXY_Right_Knee_Internal_External_Rotation',...
    'JointAnglesZXY_Right_Knee_Flexion_Extension', 'JointAnglesZXY_Right_Ankle_Abduction_Adduction', 'JointAnglesZXY_Right_Ankle_Internal_External_Rotation','JointAnglesZXY_Right_Ankle_Dorsiflexion_Plantarflexion',...
    'JointAnglesZXY_Left_Hip_Abduction_Adduction', 'JointAnglesZXY_Left_Hip_Internal_External_Rotation', 'JointAnglesZXY_Left_Hip_Flexion_Extension', 'JointAnglesZXY_Left_Knee_Abduction_Adduction', ...
    'JointAnglesZXY_Left_Knee_Internal_External_Rotation', 'JointAnglesZXY_Left_Knee_Flexion_Extension', 'JointAnglesZXY_Left_Ankle_Abduction_Adduction', 'JointAnglesZXY_Left_Ankle_Internal_External_Rotation',...
    'JointAnglesZXY_Left_Ankle_Dorsiflexion_Plantarflexion',...
    'SensorFreeAcceleration_Pelvis_x','SensorFreeAcceleration_Pelvis_y','SensorFreeAcceleration_Pelvis_z','SensorFreeAcceleration_Head_x','SensorFreeAcceleration_Head_y','SensorFreeAcceleration_Head_z',...
    'SensorFreeAcceleration_Right_Shoulder_x','SensorFreeAcceleration_Right_Shoulder_y','SensorFreeAcceleration_Right_Shoulder_z','SensorFreeAcceleration_Right_Upper_Arm_x','SensorFreeAcceleration_Right_Upper_Arm_y',...
    'SensorFreeAcceleration_Right_Upper_Arm_z','SensorFreeAcceleration_Right_Forearm_x','SensorFreeAcceleration_Right_Forearm_y','SensorFreeAcceleration_Right_Forearm_z','SensorFreeAcceleration_Right_Hand_x','SensorFreeAcceleration_Right_Hand_y',...
    'SensorFreeAcceleration_Right_Hand_z','SensorFreeAcceleration_Left_Shoulder_x','SensorFreeAcceleration_Left_Shoulder_y','SensorFreeAcceleration_Left_Shoulder_z','SensorFreeAcceleration_Left_Upper_Arm_x',...
    'SensorFreeAcceleration_Left_Upper_Arm_y','SensorFreeAcceleration_Left_Upper_Arm_z','SensorFreeAcceleration_Left_Forearm_x','SensorFreeAcceleration_Left_Forearm_y','SensorFreeAcceleration_Left_Forearm_z',...
    'SensorFreeAcceleration_Left_Hand_x','SensorFreeAcceleration_Left_Hand_y','SensorFreeAcceleration_Left_Hand_z','SensorFreeAcceleration_Right_Upper_Leg_x','SensorFreeAcceleration_Right_Upper_Leg_y','SensorFreeAcceleration_Right_Upper_Leg_z',...
    'SensorFreeAcceleration_Right_Lower_Leg_x','SensorFreeAcceleration_Right_Lower_Leg_y','SensorFreeAcceleration_Right_Lower_Leg_z','SensorFreeAcceleration_Right_Foot_x','SensorFreeAcceleration_Right_Foot_y',...
    'SensorFreeAcceleration_Right_Foot_z','SensorFreeAcceleration_Left_Upper_Leg_x','SensorFreeAcceleration_Left_Upper_Leg_y','SensorFreeAcceleration_Left_Upper_Leg_z','SensorFreeAcceleration_Left_Lower_Leg_x',...
    'SensorFreeAcceleration_Left_Lower_Leg_y','SensorFreeAcceleration_Left_Lower_Leg_z','SensorFreeAcceleration_Left_Foot_x','SensorFreeAcceleration_Left_Foot_y','SensorFreeAcceleration_Left_Foot_z'};

bmech_removechannel(fld,ch,action)

%% Delsys EMG: Preprocessing steps  
%1.-----Select specific channels-----
fld=uigetfolder;
action='keep';
ch2={'Xs','Trignosensor1TAEMG1Volts','Trignosensor2GastrocEMG2Volts','Trignosensor3RFEMG3Volts','Trignosensor4BFEMG4Volts','Trignosensor3RFAcc3Xg'};
bmech_removechannel(fld,ch2,action)

%2.-----Get high, low pass filter, rectified and rms-----
emg_ch={'Trignosensor1TAEMG1Volts','Trignosensor2GastrocEMG2Volts','Trignosensor3RFEMG3Volts','Trignosensor4BFEMG4Volts'};
lp_cut=500;
hp_cut=20;
order=4;
span=50;%number of frames for RMS average
SR=1926;
bmech_emgprocess(fld,emg_ch,lp_cut, hp_cut,order, span, SR)

%3.-----EMG envelop-----
emg_ch2={'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect','Trignosensor3RFEMG3Volts_filthigh_filtlow_rect', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect'};

fcut = 5;% cutoff
SR_2=240;
order2=4;
fnyq = SR_2/2;
cd(fld)
fl = engine('path',fld,'extension','zoo');
for i = 1:length(fl)
    batchdisp(fl{i},'Adding emg envelop')
    data = zload(fl{i});
    data = EMG_envelop(data,emg_ch2,fcut,fnyq,order2);
    zsave(fl{i},data);
end
%% Merge IMU and EMG files
% before this step EMG and IMU data needs to be organized in the same order
% and change the name of the folders need to be EMG_1 and IMU_1
fld=uigetfolder;

% MoCapIMU_merge(fld) %resample the EMG signals to 240Hz

% MoCapIMU_merge2(fld) %resample the IMU signals to 1926Hz

MoCapIMU_merge3(fld) %resample the IMU and EMG signals to 1000Hz
%% Gait cycle identification and normalization of 1 gait cycle into 100 data points
% ----Finds min knee flexion index ----
fld=uigetfolder;%select merge_files
PeakLim=0.5;
gait_event_knee(fld, PeakLim) 

% ----Extract gait cycles ----
% fld=uigetfolder;
n_cycles=1;
outdoor_gait_cycle_data_Knee(fld,n_cycles)

%% ----Remove channel Xs ----
fld=uigetfolder;
action='remove';
ch2={'Xs'};
bmech_removechannel(fld,ch2,action)

% ----Normalize gait cycle to 100 samples ----
bmech_normalize(fld)
%after this save the data into a different folder to keep angle if needed later

%% Remove joint angles
% action='remove';
% ch={'JointAnglesZXY_C1_Head_Lateral_Bending','JointAnglesZXY_C1_Head_Axial_Rotation','JointAnglesZXY_C1_Head_Flexion_Extension','JointAnglesZXY_Right_Shoulder_Abduction_Adduction',...
%     'JointAnglesZXY_Right_Shoulder_Internal_External_Rotation','JointAnglesZXY_Right_Shoulder_Flexion_Extension', 'JointAnglesZXY_Right_Elbow_Ulnar_Deviation_Radial_Deviation', ...
%     'JointAnglesZXY_Right_Elbow_Pronation_Supination', 'JointAnglesZXY_Right_Elbow_Flexion_Extension','JointAnglesZXY_Right_Wrist_Ulnar_Deviation_Radial_Deviation',...
%     'JointAnglesZXY_Right_Wrist_Pronation_Supination','JointAnglesZXY_Right_Wrist_Flexion_Extension','JointAnglesZXY_Left_Shoulder_Abduction_Adduction','JointAnglesZXY_Left_Shoulder_Internal_External_Rotation',...
%     'JointAnglesZXY_Left_Shoulder_Flexion_Extension','JointAnglesZXY_Left_Elbow_Ulnar_Deviation_Radial_Deviation', 'JointAnglesZXY_Left_Elbow_Pronation_Supination', 'JointAnglesZXY_Left_Elbow_Flexion_Extension',...
%     'JointAnglesZXY_Left_Wrist_Ulnar_Deviation_Radial_Deviation','JointAnglesZXY_Left_Wrist_Pronation_Supination', 'JointAnglesZXY_Left_Wrist_Flexion_Extension', 'JointAnglesZXY_Right_Hip_Abduction_Adduction',...
%     'JointAnglesZXY_Right_Hip_Internal_External_Rotation', 'JointAnglesZXY_Right_Hip_Flexion_Extension', 'JointAnglesZXY_Right_Knee_Abduction_Adduction', 'JointAnglesZXY_Right_Knee_Internal_External_Rotation',...
%     'JointAnglesZXY_Right_Knee_Flexion_Extension', 'JointAnglesZXY_Right_Ankle_Abduction_Adduction', 'JointAnglesZXY_Right_Ankle_Internal_External_Rotation','JointAnglesZXY_Right_Ankle_Dorsiflexion_Plantarflexion',...
%     'JointAnglesZXY_Left_Hip_Abduction_Adduction', 'JointAnglesZXY_Left_Hip_Internal_External_Rotation', 'JointAnglesZXY_Left_Hip_Flexion_Extension', 'JointAnglesZXY_Left_Knee_Abduction_Adduction', ...
%     'JointAnglesZXY_Left_Knee_Internal_External_Rotation', 'JointAnglesZXY_Left_Knee_Flexion_Extension', 'JointAnglesZXY_Left_Ankle_Abduction_Adduction', 'JointAnglesZXY_Left_Ankle_Internal_External_Rotation',...
%     'JointAnglesZXY_Left_Ankle_Dorsiflexion_Plantarflexion'};
% bmech_removechannel(fld,ch,action)

%% Normalize
% fld=uigetfolder;
% cd(fld)
% fl = engine('path',fld,'extension','zoo');
% emg_ch={'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect','Trignosensor3RFEMG3Volts_filthigh_filtlow_rect', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect'};
% 
% % emg_ch2={'Trignosensor1TAEMG1Volts', 'Trignosensor2GastrocEMG2Volts','Trignosensor3RFEMG3Volts', 'Trignosensor4BFEMG4Volts'};
% for i = 1:length(fl)
%     batchdisp(fl{i},'normalizing emg signals')
%     data = zload(fl{i});
%     data = normMax_data(data,emg_ch);
%     zsave(fl{i},data);
% end
%% Sweat removal

fld=uigetfolder;
cd(fld)
fl = engine('path',fld,'extension','zoo');
emg_ch_zero={'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_Env', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect_Env','Trignosensor3RFEMG3Volts_filthigh_filtlow_rect_Env', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect_Env'};

for i = 1:length(fl)
    batchdisp(fl{i},'remove sweat, replace with zeros')
    data = zload(fl{i});
    data = remove_sweat(data,emg_ch_zero);
    zsave(fl{i},data);
end

%% Gets the variables subject and conditions
%before this reorganise folder such as: Merge/P01/asphalt and Merge/P01/grass (remove the folder asphalt_grass1, etc.)
fld=uigetfolder; % select the merge folder so that P01 can be store has the subject variable
[subjects, Conditions] = extract_filestruct(fld); % gets the variables subject and conditions
Conditions=unique(Conditions);

%% Creates a table to save into mat 

ch={'SegmentAngularVelocity_Pelvis_x','SegmentAngularVelocity_Pelvis_y','SegmentAngularVelocity_Pelvis_z','SegmentAngularVelocity_Right_Shoulder_x',...
    'SegmentAngularVelocity_Right_Shoulder_y','SegmentAngularVelocity_Right_Shoulder_z','SegmentAngularVelocity_Right_Forearm_x','SegmentAngularVelocity_Right_Forearm_y',...
    'SegmentAngularVelocity_Right_Forearm_z','SegmentAngularVelocity_Right_Hand_x','SegmentAngularVelocity_Right_Hand_y','SegmentAngularVelocity_Right_Hand_z',...
    'SegmentAngularVelocity_Left_Shoulder_x','SegmentAngularVelocity_Left_Shoulder_y','SegmentAngularVelocity_Left_Shoulder_z',...
    'SegmentAngularVelocity_Left_Forearm_x','SegmentAngularVelocity_Left_Forearm_y','SegmentAngularVelocity_Left_Forearm_z','SegmentAngularVelocity_Left_Hand_x',...
    'SegmentAngularVelocity_Left_Hand_y','SegmentAngularVelocity_Left_Hand_z','SegmentAngularVelocity_Right_Lower_Leg_x','SegmentAngularVelocity_Right_Lower_Leg_y',...
    'SegmentAngularVelocity_Right_Lower_Leg_z','SegmentAngularVelocity_Right_Foot_x','SegmentAngularVelocity_Right_Foot_y','SegmentAngularVelocity_Right_Foot_z',...
    'SegmentAngularVelocity_Left_Upper_Leg_x','SegmentAngularVelocity_Left_Upper_Leg_y','SegmentAngularVelocity_Left_Upper_Leg_z','SegmentAngularVelocity_Left_Lower_Leg_x',...
    'SegmentAngularVelocity_Left_Lower_Leg_y','SegmentAngularVelocity_Left_Lower_Leg_z','SegmentAngularVelocity_Left_Foot_x','SegmentAngularVelocity_Left_Foot_y','SegmentAngularVelocity_Left_Foot_z',...
    'SensorFreeAcceleration_Pelvis_x','SensorFreeAcceleration_Pelvis_y','SensorFreeAcceleration_Pelvis_z','SensorFreeAcceleration_Head_x','SensorFreeAcceleration_Head_y','SensorFreeAcceleration_Head_z',...
    'SensorFreeAcceleration_Right_Shoulder_x','SensorFreeAcceleration_Right_Shoulder_y','SensorFreeAcceleration_Right_Shoulder_z','SensorFreeAcceleration_Right_Upper_Arm_x','SensorFreeAcceleration_Right_Upper_Arm_y',...
    'SensorFreeAcceleration_Right_Upper_Arm_z','SensorFreeAcceleration_Right_Forearm_x','SensorFreeAcceleration_Right_Forearm_y','SensorFreeAcceleration_Right_Forearm_z','SensorFreeAcceleration_Right_Hand_x','SensorFreeAcceleration_Right_Hand_y',...
    'SensorFreeAcceleration_Right_Hand_z','SensorFreeAcceleration_Left_Shoulder_x','SensorFreeAcceleration_Left_Shoulder_y','SensorFreeAcceleration_Left_Shoulder_z','SensorFreeAcceleration_Left_Upper_Arm_x',...
    'SensorFreeAcceleration_Left_Upper_Arm_y','SensorFreeAcceleration_Left_Upper_Arm_z','SensorFreeAcceleration_Left_Forearm_x','SensorFreeAcceleration_Left_Forearm_y','SensorFreeAcceleration_Left_Forearm_z',...
    'SensorFreeAcceleration_Left_Hand_x','SensorFreeAcceleration_Left_Hand_y','SensorFreeAcceleration_Left_Hand_z','SensorFreeAcceleration_Right_Upper_Leg_x','SensorFreeAcceleration_Right_Upper_Leg_y','SensorFreeAcceleration_Right_Upper_Leg_z',...
    'SensorFreeAcceleration_Right_Lower_Leg_x','SensorFreeAcceleration_Right_Lower_Leg_y','SensorFreeAcceleration_Right_Lower_Leg_z','SensorFreeAcceleration_Right_Foot_x','SensorFreeAcceleration_Right_Foot_y',...
    'SensorFreeAcceleration_Right_Foot_z','SensorFreeAcceleration_Left_Upper_Leg_x','SensorFreeAcceleration_Left_Upper_Leg_y','SensorFreeAcceleration_Left_Upper_Leg_z','SensorFreeAcceleration_Left_Lower_Leg_x',...
    'SensorFreeAcceleration_Left_Lower_Leg_y','SensorFreeAcceleration_Left_Lower_Leg_z','SensorFreeAcceleration_Left_Foot_x','SensorFreeAcceleration_Left_Foot_y','SensorFreeAcceleration_Left_Foot_z',...
    'Trignosensor1TAEMG1Volts','Trignosensor2GastrocEMG2Volts','Trignosensor3RFEMG3Volts','Trignosensor4BFEMG4Volts','Trignosensor1TAEMG1Volts_filthigh','Trignosensor2GastrocEMG2Volts_filthigh','Trignosensor3RFEMG3Volts_filthigh', 'Trignosensor4BFEMG4Volts_filthigh',...
    'Trignosensor1TAEMG1Volts_filthigh_filtlow','Trignosensor2GastrocEMG2Volts_filthigh_filtlow','Trignosensor3RFEMG3Volts_filthigh_filtlow', 'Trignosensor4BFEMG4Volts_filthigh_filtlow', 'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect', ...
    'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect', 'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_RMS', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect_RMS', 'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect_RMS', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect_RMS',...
    'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_Env','Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect_Env','Trignosensor3RFEMG3Volts_filthigh_filtlow_rect_Env','Trignosensor4BFEMG4Volts_filthigh_filtlow_rect_Env'};

table_data = bmech_line(fld,ch,subjects, Conditions);
table_data.Subject=char(table_data.Subject);
table_data.Conditions=char(table_data.Conditions);
data=table2struct(table_data);

%% Functions
%----------------------EMG envelope ----------------------
function data=EMG_envelop(data,emg_ch,fcut,fnyq,order)

    [B,A]=butter(order,fcut/fnyq,'low');
    for ii = 1:length(emg_ch)
        r = data.(emg_ch{ii}).line;
        filt_r = filtfilt(B,A,r);  
        data = addchannel_data(data,[emg_ch{ii},'_Env'],filt_r,'Analog');
    end
end

% ---------------------- remove sweat trials----------------------
function data=remove_sweat(data,emg_ch_zero) 
for ii = 1:length(emg_ch_zero) % 4 channels
    r_zero = data.(emg_ch_zero{ii}).line;

        if ii==1 && find(r_zero==max(r_zero))<=50  % TA=peak se situe dans la 2e moitié du gait cycle donc on demande le contraire
            r_zero=zeros(length(r_zero),1); %if the peak is not at the correct place, replace that signal by zeros
            data = addchannel_data(data,'Trignosensor1TAEMG1Volts',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh_filtlow',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_RMS',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_Env',r_zero,'Analog');
        elseif ii==2 && find(r_zero==max(r_zero))>=50% Gastroc=peak se situe dans la 1e moitié du gait cycle
            r_zero=zeros(length(r_zero),1); 
            data = addchannel_data(data,'Trignosensor2GastrocEMG2Volts',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor2GastrocEMG2Volts_filthigh',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor2GastrocEMG2Volts_filthigh_filtlow',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect_RMS',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect_Env',r_zero,'Analog');
        elseif ii==3 && find(r_zero==max(r_zero))>=60 % RF=peak se situe dans la 1e moitié du gait cycle
            r_zero=zeros(length(r_zero),1);
            data = addchannel_data(data,'Trignosensor3RFEMG3Volts',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor3RFEMG3Volts_filthigh',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor3RFEMG3Volts_filthigh_filtlow',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect_RMS',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect_Env',r_zero,'Analog');
        elseif ii==4 && find(r_zero==max(r_zero))<=50 % BF=peak se situe dans la 2e moitié du gait cycle
            r_zero=zeros(length(r_zero),1);
            data = addchannel_data(data,'Trignosensor4BFEMG4Volts',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor4BFEMG4Volts_filthigh',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor4BFEMG4Volts_filthigh_filtlow',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect_RMS',r_zero,'Analog');
            data = addchannel_data(data,'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect_Env',r_zero,'Analog');
        else %if peak is at the right spot keep the signal

        end    
end

% treshold= 5*(10^(-6));
% remove_treshold(data,treshold,emg_ch_zero);
end

% ----------------------normalize data with max of each gait cycle ----------------------
function data=normMax_data(data,emg_ch)

    for ii = 1:length(emg_ch)
        r = data.(emg_ch{ii}).line;
        max_r=max(r);
        norm_r = r./max_r;  
        data = addchannel_data(data,[emg_ch{ii},'_Norm'],norm_r,'Analog');
    end
end
% ----------------------treshold to remove sweat trials----------------------
function remove_treshold(data,treshold,emg_ch_zero)
for ii = 1:length(emg_ch_zero)
    r = data.(emg_ch_zero{ii}).line;
    if max(r)>=treshold
%            delfile(fl{i})
         r=zeros(length(r),1);
         data = addchannel_data(data,'Trignosensor1TAEMG1Volts',r,'Analog');
         data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh',r,'Analog');
         data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh_filtlow',r,'Analog');
         data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect',r,'Analog');
         data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_RMS',r,'Analog');
         data = addchannel_data(data,'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_EMGenvelop',r,'Analog');
    else 

    end 
end
end