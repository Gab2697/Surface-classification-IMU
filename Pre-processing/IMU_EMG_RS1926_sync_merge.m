function IMU_EMG_RS1926_sync_merge(fld)
% 
% It assumes that files are arranged in the following order
% MoCap file --> fld\MoCap\Subject_name\filename.zoo or MoCap in the name
% of file
% IMU file --> fld\IMU\Subject_name\filename.zoo or IMU in the name
% of file
% It also assumes files are in chronological order
% MoCapIMU_merge combines MoCap and IMU .zoo files created using Xsens2zoo 
% It cuts IMU files depending on original start and end of the MoCap file
% and explodes MoCap data into _x, _y and _z before mergeing both files.
% zoosystem contains MoCap file zoosystem data and IMUzoosystem has IMU
% zoosystem data.
% It saves file in fld\Merged_files\Subject_name\filename.zoo
%
% ARGUMENTS
% fld    ...   string, folder to operate on
%
% RETURNS
%  data  ...  zoo data. Return if fld is individual file 


fl=engine('fld',fld,'ext','.zoo');
EMG=fl(contains(fl,'EMG_1'));
IMU=fl(contains(fl,'IMU_1'));
strcell=strfind(EMG,'/');
foldername=[fld,'/','Merged_files'];
MyFolderInfo = dir(foldername);
if isempty(MyFolderInfo)
    mkdir(foldername)
end
for i=1:length(EMG)
    strduble=strcell{i};
    size=length(strduble);
    S=strduble(size-1)+1;
    E=strduble(size)-1;
    Sname=EMG{i}(S:E);

    
    zname=EMG{i}(E+2:end);
    
    EMGdata=zload(EMG{i});
    IMUdata=zload(IMU{i});
    cname=EMGdata.zoosystem.Header.Surface;
    fodname=[foldername,'/',cname];
    
    MyFolderInfo = dir(fodname);
    if isempty(MyFolderInfo)
        mkdir(fodname)
    end
    fodname=[foldername,'/',cname,'/',Sname];
    
    MyFolderInfo = dir(fodname);
    if isempty(MyFolderInfo)
        mkdir(fodname)
    end
    
    fname=[fld,'/','Merged_files','/',cname,'/',Sname,'/',zname];
    disp(['Merging EMG and IMU',zname])
%     EMGdata=downsample_EMG(EMGdata);
    IMUdata=upsample_IMU(IMUdata);
    delay=corrdelay(IMUdata,EMGdata);
    data=Merge(EMGdata,IMUdata,delay);
    disp(['Saving File to --->',fname])
    zsave(fname,data,'EMGIMU_merge')
end


function EMGdata=Merge(EMGdata,IMUdata,delay)
IMUdata.SegmentAngularVelocity_Pelvis_x.event.Start=delay.IMU+1;
IMUdata.SegmentAngularVelocity_Pelvis_x.event.End=delay.n;

EMGdata.Xs.event.Start=1;
EMGdata.Xs.event.End=delay.n-delay.EMG;

IMUdata=transpose_IMU(IMUdata);

IMUdata=partition_data(IMUdata,'Start','End');
EMGdata=partition_data(EMGdata,'Start','End');

IMUZooinfo=IMUdata.zoosystem;
IMUdata=rmfield(IMUdata,'zoosystem');
fields=fieldnames(IMUdata);
for j=1:length(fields)
    EMGdata = addchannel_data(EMGdata,fields{j},IMUdata.(fields{j}).line,'Video');
end


EMGdata.zoosystem=IMUZooinfo;

function delay=corrdelay(IMUdata,EMGdata)

emg_delsys_resample=EMGdata.Trignosensor3RFAcc3Xg.line;
acc_Xsens=IMUdata.SensorFreeAcceleration_Right_Upper_Leg_x.line;

n=min(numel(emg_delsys_resample),numel(acc_Xsens));
x_xsens_cutt=(acc_Xsens(1:n))./10;
emg_delsys_resample=emg_delsys_resample(1:n);

[xc,lags]=xcorr(x_xsens_cutt,emg_delsys_resample);
[m,i]=max(xc);
tau=lags(i);% the offset is tau (how off the signals are)
% returns coefficients between acc Xsens and acc Delsys
 
%remove offset emg
tau=abs(tau);

delay.EMG=tau;
delay.IMU=tau;
delay.n=n;

%% Resample (downsample) emg data into sampling rate of xsens 
function newdata=upsample_IMU(data)
freq_s_accxsens=240;
Fs_emg=1926;
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
    'SensorFreeAcceleration_Left_Lower_Leg_y','SensorFreeAcceleration_Left_Lower_Leg_z','SensorFreeAcceleration_Left_Foot_x','SensorFreeAcceleration_Left_Foot_y','SensorFreeAcceleration_Left_Foot_z','JointAnglesZXY_Right_Knee_Flexion_Extension','JointAnglesZXY_Left_Knee_Flexion_Extension'};

newdata=struct;
for i=1:length(ch)
newdata.(ch{i})=struct;
newdata.(ch{i}).line=upsample_line(data.(ch{i}).line,freq_s_accxsens,Fs_emg);
newdata.(ch{i}).event=struct;
end
newdata.zoosystem=data.zoosystem;

function xsens_resample=upsample_line(data,freq_s_accxsens,Fs_emg)
y_xsens=data; % siganl we want to resample (the one we have)
xq_xsens=1:1/(Fs_emg/freq_s_accxsens):length(y_xsens);
method='spline';
F_xsens=[1:length(y_xsens)];%length of signal we want to interpolate
xsens_resample = interp1(F_xsens,y_xsens,xq_xsens,method);


function IMUdata=transpose_IMU(IMUdata) 
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
    'SensorFreeAcceleration_Left_Lower_Leg_y','SensorFreeAcceleration_Left_Lower_Leg_z','SensorFreeAcceleration_Left_Foot_x','SensorFreeAcceleration_Left_Foot_y','SensorFreeAcceleration_Left_Foot_z','JointAnglesZXY_Right_Knee_Flexion_Extension','JointAnglesZXY_Left_Knee_Flexion_Extension'};

for i=1:length(ch)
    IMUdata.(ch{i}).line=IMUdata.(ch{i}).line.';
end