function IMU_EMG_RS240_sync_merge(fld)
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
    EMGdata=downsample_EMG(EMGdata);
    delay=corrdelay(IMUdata,EMGdata);
    data=Merge(EMGdata,IMUdata,delay);
    disp(['Saving File to --->',fname])
    zsave(fname,data,'EMGIMU_merge')
end

function EMGdata=Merge(EMGdata,IMUdata,delay)
IMUdata.JointAnglesZXY_C1_Head_Axial_Rotation.event.Start=delay.IMU+1;
IMUdata.JointAnglesZXY_C1_Head_Axial_Rotation.event.End=delay.n;

EMGdata.Xs.event.Start=1;
EMGdata.Xs.event.End=delay.n-delay.EMG;
EMGdata=transpose_EMG(EMGdata);

IMUdata=partition_data(IMUdata,'Start','End');
EMGdata=partition_data(EMGdata,'Start','End');
%EMGdata=explode_data(EMGdata);
%IMUdata=rmfield(IMUdata,'Frames');
IMUZooinfo=IMUdata.zoosystem;
IMUdata=rmfield(IMUdata,'zoosystem');
fields=fieldnames(IMUdata);
for j=1:length(fields)
    EMGdata = addchannel_data(EMGdata,fields{j},IMUdata.(fields{j}).line,'Video');
end

%EMGdata.EMGzoosystem=EMGdata.zoosystem;
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
function newdata=downsample_EMG(data)
freq_s_accxsens=240;
Fs_emg=1926;
% ch=data.zoosystem.Video.Channels;
% ch=fieldnames(data);
% ch=ch(2:end);
ch={'Trignosensor1TAEMG1Volts','Trignosensor2GastrocEMG2Volts','Trignosensor3RFEMG3Volts','Trignosensor3RFAcc3Xg','Trignosensor4BFEMG4Volts','Trignosensor1TAEMG1Volts_filthigh','Trignosensor2GastrocEMG2Volts_filthigh','Trignosensor3RFEMG3Volts_filthigh', 'Trignosensor4BFEMG4Volts_filthigh',...
'Trignosensor1TAEMG1Volts_filthigh_filtlow','Trignosensor2GastrocEMG2Volts_filthigh_filtlow','Trignosensor3RFEMG3Volts_filthigh_filtlow', 'Trignosensor4BFEMG4Volts_filthigh_filtlow', 'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect', ...
'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect', 'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_RMS', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect_RMS', 'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect_RMS', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect_RMS'};
newdata=struct;
for i=1:length(ch)
newdata.(ch{i})=struct;
newdata.(ch{i}).line=downsample_line(data.(ch{i}).line,freq_s_accxsens,Fs_emg);
newdata.(ch{i}).event=struct;
end
newdata.zoosystem=data.zoosystem;

function emg_delsys_resample=downsample_line(data,freq_s_accxsens,Fs_emg)
%Resample emg delsys 1926 to acceleration xsens 240 (downsampling)
y_delsys_emg=data; % siganl we want to resample (the one we have)
xq_delsys_emg=1:1/(freq_s_accxsens/Fs_emg):length(y_delsys_emg);
method='spline';
F_delsys=[1:length(y_delsys_emg)];%length of signal we want to interpolate
emg_delsys_resample = interp1(F_delsys,y_delsys_emg,xq_delsys_emg,method);


function EMGdata=transpose_EMG(EMGdata)
% ch=EMGdata.zoosystem.Video.Channels;
% ch=fieldnames(EMGdata);
% ch=ch(2:end);
ch={'Trignosensor1TAEMG1Volts','Trignosensor2GastrocEMG2Volts','Trignosensor3RFEMG3Volts','Trignosensor3RFAcc3Xg','Trignosensor4BFEMG4Volts','Trignosensor1TAEMG1Volts_filthigh','Trignosensor2GastrocEMG2Volts_filthigh','Trignosensor3RFEMG3Volts_filthigh', 'Trignosensor4BFEMG4Volts_filthigh',...
'Trignosensor1TAEMG1Volts_filthigh_filtlow','Trignosensor2GastrocEMG2Volts_filthigh_filtlow','Trignosensor3RFEMG3Volts_filthigh_filtlow', 'Trignosensor4BFEMG4Volts_filthigh_filtlow', 'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect', ...
'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect', 'Trignosensor1TAEMG1Volts_filthigh_filtlow_rect_RMS', 'Trignosensor2GastrocEMG2Volts_filthigh_filtlow_rect_RMS', 'Trignosensor3RFEMG3Volts_filthigh_filtlow_rect_RMS', 'Trignosensor4BFEMG4Volts_filthigh_filtlow_rect_RMS'};

for i=1:length(ch)
    EMGdata.(ch{i}).line=EMGdata.(ch{i}).line.';
end