function data = EMG2zoo(fld, ftype, del)

% XSENS2ZOO converts files created by XSens Inertial measurement unit
% sensors to biomechZoo format
%
% ARGUMENTS
% fld    ...   string, folder to operate on
% ftpye  ...   string, file type. Default 'xlsx'. Future versions will
%              support .mvnx files
% del    ...   bool, option to delete c3d file after creating zoo file.
%              Default: false
% RETURNS
%  data  ...  zoo data. Return if fld is individual file
%
%
% Created by Vaibhav Shah June 7th, 2021
%
% Updated by Philippe C. Dixon June 8th, 2021
%
% Updated by Vaibhav Shah June 23rd, 2021
%
% Updated by Philippe Dixon June 23rd, 2021
% - maintain use of sheetnames function if available
% - add error catch for wrong sheet name

% set defaults
if nargin == 0
    fld = uigetfolder;
    ftype = '.xlsx';
    del = false;
end

if nargin == 1
    ftype = '.xlsx';
    del = false;
end

if nargin ==2
    del = false;
end


% check input (file or folder)
[~,fl,saveFile] = checkinput(fld,ftype);

tic
for i=1:length(fl)
    [fpath,fname]=fileparts(fl{i});
    if exist('sheetnames.m', 'file') ==2
        sname=sheetnames(fl{i});
    else
        sname=["Sheet1"];
    end
    disp(' ')
    batchdisp(fl{i},'converting EMG file to zoo format')
    data=struct;
    for j=1:length(sname)
        disp(['... extracting sheet ', sname{j}])
        data=GI_sheet(data,fl{i},sname(j));
        [data1, text]=xlsread(fl{i});
        str = regexprep(text, {'-',' ','_','/','[',']',':'},{''});
        
        for k=1:length(str)
            if contains(str{k},'.')
                delt=findstr(str{k},'.');
                namef=[str{k}(1:delt-1),str{k}(delt+1:length(str{k}))];
                disp([namef, 'extracting to zoo'])
                data.(namef).line= data1(:,k);
                data.(namef).event=struct;
            else
                disp([str{k}, 'extracting to zoo'])
                data.(str{k}).line= data1(:,k);
                data.(str{k}).event=struct;
            end
        end
        ch=fieldnames(data);
        data.zoosystem.Video.Channels= ch(2:end);
    end
    
  
    if del
        delete(fl{i})
    end
    
    if saveFile
        zfl=[fpath,filesep,fname,'.zoo'];
        zsave(zfl,data)
    else
        disp(' ')
        disp('zoo file loaded to workspace')
        disp(' ')
    end
    
    
    
end
disp(' ')
disp('**********************************')
disp('Finished converting data in: ')
toc
disp('**********************************')


function data=GI_sheet(data,filename,sheetname)
[~,~,num] = xlsread(filename,sheetname);
data.zoosystem = setZoosystem(filename);
data.zoosystem.Units = struct;
a=findstr(filename,'/');
Submane=filename(a(length(a))+1:length(filename)-5);
data.zoosystem.Header.Subname = Submane;
if contains(filename,'asphalt')
    surface='asphalt';
elseif contains(filename,'grass')
    surface='grass';
elseif contains(filename,'sidewalk')
    surface='asphalt';
elseif contains(filename,'gravel')
    surface='gravel';
end
data.zoosystem.Header.Surface = surface;
data.zoosystem.Header.TrialNum = {};
data.zoosystem.Header.TrialDuration = [];
data.zoosystem.Header.RecordedDate = datestr(num{4,2});
data.zoosystem.Header.MVN_version = num{1,2};
data.zoosystem.Header.Suit_Label = num{3,2};
data.zoosystem.Header.Processing_Quality = num{6,2};
data.zoosystem.Video.Freq = 1926;
data.zoosystem.AVR = 0;
data.zoosystem.Video.ORIGINAL_START_FRAME = 1;
data.zoosystem.Video.CURRENT_START_FRAME  = 1;