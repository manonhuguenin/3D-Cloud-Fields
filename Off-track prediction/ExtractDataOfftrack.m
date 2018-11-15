%%%%%%%%%%%%%%%%%%%%%%
% Combine HDF Files into a single struct
%%%%%%%%%

%% Clear windows and workspace                                                                                
clc;
clear
tic
%% MOD02
  
% temp_dir = dir(['Data/MOD02/' '**/*.hdf' ]);
% NFiles = size(temp_dir,1);
% Filesname = cell(NFiles,1);
% for i = 1:NFiles
%     Filesname{i} = temp_dir(i).name;
% end
% 
% clear temp_dir
Filesnames=load('filenamesMOD35.mat');
Filesnames35=Filesnames.Filesname;
NFiles=161;
[Filesname02,Filesname03]=generatefilenames(Filesnames35);

% General 
Latitude = [];
Longitude = [];
EV_1KM=[];
EV_500=[];
EV_250=[];

%Radiance extraction

band1_scale=0.026865;
band2_scale=0.010071;

band3_scale=0.034336;
band4_scale=0.023425;
band5_scale=0.0057775;
band6_scale=0.0026437;
band7_scale=0.00080975;

band17_scale=0.0072237;
band18_scale=0.0089053;
band19_scale=0.0069353;
band26_scale=0.0030554;

offsets17to26=316.9722;

Band_1_tot=[];
Band_2_tot=[];
Band_3_tot = [];
Band_4_tot = [];
Band_5_tot = [];
Band_6_tot = [];
Band_7_tot = [];
Band_17_tot = [];
Band_18_tot = [];
Band_19_tot = [];
Band_26_tot = [];

%Exploring each file
for loop3 = 1:NFiles
    temp_dir = dir(['Data/MOD02/*' Filesname02{loop3} '*.hdf']);
    temp_dir = ['Data/MOD02/' temp_dir.name];
    
    temp_Latitude = hdfread(temp_dir,'Latitude');
    temp_Longitude = hdfread(temp_dir,'Longitude');
    temp_EV_1KM = hdfread(temp_dir,'EV_1KM_RefSB');
    temp_EV_500 = hdfread(temp_dir,'EV_500_Aggr1km_RefSB');
    temp_EV_250 = hdfread(temp_dir,'EV_250_Aggr1km_RefSB');
    
    Band_1_raw = squeeze(temp_EV_250(1,1:5:end,1:5:end));
    Band_2_raw = squeeze(temp_EV_250(2,1:5:end,1:5:end));
    Band_3_raw = squeeze(temp_EV_500(1,1:5:end,1:5:end));
    Band_4_raw = squeeze(temp_EV_500(2,1:5:end,1:5:end));
    Band_5_raw = squeeze(temp_EV_500(3,1:5:end,1:5:end));
    Band_6_raw = squeeze(temp_EV_500(4,1:5:end,1:5:end));
    Band_7_raw = squeeze(temp_EV_500(5,1:5:end,1:5:end));
    Band_17_raw = squeeze(temp_EV_1KM(12,1:5:end,1:5:end));
    Band_18_raw = squeeze(temp_EV_1KM(13,1:5:end,1:5:end));
    Band_19_raw = squeeze(temp_EV_1KM(14,1:5:end,1:5:end));
    Band_26_raw = squeeze(temp_EV_1KM(15,1:5:end,1:5:end));
    
    

    
    Latitude = [Latitude; temp_Latitude];
    Longitude = [Longitude; temp_Longitude];
    Band_1_tot = [Band_1_tot;band1_scale*Band_1_raw];
    Band_2_tot = [Band_2_tot;band2_scale*Band_2_raw];
    Band_3_tot = [Band_3_tot;band3_scale*Band_3_raw];
    Band_4_tot = [Band_4_tot;band4_scale*Band_4_raw];
    Band_5_tot = [Band_5_tot;band5_scale*Band_5_raw];
    Band_6_tot = [Band_6_tot;band6_scale*Band_6_raw];
    Band_7_tot = [Band_7_tot;band7_scale*Band_7_raw];
    Band_17_tot = [Band_17_tot;band17_scale*(Band_17_raw-offsets17to26)];
    Band_18_tot = [Band_18_tot;band18_scale*(Band_18_raw-offsets17to26)];
    Band_19_tot = [Band_19_tot;band19_scale*(Band_19_raw-offsets17to26)];
    Band_26_tot = [Band_26_tot;band26_scale*(Band_26_raw-offsets17to26)];
    loop3
end


MOD02.Latitude = Latitude;
MOD02.Longitude = Longitude;
MOD02.Band_1_tot = Band_1_tot;
MOD02.Band_2_tot = Band_2_tot;
MOD02.Band_3_tot = Band_3_tot;
MOD02.Band_4_tot = Band_4_tot;
MOD02.Band_5_tot = Band_5_tot;
MOD02.Band_6_tot = Band_6_tot;
MOD02.Band_7_tot = Band_7_tot;
MOD02.Band_17_tot = Band_17_tot;
MOD02.Band_18_tot = Band_18_tot;
MOD02.Band_19_tot = Band_19_tot;
MOD02.Band_26_tot = Band_26_tot;
save MOD02_35.mat MOD02 '-v7.3'
movefile('MOD02_35.mat','Data/'); 

toc
%% MOD03
%   
% temp_dir = dir(['Data/MOD03/' '**/*.hdf' ]);
% NFiles = size(temp_dir,1);
% Filesname = cell(NFiles,1);
% for i = 1:NFiles
%     Filesname{i} = temp_dir(i).name;
% end
% 
% clear temp_dir

% General 
Latitude = [];
Longitude = [];
Time = [];
LandSeaMask = [];
Height = [];
HeightOffset = [];
datasampling=5;

for loop3 = 1:NFiles
    temp_dir = dir(['Data/MOD03/*' Filesname03{loop3} '*.hdf']);
    temp_dir = ['Data/MOD03/' temp_dir.name];
    
    temp_Latitude = hdfread(temp_dir,'Latitude');
    temp_Longitude = hdfread(temp_dir,'Longitude');
    
    numbreadings=size(temp_Latitude(1:datasampling:end,1:5:end));
    temp_Time_unit = gettingtimefromfilename(Filesname03{loop3});
    temp_Time = temp_Time_unit*ones(numbreadings(1),1);
    
    temp_LandSeaMask = hdfread(temp_dir,'Land/SeaMask');
    temp_Height = hdfread(temp_dir,'Height');
    temp_HeightOffset = hdfread(temp_dir,'Height Offset');
    
    Latitude = [Latitude; temp_Latitude(1:datasampling:end,1:5:end)];
    Longitude = [Longitude; temp_Longitude(1:datasampling:end,1:5:end)];
    LandSeaMask = [LandSeaMask; temp_LandSeaMask(1:datasampling:end,1:5:end)];
    Height = [Height; temp_Height(1:datasampling:end,1:5:end)];
    HeightOffset = [HeightOffset; temp_HeightOffset(1:datasampling:end,1:5:end)];
    Time = [Time; temp_Time];
end

MOD03.Latitude = Latitude;
MOD03.Longitude = Longitude;
MOD03.LandSeaMask = LandSeaMask;
MOD03.Height = Height;
MOD03.HeightOffset = HeightOffset;
MOD03.Time = Time;

save MOD03_35.mat MOD03 -v7.3
movefile('MOD03_35.mat','Data/'); 
toc