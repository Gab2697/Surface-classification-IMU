function IMU_outdoor_organize(fld, surfaces_keep)

% IMU_outdoor_surface_process
%
% Organizes files by subject and surfaces for the imu outdoor surfaces
% project

cd(fld);
fl=engine('path',fld,'extension','.zoo');

for i=1:length(fl)
    [~, fname, ext] = fileparts(fl{i});
    indx = strfind(fname, '_');
    data=zload(fl{i});
    if contains(fname,'asphalt')
        surface='asphalt';
    elseif contains(fname,'grass')
        surface='grass';
    elseif contains(fname,'sidewalk')
        surface='asphalt';
    elseif contains(fname,'gravel')
        surface='gravel';
    end
    a=findstr(fname,'\');
    subject=fname(a(length(a))+1:length(fname)-5);
    
    %surface = data.zoosystem.Header.Surface;
%     subject=data.zoosystem.Header.Subname;
    
    if ~ismember(surface, surfaces_keep)
        delfile(fl{i})
    else
        
%         subject = data.zoosystem.Header.Subname;
        a=findstr(subject,'_');
        subject=subject(1:a-1);
        fileLocation_new = [fld, filesep,subject, filesep,surface];
        disp(['moving from ', fl{i}])
        disp(['moving to   ', fileLocation_new])
        
        if ~exist(fileLocation_new,'dir')
            mkdir(fileLocation_new)
        end
        
        movefile(fl{i},[fileLocation_new, filesep, fname, ext])
    end
end





