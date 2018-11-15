%%%%%%%%%%%%%%%%%%%%%%
% Combine HDF Files into a single struct
%%%%%%%%%

%% Clear windows and workspace                                                                                
clc;
clear

%% Extract Database Folder Information
NDataFolder = 4;                            % Number of Files
temp_dir = dir('Data');                      % Look up folder name
number_dir=size(temp_dir);
number_dir=number_dir(1);                       %Count number of folders in Data directory
Database_Foldername = cell(NDataFolder,1);   % Create cell to store folder name
% Save all foldername
j=1;
for i = 1:number_dir
    k=strfind(temp_dir(i).name,'Data');
    if size(k)>0
        Database_Foldername{j} = temp_dir(i).name;
        j=j+1;
    end
end

clear temp_dir number_dir j k i
%% Extract Folder Information
for loop1 = 1:NDataFolder
    temp_dir = dir(['Data/' Database_Foldername{loop1}]);
    NDataSubFolder = size(temp_dir,1); %-2
    SubFoldername = cell(NDataSubFolder,1);
    for i = 1:NDataSubFolder
        SubFoldername{i} = temp_dir(i).name; %i+2
    end

    clear temp_dir
    %% Extract Filenames
    for loop2 = 1:NDataSubFolder
        temp_dir = dir(['Data/' Database_Foldername{loop1} '/'...
                        SubFoldername{loop2} '/**/*.hdf' ]);
        NFiles = size(temp_dir,1);
        Filesname = cell(NFiles,1);
        for i = 1:NFiles
            Filesname{i} = temp_dir(i).name;
        end

        clear temp_dir
        %% Variables Matrix Placeholder
        % General 
        Latitude = [];
        Longitude = [];
        % GEOPROF-LIDAR
        CloudFraction = [];
        CloudLayers = [];
        LayerTop = [];
        LayerBase = [];
        CloudLiquidWater=[];
        Height = [];
        Profile_time=[];
        Elevation=[];
        
        %GEOPROF
        CloudMask=[];
        
        % MODIS
        EV_250_RefSB_rad_offsets = {};
        EV_250_RefSB_rad_scales = {};
        EV_250_RefSB = {};      
        EV_500_RefSB_rad_offsets = {};
        EV_500_RefSB_rad_scales = {};
        EV_500_RefSB = {};
        EV_1KM_RefSB_rad_offsets = {};
        EV_1KM_RefSB_rad_scales = {};
        EV_1KM_RefSB = {};
        MODIS_granule_index = {};
        % PRECIP-COLUMN
        Surface_type = [];
        % Rain-Profile
        Cloud_Liquid_Water = [];
        % Ice
        Ice_Water_Content = [];
        % CLDClass-Lidar
        Cloud_Layer = [];
        Cloud_Layer_Base = [];
        Cloud_Layer_Top = [];
        Cloud_Phase = [];
        Cloud_Layer_Type = [];
        %% Extract information
        for loop3 = 1:NFiles
            temp_dir = ['Data/' Database_Foldername{loop1} '/'...
                        SubFoldername{loop2} '/' Filesname{loop3}];
            switch SubFoldername{loop2}
                case 'CLOUDSAT-POES'
                case 'ECMWF-AUX'
                case 'GEOPROF-LIDAR'
                    temp_Latitude = hdfread(temp_dir,'Latitude');
                    temp_Longitude = hdfread(temp_dir,'Longitude');
                    temp_CloudFraction = hdfread(temp_dir,'CloudFraction');
                    temp_CloudLayers = hdfread(temp_dir,'CloudLayers');
                    temp_LayerTop = hdfread(temp_dir,'LayerTop');
                    temp_LayerBase = hdfread(temp_dir,'LayerBase');
                    temp_Height = hdfread(temp_dir,'Height');
                    temp_PT = hdfread(temp_dir,'Profile_time');
                    temp_elevation=hdfread(temp_dir,'DEM_elevation');
                    Latitude = [Latitude;temp_Latitude];
                    Longitude = [Longitude;temp_Longitude];
                    CloudFraction = [CloudFraction;temp_CloudFraction];
                    CloudLayers = [CloudLayers;temp_CloudLayers];
                    LayerTop = [LayerTop;temp_LayerTop];
                    LayerBase = [LayerBase;temp_LayerBase];
                    Height = [Height;temp_Height];
                    Profile_time = [Profile_time;temp_PT];
                    Elevation=[Elevation;temp_elevation];
                    
                case 'GEOPROF'
                    temp_Latitude = hdfread(temp_dir,'Latitude');
                    temp_Longitude = hdfread(temp_dir,'Longitude');
                    temp_CloudFraction = hdfread(temp_dir,'MODIS_Cloud_Fraction');
                    temp_Cloudmask = hdfread(temp_dir,'CPR_Cloud_mask');
                    temp_Height = hdfread(temp_dir,'Height');
                    Latitude = [Latitude;temp_Latitude];
                    Longitude = [Longitude;temp_Longitude];
                    CloudFraction = [CloudFraction;temp_CloudFraction];
                    CloudMask = [CloudMask;temp_Cloudmask];
                    Height = [Height;temp_Height];
                    
                    
                case 'MODIS-AUX'
                    if loop3 == 1
                        Latitude = {};
                        Longitude = {};
                    end
                    temp_EV_250_RefSB_rad_offsets = hdfread(temp_dir,'EV_250_RefSB_rad_offsets');
                    temp_EV_250_RefSB_rad_scales = hdfread(temp_dir,'EV_250_RefSB_rad_scales');
                    temp_EV_250_RefSB = hdfread(temp_dir,'EV_250_RefSB');        
                    temp_EV_500_RefSB_rad_offsets = hdfread(temp_dir,'EV_500_RefSB_rad_offsets');
                    temp_EV_500_RefSB_rad_scales = hdfread(temp_dir,'EV_500_RefSB_rad_scales');
                    temp_EV_500_RefSB = hdfread(temp_dir,'EV_500_RefSB');
                    temp_EV_1KM_RefSB_rad_offsets = hdfread(temp_dir,'EV_1KM_RefSB_rad_offsets');
                    temp_EV_1KM_RefSB_rad_scales = hdfread(temp_dir,'EV_1KM_RefSB_rad_scales');
                    temp_EV_1KM_RefSB = hdfread(temp_dir,'EV_1KM_RefSB');
                    temp_MODIS_granule_index = hdfread(temp_dir,'MODIS_granule_index');
                    temp_Latitude = hdfread(temp_dir,'MODIS_latitude');
                    temp_Longitude = hdfread(temp_dir,'MODIS_longitude');
                    EV_250_RefSB_rad_offsets{loop3,1} = temp_EV_250_RefSB_rad_offsets;
                    EV_250_RefSB_rad_scales{loop3,1} = temp_EV_250_RefSB_rad_scales;
                    EV_250_RefSB{loop3,1} = temp_EV_250_RefSB;
                    EV_500_RefSB_rad_offsets{loop3,1} = temp_EV_500_RefSB_rad_offsets;
                    EV_500_RefSB_rad_scales{loop3,1} = temp_EV_500_RefSB_rad_scales;
                    EV_500_RefSB{loop3,1} = temp_EV_500_RefSB;
                    EV_1KM_RefSB_rad_offsets{loop3,1} = temp_EV_1KM_RefSB_rad_offsets;
                    EV_1KM_RefSB_rad_scales{loop3,1} = temp_EV_1KM_RefSB_rad_scales;
                    EV_1KM_RefSB{loop3,1} = temp_EV_1KM_RefSB;
                    MODIS_granule_index{loop3,1} = temp_MODIS_granule_index;
                    Latitude{loop3,1} = temp_Latitude;
                    Longitude{loop3,1} = temp_Longitude;
                case 'PRECIP-COLUMN'
                    temp_Surface_type = hdfread(temp_dir,'Surface_type');
                    temp_Latitude = hdfread(temp_dir,'Latitude');
                    temp_Longitude = hdfread(temp_dir,'Longitude');
                    Surface_type = [Surface_type;temp_Surface_type];
                    Latitude = [Latitude;temp_Latitude];
                    Longitude = [Longitude;temp_Longitude];
                case 'RAIN-PROFILE'
                    temp_Latitude = hdfread(temp_dir,'Latitude');
                    temp_Longitude = hdfread(temp_dir,'Longitude');
                    temp_Cloud_Liquid_Water = hdfread(temp_dir,'cloud_liquid_water');
                    Cloud_Liquid_Water = [Cloud_Liquid_Water;temp_Cloud_Liquid_Water];
                    Latitude = [Latitude;temp_Latitude];
                    Longitude = [Longitude;temp_Longitude];
                case 'ICE'
                    temp_Latitude = hdfread(temp_dir,'Latitude');
                    temp_Longitude = hdfread(temp_dir,'Longitude');   
                    temp_Ice_Water_Content = hdfread(temp_dir,'IWC');
                    Ice_Water_Content = [Ice_Water_Content;temp_Ice_Water_Content];
                    Latitude = [Latitude;temp_Latitude];
                    Longitude = [Longitude;temp_Longitude];
                case 'CLDCLASS-LIDAR'
                    temp_Latitude = hdfread(temp_dir,'Latitude');
                    temp_Longitude = hdfread(temp_dir,'Longitude');  
                    temp_Cloud_Layer = hdfread(temp_dir,'Cloudlayer');
                    temp_Cloud_Layer_Base = hdfread(temp_dir,'CloudLayerBase');
                    temp_Cloud_Layer_Top = hdfread(temp_dir,'CloudLayerTop');
                    temp_Cloud_Layer_Type = hdfread(temp_dir,'CloudLayerType');
                    temp_Cloud_Phase = hdfread(temp_dir,'CloudPhase');
                    Latitude = [Latitude;temp_Latitude];
                    Longitude = [Longitude;temp_Longitude];
                    Cloud_Layer = [Cloud_Layer;temp_Cloud_Layer];
                    Cloud_Layer_Base = [Cloud_Layer_Base;temp_Cloud_Layer_Base];
                    Cloud_Layer_Top = [Cloud_Layer_Top;temp_Cloud_Layer_Top];
                    Cloud_Layer_Type = [Cloud_Layer_Type;temp_Cloud_Layer_Type];
                    Cloud_Phase = [Cloud_Phase;temp_Cloud_Phase];
            end
            %% Save Extract Data to Struct and Save
            if loop3 == NFiles
                switch SubFoldername{loop2}
                    case 'CLOUDSAT-POES'
                    case 'ECMWF-AUX'
                    case 'GEOPROF-LIDAR'
                        Geoprof_Lidar.Latitude = Latitude;
                        Geoprof_Lidar.Longitude = Longitude;
                        Geoprof_Lidar.CloudFraction = CloudFraction;
                        Geoprof_Lidar.CloudLayers = CloudLayers;
                        Geoprof_Lidar.LayerTop = LayerTop;
                        Geoprof_Lidar.LayerBase =LayerBase;
                        Geoprof_Lidar.Height = Height;
                        Geoprof_Lidar.Profile_time=Profile_time;
                        Geoprof_Lidar.Elevation=Elevation;
                        save Geoprof_Lidar.mat Geoprof_Lidar
                        movefile('Geoprof_Lidar.mat',['Data/' Database_Foldername{loop1}]);
                        
                        
                    case 'GEOPROF'
                        Geoprof.Latitude = Latitude;
                        Geoprof.Longitude = Longitude;
                        Geoprof.CloudFraction = CloudFraction;
                        Geoprof.CloudMask = CloudMask;
                        Geoprof.Height = Height;
                        save Geoprof.mat Geoprof
                        movefile('Geoprof.mat',['Data/' Database_Foldername{loop1}]);
                        
                    case 'MODIS-AUX'
                        Modis.Latitude = Latitude;
                        Modis.Longitude = Longitude;
                        Modis.EV_250_RefSB_rad_offsets = EV_250_RefSB_rad_offsets;
                        Modis.EV_250_RefSB_rad_scales = EV_250_RefSB_rad_scales;
                        Modis.EV_250_RefSB = EV_250_RefSB;    
                        Modis.EV_500_RefSB_rad_offsets = EV_500_RefSB_rad_offsets;
                        Modis.EV_500_RefSB_rad_scales = EV_500_RefSB_rad_scales;
                        Modis.EV_500_RefSB = EV_500_RefSB;
                        Modis.EV_1KM_RefSB_rad_offsets = EV_1KM_RefSB_rad_offsets;
                        Modis.EV_1KM_RefSB_rad_scales = EV_1KM_RefSB_rad_scales;
                        Modis.EV_1KM_RefSB = EV_1KM_RefSB;
                        Modis.MODIS_granule_index = MODIS_granule_index;
                        save Modis.mat Modis
                        movefile('Modis.mat',['Data/' Database_Foldername{loop1}]);
                        
                        %% Correspond Geoprof_Lidar
                        temp_dir2 = ['Data/' Database_Foldername{loop1} '/Geoprof_Lidar.mat'];

                        %% Files
                        load(temp_dir2);

                        %% Extraction Longitude and Latitude of Geoprof_Lidar;
                        GeoLatitude = [];
                        GeoLongitude = [];
                        for i = 1:size(Geoprof_Lidar.Latitude,1)
                            GeoLatitude = [GeoLatitude;Geoprof_Lidar.Latitude{i,1}'];
                            GeoLongitude = [GeoLongitude;Geoprof_Lidar.Longitude{i,1}'];
                        end
                        clear GeoProf_Lidar
                        %% Extraction of Longitude and Latitude of Modis;
                        ModisLatitude = [];
                        ModisLongitude = [];
                        for i = 1:size(Modis.Latitude,1)
                            ModisLatitude = [ModisLatitude;Modis.Latitude{i,:}];
                            ModisLongitude = [ModisLongitude;Modis.Longitude{i,:}];
                        end

                        %% Raw Radiance Reading
                        % Band number that the reading is coming from 
                        % band reference: https://modis.gsfc.nasa.gov/about/specifications.php
                        
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
                        
                        for i = 1:size(Modis.Latitude,1)
                            Band_1 = [];
                            Band_2 = [];
                            Band_3 = [];
                            Band_4 = [];
                            Band_5 = [];
                            Band_6 = [];
                            Band_7 = [];
                            Band_17 = [];
                            Band_18 = [];
                            Band_19 = [];
                            Band_26 = [];
                            
                            granule8 = MODIS_granule_index{i,1}(:,8);
                            
                            Band_1_raw = EV_250_RefSB{i, 1}(1,:,8);
                            Band_2_raw = EV_250_RefSB{i, 1}(2,:,8);
                            Band_3_raw = EV_500_RefSB{i, 1}(1,:,8);
                            Band_4_raw = EV_500_RefSB{i, 1}(2,:,8);
                            Band_5_raw = EV_500_RefSB{i, 1}(3,:,8);
                            Band_6_raw = EV_500_RefSB{i, 1}(4,:,8);
                            Band_7_raw = EV_500_RefSB{i, 1}(5,:,8);
                            Band_17_raw = EV_1KM_RefSB{i, 1}(1,:,8);
                            Band_18_raw = EV_1KM_RefSB{i, 1}(2,:,8);
                            Band_19_raw = EV_1KM_RefSB{i, 1}(3,:,8);
                            Band_26_raw = EV_1KM_RefSB{i, 1}(4,:,8);
                           
                            Band_1_offsets = EV_250_RefSB_rad_offsets{i,1}(1,:);
                            Band_2_offsets  = EV_250_RefSB_rad_offsets{i,1}(2,:);
                            Band_3_offsets = EV_500_RefSB_rad_offsets{i, 1}(1,:);
                            Band_4_offsets = EV_500_RefSB_rad_offsets{i, 1}(2,:);
                            Band_5_offsets = EV_500_RefSB_rad_offsets{i, 1}(3,:);
                            Band_6_offsets = EV_500_RefSB_rad_offsets{i, 1}(4,:);
                            Band_7_offsets = EV_500_RefSB_rad_offsets{i, 1}(5,:);
                            Band_17_offsets = EV_1KM_RefSB_rad_offsets{i, 1}(1,:);
                            Band_18_offsets = EV_1KM_RefSB_rad_offsets{i, 1}(2,:);
                            Band_19_offsets = EV_1KM_RefSB_rad_offsets{i, 1}(3,:);
                            Band_26_offsets = EV_1KM_RefSB_rad_offsets{i, 1}(4,:);
                            
                            Band_1_scales = EV_250_RefSB_rad_scales{i,1}(1,:);
                            Band_2_scales  = EV_250_RefSB_rad_scales{i,1}(2,:);
                            Band_3_scales = EV_500_RefSB_rad_scales{i, 1}(1,:);
                            Band_4_scales = EV_500_RefSB_rad_scales{i, 1}(2,:);
                            Band_5_scales = EV_500_RefSB_rad_scales{i, 1}(3,:);
                            Band_6_scales = EV_500_RefSB_rad_scales{i, 1}(4,:);
                            Band_7_scales = EV_500_RefSB_rad_scales{i, 1}(5,:);
                            Band_17_scales = EV_1KM_RefSB_rad_scales{i, 1}(1,:);
                            Band_18_scales = EV_1KM_RefSB_rad_scales{i, 1}(2,:);
                            Band_19_scales = EV_1KM_RefSB_rad_scales{i, 1}(3,:);
                            Band_26_scales = EV_1KM_RefSB_rad_scales{i, 1}(4,:);
                            
                            for j=1:length(granule8)
                                granule_number=granule8(j);
                                if granule_number<1
                                    Band_1=[Band_1 ; 32768];
                                    Band_2=[Band_2 ; 32768];
                                    Band_3=[Band_3 ; 32768];
                                    Band_4=[Band_4 ; 32768];
                                    Band_5=[Band_5 ; 32768];
                                    Band_6=[Band_6 ; 32768];
                                    Band_7=[Band_7 ; 32768];
                                    Band_17=[Band_17 ; 32768];
                                    Band_18=[Band_18 ; 32768];
                                    Band_19=[Band_19 ; 32768];
                                    Band_26=[Band_26 ; 32768];
                                else
                                    offset1j=double(Band_1_offsets(granule_number));
                                    scale1j=double(Band_1_scales(granule_number));
                                    Band_1=[Band_1 ; scale1j*(Band_1_raw(j)-offset1j)];
                                    
                                    offset2j=double(Band_2_offsets(granule_number));
                                    scale2j=double(Band_2_scales(granule_number));
                                    Band_2=[Band_2 ; scale2j*(Band_2_raw(j)-offset2j)];
                                    
                                    offset3j=double(Band_3_offsets(granule_number));
                                    scale3j=double(Band_3_scales(granule_number));
                                    Band_3=[Band_3 ; scale3j*(Band_3_raw(j)-offset3j)];
                                    
                                    offset4j=double(Band_4_offsets(granule_number));
                                    scale4j=double(Band_4_scales(granule_number));
                                    Band_4=[Band_4 ; scale4j*(Band_4_raw(j)-offset4j)];
                                    
                                    offset5j=double(Band_5_offsets(granule_number));
                                    scale5j=double(Band_5_scales(granule_number));
                                    Band_5=[Band_5 ; scale5j*(Band_5_raw(j)-offset5j)];
                                    
                                    offset6j=double(Band_6_offsets(granule_number));
                                    scale6j=double(Band_6_scales(granule_number));
                                    Band_6=[Band_6 ; scale6j*(Band_6_raw(j)-offset6j)];
                                    
                                    offset7j=double(Band_7_offsets(granule_number));
                                    scale7j=double(Band_7_scales(granule_number));
                                    Band_7=[Band_7 ; scale7j*(Band_7_raw(j)-offset7j)];
                                    
                                    offset17j=double(Band_17_offsets(granule_number));
                                    scale17j=double(Band_17_scales(granule_number));
                                    Band_17=[Band_17 ; scale17j*(Band_17_raw(j)-offset17j)];
                                    
                                    offset18j=double(Band_18_offsets(granule_number));
                                    scale18j=double(Band_18_scales(granule_number));
                                    Band_18=[Band_18 ; scale18j*(Band_18_raw(j)-offset18j)];
                                    
                                    offset19j=double(Band_19_offsets(granule_number));
                                    scale19j=double(Band_19_scales(granule_number));
                                    Band_19=[Band_19 ; scale19j*(Band_19_raw(j)-offset19j)];
                                    
                                    offset26j=double(Band_26_offsets(granule_number));
                                    scale26j=double(Band_26_scales(granule_number));
                                    Band_26=[Band_26 ; scale26j*(Band_26_raw(j)-offset26j)];
       
                                end
                            end
                            
                            Band_1_tot=[Band_1_tot ; Band_1];
                            Band_2_tot=[Band_2_tot ; Band_2];
                            Band_3_tot=[Band_3_tot ; Band_3];
                            Band_4_tot=[Band_4_tot ; Band_4];
                            Band_5_tot=[Band_5_tot ; Band_5];
                            Band_6_tot=[Band_6_tot ; Band_6];
                            Band_7_tot=[Band_7_tot ; Band_7];
                            Band_17_tot=[Band_17_tot ; Band_17];
                            Band_18_tot=[Band_18_tot ; Band_18];
                            Band_19_tot=[Band_19_tot ; Band_19];
                            Band_26_tot=[Band_26_tot ; Band_26];
                        end
                        
                        
                        Modis_Radiance.Band_1 = Band_1_tot;
                        Modis_Radiance.Band_2 = Band_2_tot;
                        Modis_Radiance.Band_3 = Band_3_tot;
                        Modis_Radiance.Band_4 = Band_4_tot;
                        Modis_Radiance.Band_5 = Band_5_tot;
                        Modis_Radiance.Band_6 = Band_6_tot;
                        Modis_Radiance.Band_7 = Band_7_tot;
                        Modis_Radiance.Band_17 = Band_17_tot;
                        Modis_Radiance.Band_18 = Band_18_tot;
                        Modis_Radiance.Band_19 = Band_19_tot;
                        Modis_Radiance.Band_26 = Band_26_tot;
                        Modis_Radiance.Latitude = GeoLatitude;
                        Modis_Radiance.Longitude = GeoLongitude;
                        
                        save Modis_Radiance.mat Modis_Radiance
                        movefile('Modis_Radiance.mat',['Data/' Database_Foldername{loop1}]);
                        %}
                    case 'PRECIP-COLUMN'
                        Precip_Column.Latitude = Latitude;
                        Precip_Column.Longitude = Longitude;
                        Precip_Column.Surface_type = Surface_type;
                        save Precip_Column.mat Precip_Column
                        movefile('Precip_Column.mat',['Data/' Database_Foldername{loop1}]);
                    case 'RAIN-PROFILE'
                        Rain_Profile.Latitude = Latitude;
                        Rain_Profile.Longitude = Longitude;
                        Rain_Profile.Cloud_Liquid_Water = Cloud_Liquid_Water;
                        save Rain_Profile.mat Rain_Profile
                        movefile('Rain_Profile.mat',['Data/' Database_Foldername{loop1}]);
                    case 'ICE'
                        Ice.Latitude = Latitude;
                        Ice.Longitude = Longitude;     
                        Ice.Ice_Water_Content = Ice_Water_Content;
                        save Ice.mat Ice
                        movefile('Ice.mat',['Data/' Database_Foldername{loop1}]);
                    case 'CLDCLASS-LIDAR'
                        CLDCLASS_Lidar.Latitude = Latitude;
                        CLDCLASS_Lidar.Longitude = Longitude; 
                        CLDCLASS_Lidar.Cloud_Layer = Cloud_Layer;
                        CLDCLASS_Lidar.Cloud_Layer_Base = Cloud_Layer_Base;
                        CLDCLASS_Lidar.Cloud_Layer_Top = Cloud_Layer_Top;
                        CLDCLASS_Lidar.Cloud_Layer_Type = Cloud_Layer_Type;
                        CLDCLASS_Lidar.Cloud_Phase = Cloud_Phase;
                        save CLDCLASS_Lidar.mat CLDCLASS_Lidar
                        movefile('CLDCLASS_Lidar.mat',['Data/' Database_Foldername{loop1}]);
                end
            % General 
            Latitude = [];
            Longitude = [];
            end
        end
    end
    for loop2 = 1:NDataSubFolder
        temp_dir = dir(['Data/' Database_Foldername{loop1} '/'...
                        SubFoldername{loop2} '/**/*.nc4' ]); 
        NFiles = size(temp_dir,1);
        Filesname = cell(NFiles,1);
        for i = 1:NFiles
            Filesname{i} = temp_dir(i).name;
        end

        clear temp_dir
        %% Variables Matrix Placeholder
        % MERRA-2
        SLP=[]; %Sea Level Pressure
        PS=[]; %Time avg surface pressure
        U850=[]; %Eastward wind at 850 hPa
        U500=[]; %Eastward wind at 500 hPa
        U250=[]; %Eastward wind at 250 hPa
        V850=[]; %Northward wind at 850 hPa
        V500=[]; %Northward wind at 500 hPa
        V250=[]; %Northward wind at 250 hPa
        T850=[]; %Temperature at 850 hPa
        T500=[]; %Temperature at 500 hPa
        T250=[]; %Temperature at 250 hPa
        Q850=[]; %Specific humidity at 850 hPa
        Q500=[]; %Specific humidity at 500 hPa
        Q250=[]; %Specific humidity at 250 hPa
        H1000=[]; %Height at 850 hPa
        H850=[]; %Height at 850 hPa
        H500=[]; %Height at 500 hPa
        H250=[]; %Height at 250 hPa
        OMEGA500=[]; %Vertical pressure velocity at 500 hPa
        U10M=[]; %Eastward wind at 10 m above displacement height
        U2M=[]; %Eastward wind at 2 m above displacement height
        U50M=[]; %Eastward wind at 50 m above surface
        V10M=[]; %Northward wind at 10 m above displacement height
        V2M=[]; %Northward wind at 2 m above displacement height
        V50M=[]; %Northward wind at 50 m above surface
        T10M=[]; %Temperature at 10 m above displacement height
        T2M=[]; %Temperature at 2 m above displacement height
        QV10M=[]; %Specific humidity at 10 m above displacement height
        QV2M=[]; %Specific humidity at 2 m above displacement height
        TS=[]; %Surface skin temperature
        DISPH=[]; %Displacement height
        TROPPV=[]; %PV related tropopause pressure
        TROPPT=[]; %T related tropopause pressure
        TROPPB=[]; %Blended tropopause pressure
        TROPT=[]; %Tropopause temperature
        TROPQ=[]; %Tropopause specific humidity
        CLDPRS=[]; %Cloud top pressure
        CLDTMP=[]; %Cloud top temperature 
        PBLTOP=[]; %Pbltop pressure
        T2MDEW=[]; %Dew point temperature at 2 m
        T2MWET=[]; %Wet bulb temperature at 2 m
        TO3=[]; %Total column ozone
        TOX=[]; %Total column odd oxygen
        TQI=[]; %Total precipitable ice water
        TQL=[]; %Total precipitable liquid water
        TQV=[]; %Total precipitable water vapor
        ZLCL=[]; %Lifting condensation level
        
        
        
        %% Extract information
        for loop3 = 1:NFiles
            temp_dir = ['Data/' Database_Foldername{loop1} '/'...
                        SubFoldername{loop2} '/' Filesname{loop3}];
            switch SubFoldername{loop2}               
                case 'MERRA-2'
                    temp_SLP=ncread(temp_dir,'SLP');
                    temp_PS=ncread(temp_dir,'PS');
                    temp_U850=ncread(temp_dir,'U850');
                    temp_U500=ncread(temp_dir,'U500');
                    temp_U250=ncread(temp_dir,'U250');
                    temp_V850=ncread(temp_dir,'V850');
                    temp_V500=ncread(temp_dir,'V500');
                    temp_V250=ncread(temp_dir,'V250');
                    temp_T850=ncread(temp_dir,'T850');
                    temp_T500=ncread(temp_dir,'T500');
                    temp_T250=ncread(temp_dir,'T250');
                    temp_Q850=ncread(temp_dir,'Q850');
                    temp_Q500=ncread(temp_dir,'Q500');
                    temp_Q250=ncread(temp_dir,'Q250');
                    temp_H1000=ncread(temp_dir,'H1000');
                    temp_H850=ncread(temp_dir,'H850');
                    temp_H500=ncread(temp_dir,'H500');
                    temp_H250=ncread(temp_dir,'H250');
                    temp_OMEGA500=ncread(temp_dir,'OMEGA500');
                    temp_U10M=ncread(temp_dir,'U10M');
                    temp_U2M=ncread(temp_dir,'U2M');
                    temp_U50M=ncread(temp_dir,'U50M');
                    temp_V10M=ncread(temp_dir,'V10M');
                    temp_V2M=ncread(temp_dir,'V2M');
                    temp_V50M=ncread(temp_dir,'V50M');
                    temp_T10M=ncread(temp_dir,'T10M');
                    temp_T2M=ncread(temp_dir,'T2M');
                    temp_QV10M=ncread(temp_dir,'QV10M');
                    temp_QV2M=ncread(temp_dir,'QV2M');
                    temp_TS=ncread(temp_dir,'TS');
                    temp_DISPH=ncread(temp_dir,'DISPH');
                    temp_TROPPV=ncread(temp_dir,'TROPPV');
                    temp_TROPPT=ncread(temp_dir,'TROPPT');
                    temp_TROPPB=ncread(temp_dir,'TROPPB');
                    temp_TROPT=ncread(temp_dir,'TROPT');
                    temp_TROPQ=ncread(temp_dir,'TROPQ');
                    temp_CLDPRS=ncread(temp_dir,'CLDPRS');
                    temp_CLDTMP=ncread(temp_dir,'CLDTMP');
                    temp_PBLTOP=ncread(temp_dir,'PBLTOP');
                    temp_T2MDEW=ncread(temp_dir,'T2MDEW');
                    temp_T2MWET=ncread(temp_dir,'T2MWET');
                    temp_TO3=ncread(temp_dir,'TO3');
                    temp_TOX=ncread(temp_dir,'TOX');
                    temp_TQI=ncread(temp_dir,'TQI');
                    temp_TQL=ncread(temp_dir,'TQL');
                    temp_TQV=ncread(temp_dir,'TQV');
                    temp_ZLCL=ncread(temp_dir,'ZLCL');
                    
                    SLP=[SLP ; temp_SLP]; 
                    PS=[PS ; temp_PS]; 
                    U850=[U850 ; temp_U850]; 
                    U500=[U500 ; temp_U500]; 
                    U250=[U250 ; temp_U250];
                    V850=[V850 ; temp_V850];
                    V500=[V500 ; temp_V500];
                    V250=[V250 ; temp_V250];
                    T850=[T850 ; temp_T850];
                    T500=[T500 ; temp_T500];
                    T250=[T250 ; temp_T250];
                    Q850=[Q850 ; temp_Q850];
                    Q500=[Q500 ; temp_Q500];
                    Q250=[Q250 ; temp_Q250];
                    H1000=[H1000 ; temp_H1000];
                    H850=[H850 ; temp_H850];
                    H500=[H500 ; temp_H500];
                    H250=[H250 ; temp_H250];
                    OMEGA500=[OMEGA500 ; temp_OMEGA500];
                    U10M=[U10M ; temp_U10M];
                    U2M=[U2M ; temp_U2M];
                    U50M=[U50M ; temp_U50M];
                    V10M=[V10M ; temp_V10M];
                    V2M=[V2M ; temp_V2M];
                    V50M=[V50M ; temp_V50M];
                    T10M=[T10M ; temp_T10M];
                    T2M=[T2M ; temp_T2M];
                    QV10M=[QV10M ; temp_QV10M];
                    QV2M=[QV2M ; temp_QV2M];
                    TS=[TS ; temp_TS];
                    DISPH=[DISPH ; temp_DISPH];
                    TROPPV=[DISPH ; temp_DISPH];
                    TROPPT=[TROPPT ; temp_TROPPT];
                    TROPPB=[TROPPB ; temp_TROPPB];
                    TROPT=[TROPT ; temp_TROPT];
                    TROPQ=[TROPQ ; temp_TROPQ];
                    CLDPRS=[CLDPRS ; temp_CLDPRS];
                    CLDTMP=[CLDTMP ; temp_CLDTMP];
                    PBLTOP=[PBLTOP ; temp_PBLTOP];
                    T2MDEW=[T2MDEW ; temp_T2MDEW];
                    T2MWET=[T2MWET ; temp_T2MWET];
                    TO3=[TO3 ; temp_TO3];
                    TOX=[TOX ; temp_TOX];
                    TQI=[TQI ; temp_TQI];
                    TQL=[TQL ; temp_TQL];
                    TQV=[TQV ; temp_TQV];
                    ZLCL=[ZLCL ; temp_ZLCL];
            end
            %% Save Extract Data to Struct and Save
            if loop3 == NFiles
                switch SubFoldername{loop2}
                    
                    case 'MERRA-2'
                        MERRA2.SLP=SLP; 
                        MERRA2.PS=PS; 
                        MERRA2.U850=U850; 
                        MERRA2.U500=U500; 
                        MERRA2.U250=U250;
                        MERRA2.V850=V850;
                        MERRA2.V500=V500;
                        MERRA2.V250=V250;
                        MERRA2.T850=T850;
                        MERRA2.T500=T500;
                        MERRA2.T250=T250;
                        MERRA2.Q850=Q850;
                        MERRA2.Q500=Q500;
                        MERRA2.Q250=Q250;
                        MERRA2.H1000=H1000;
                        MERRA2.H850=H850;
                        MERRA2.H500=H500;
                        MERRA2.H250=H250;
                        MERRA2.OMEGA500=OMEGA500;
                        MERRA2.U10M=U10M;
                        MERRA2.U2M=U2M;
                        MERRA2.U50M=U50M;
                        MERRA2.V10M=V10M;
                        MERRA2.V2M=V2M;
                        MERRA2.V50M=V50M;
                        MERRA2.T10M=T10M;
                        MERRA2.T2M=T2M;
                        MERRA2.QV10M=QV10M;
                        MERRA2.QV2M=QV2M;
                        MERRA2.TS=TS;
                        MERRA2.DISPH=DISPH;
                        MERRA2.TROPPV=DISPH;
                        MERRA2.TROPPT=TROPPT;
                        MERRA2.TROPPB=TROPPB;
                        MERRA2.TROPT=TROPT;
                        MERRA2.TROPQ=TROPQ;
                        MERRA2.CLDPRS=CLDPRS;
                        MERRA2.CLDTMP=CLDTMP;
                        MERRA2.PBLTOP=PBLTOP;
                        MERRA2.T2MDEW=T2MDEW;
                        MERRA2.T2MWET=T2MWET;
                        MERRA2.TO3=TO3;
                        MERRA2.TOX=TOX;
                        MERRA2.TQI=TQI;
                        MERRA2.TQL=TQL;
                        MERRA2.TQV=TQV;
                        MERRA2.ZLCL=ZLCL;
                        
                        save MERRA2.mat MERRA2
                        movefile('MERRA2.mat',['Data/' Database_Foldername{loop1}]);     
                        
                end
            end
        end
    end
end