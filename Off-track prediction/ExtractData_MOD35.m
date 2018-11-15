%%%%%%%%%%%%%%%%%%%%%%
% Combine HDF Files into a single struct
%%%%%%%%%

%% Clear windows and workspace                                                                                
clc;
clear
tic

%% MOD35
  
temp_dir = dir(['Data/MOD35/' '**/*.hdf' ]);
NFiles = size(temp_dir,1);
Filesname = cell(NFiles,1);
for i = 1:NFiles
    Filesname{i} = temp_dir(i).name;
end

clear temp_dir

% General 
Latitude = [];
Longitude = [];
Cloud_Mask = [];
Cloud_Mask2 = [];
datasampling=5;


for loop3 = 1:NFiles
    temp_dir = ['Data/MOD35/' Filesname{loop3}];
    
    temp_Latitude = hdfread(temp_dir,'Latitude');
    temp_Longitude = hdfread(temp_dir,'Longitude');
    
    temp_Cloud_Mask_struct = readModisCloudMask(temp_dir);
    temp_Cloud_Mask = temp_Cloud_Mask_struct.byte1.mask;
%     temp_CM1 = squeeze(temp_Cloud_Mask(1,1:5:end,1:5:end));
%     temp_CM2 = squeeze(temp_Cloud_Mask(2,1:5:end,1:5:end));
    
    Latitude = [Latitude; temp_Latitude(1:datasampling:end,1:5:end)];
    Longitude = [Longitude; temp_Longitude(1:datasampling:end,1:5:end)];
    Cloud_Mask = [Cloud_Mask; temp_Cloud_Mask(1:datasampling:end,1:5:end)];
    %Cloud_Mask2 = [Cloud_Mask2; temp_CM2];
end

MOD35.Latitude = Latitude;
MOD35.Longitude = Longitude;
MOD35.Cloud_Mask = Cloud_Mask;
% MOD35.Cloud_Mask2 = Cloud_Mask2;

save MOD35.mat MOD35 -v7.3
movefile('MOD35.mat','Data/'); 
toc