function outdoor_heel_strike_detect(fld, PeakLim)

% fld is path to data folder

if nargin ==0
    fld = uigetfolder;
    PeakLim = 0.7;
end

fl = engine('fld', fld, 'extension', 'zoo');
for i = 1:length(fl)
    batchdisp(fl{i})
    data = load(fl{i},'-mat');
    data = data.data;
    data = heel_strike_detect_data(data, PeakLim);
    zsave(fl{i},data)
end


function data = heel_strike_detect_data(data, PeakLim)

g_x = data.shankR_Gyr_X.line;
g_y = data.shankR_Gyr_Y.line;
g_z = data.shankR_Gyr_Z.line;
Gmag=sqrt(g_x.^2 + g_y.^2 + g_z.^2); %Normalized Gyro Data

HS = Heelstrike_Detection(Gmag,PeakLim);

for i = 1:length(HS)
    data.shankR_Gyr_X.event.(['HS',num2str(i)]) = [HS(i) 0 0]; 
end


