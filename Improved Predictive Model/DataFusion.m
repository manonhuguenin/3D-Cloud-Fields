%%Data fusion script 
%Output : algoinput.mat

%%%%%%%%%%%%%%%%%%%%%%
% Combines all variables from different datasets for one day into one
% structure
%%%%%%%%%

%% Clear windows and workspace                                                                                
clc;
clear

%% Extract Database Folder Information
NDataFolder = 4;                            % Number of Files
temp_dir = dir('Data');                      % Look up folder name
Database_Foldername = cell(NDataFolder,1);   % Create cell to store folder name
% Save all foldername
for i = 1:NDataFolder
    Database_Foldername{i} = temp_dir(i+2).name;
end

clear temp_dir


for loop1 = 1:NDataFolder
    cd (['Data/' Database_Foldername{loop1} ])
    
    load('Geoprof_Lidar.mat')
    load('Geoprof.mat')
    load('Modis_Radiance.mat')
    load('Precip_Column.mat')
    load('Rain_Profile.mat')
    load('MERRA2.mat')

    %% GeoProf-Lidar
    %Matrix with latitudes and the good size
    lconcat=[];

    for i = 1:14
        Li=Geoprof_Lidar.Latitude{i,1};
        lconcat=[lconcat Li];
    end

    lconcat=lconcat';
    lfin=length(lconcat);

    %Matrix with longitudes and the good size
    LongConcat=[];

    for i = 1:14
        Li=Geoprof_Lidar.Longitude{i,1};
        LongConcat=[LongConcat Li];
    end

    LongConcat=LongConcat';

    %ClouLayer matrix with the good size

    CloudLayerConcat=[];

    for i = 1:14
        Li=Geoprof_Lidar.CloudLayers{i, 1};
        CloudLayerConcat=[CloudLayerConcat Li];
    end

    CloudLayerConcat=CloudLayerConcat';

    %Profile time with good size

    ProfileTimeConcat=[];
    init=0;
    for i = 1:14
        Li=init+0.16+Geoprof_Lidar.Profile_time{i, 1};
        ProfileTimeConcat=[ProfileTimeConcat Li];
        init=Li(end);
    end

    ProfileTimeConcat=ProfileTimeConcat';

    %Elevation with good size
    Elevationconcat=[];
    for i = 1:14
        Li=Geoprof_Lidar.Elevation{i,1};
        Elevationconcat=[Elevationconcat Li];
    end

    Elevationconcat=Elevationconcat';


    %% Precip_Column
    %Surface type reshaping
    SurfaceTypeConcat=[];

    for i = 1:14
        Li=Precip_Column.Surface_type{i, 1};
        SurfaceTypeConcat=[SurfaceTypeConcat Li];
    end

    SurfaceTypeConcat=SurfaceTypeConcat';

    %% MERRA-2
    %Create Longitude and Latitude matrix with MERRA-2 resolution

    LatMerra=zeros(361,1);
    LongMerra=zeros(576,1);
    deltaLong=5/8;
    deltaLat=0.5;

    for i=1:576
        LongMerra(i)=-180+deltaLong*(i-1);
    end
    for i=1:361
        LatMerra(i)=-90+deltaLat*(i-1);
    end

    %Get the corresponding index of Geoprof resolution to MERRA resolution

    longIndex=zeros(size(LongConcat,1),1);
    latIndex=zeros(size(lconcat,1),1);

    for i=1:size(LongConcat)
        for j = 1:size(LongMerra)
            if abs(LongConcat(i)-LongMerra(j))<=deltaLong
                longIndex(i)=j;
            end
        end
    end

    for i=1:size(lconcat)
        for j = 1:size(LatMerra)
            if abs(lconcat(i)-LatMerra(j))<=deltaLat
                latIndex(i)=j;
            end
        end
    end

    %Get corresponding index of profile time to MERRA resolution

    ProfileTimeIndex=zeros(size(ProfileTimeConcat,1),1);

    for i=1:size(ProfileTimeIndex,1)
        ProfileTimeIndex(i)=floor(ProfileTimeConcat(i)/3600)+1;
    end

    %Reformat MERRA variables

    temp_SLP=zeros(lfin,1);
    temp_PS=zeros(lfin,1);
    temp_U850=zeros(lfin,1);
    temp_U500=zeros(lfin,1);
    temp_U250=zeros(lfin,1);
    temp_V850=zeros(lfin,1);
    temp_V500=zeros(lfin,1);
    temp_V250=zeros(lfin,1);
    temp_T850=zeros(lfin,1);
    temp_T500=zeros(lfin,1);
    temp_T250=zeros(lfin,1);
    temp_Q850=zeros(lfin,1);
    temp_Q500=zeros(lfin,1);
    temp_Q250=zeros(lfin,1);
    temp_H1000=zeros(lfin,1);
    temp_H850=zeros(lfin,1);
    temp_H500=zeros(lfin,1);
    temp_H250=zeros(lfin,1);
    temp_OMEGA500=zeros(lfin,1);
    temp_U10M=zeros(lfin,1);
    temp_U2M=zeros(lfin,1);
    temp_U50M=zeros(lfin,1);
    temp_V10M=zeros(lfin,1);
    temp_V2M=zeros(lfin,1);
    temp_V50M=zeros(lfin,1);
    temp_T10M=zeros(lfin,1);
    temp_T2M=zeros(lfin,1);
    temp_QV10M=zeros(lfin,1);
    temp_QV2M=zeros(lfin,1);
    temp_TS=zeros(lfin,1);
    temp_DISPH=zeros(lfin,1);
    temp_TROPPV=zeros(lfin,1);
    temp_TROPPT=zeros(lfin,1);
    temp_TROPPB=zeros(lfin,1);
    temp_TROPT=zeros(lfin,1);
    temp_TROPQ=zeros(lfin,1);
    temp_CLDPRS=zeros(lfin,1);
    temp_CLDTMP=zeros(lfin,1);
    temp_PBLTOP=zeros(lfin,1);
    temp_T2MDEW=zeros(lfin,1);
    temp_T2MWET=zeros(lfin,1);
    temp_TO3=zeros(lfin,1);
    temp_TOX=zeros(lfin,1);
    temp_TQI=zeros(lfin,1);
    temp_TQL=zeros(lfin,1);
    temp_TQV=zeros(lfin,1);
    temp_ZLCL=zeros(lfin,1);


    for m=1:lfin
        i=longIndex(m);
        j=latIndex(m);
        k=ProfileTimeIndex(m);
        temp_SLP(m)=MERRA2.SLP(i,j,k);
        temp_PS(m)=MERRA2.PS(i,j,k);
        temp_U850(m)=MERRA2.U500(i,j,k);
        temp_U500(m)=MERRA2.U500(i,j,k);
        temp_U250(m)=MERRA2.U250(i,j,k);
        temp_V850(m)=MERRA2.V850(i,j,k);
        temp_V500(m)=MERRA2.V500(i,j,k);
        temp_V250(m)=MERRA2.V250(i,j,k);
        temp_T850(m)=MERRA2.T850(i,j,k);
        temp_T500(m)=MERRA2.T500(i,j,k);
        temp_T250(m)=MERRA2.T250(i,j,k);
        temp_Q850(m)=MERRA2.Q850(i,j,k);
        temp_Q500(m)=MERRA2.Q500(i,j,k);
        temp_Q250(m)=MERRA2.Q250(i,j,k);
        temp_H1000(m)=MERRA2.H1000(i,j,k);
        temp_H850(m)=MERRA2.H850(i,j,k);
        temp_H500(m)=MERRA2.H500(i,j,k);
        temp_H250(m)=MERRA2.H250(i,j,k);
        temp_OMEGA500(m)=MERRA2.OMEGA500(i,j,k);
        temp_U10M(m)=MERRA2.U10M(i,j,k);
        temp_U2M(m)=MERRA2.U2M(i,j,k);
        temp_U50M(m)=MERRA2.U50M(i,j,k);
        temp_V10M(m)=MERRA2.V10M(i,j,k);
        temp_V2M(m)=MERRA2.V2M(i,j,k);
        temp_V50M(m)=MERRA2.V50M(i,j,k);
        temp_T10M(m)=MERRA2.T10M(i,j,k);
        temp_T2M(m)=MERRA2.T2M(i,j,k);
        temp_QV10M(m)=MERRA2.QV10M(i,j,k);
        temp_QV2M(m)=MERRA2.QV2M(i,j,k);
        temp_TS(m)=MERRA2.TS(i,j,k);
        temp_DISPH(m)=MERRA2.DISPH(i,j,k);
        temp_TROPPV(m)=MERRA2.TROPPV(i,j,k);
        temp_TROPPT(m)=MERRA2.TROPPT(i,j,k);
        temp_TROPPB(m)=MERRA2.TROPPB(i,j,k);
        temp_TROPT(m)=MERRA2.TROPT(i,j,k);
        temp_TROPQ(m)=MERRA2.TROPQ(i,j,k);
        temp_CLDPRS(m)=MERRA2.CLDPRS(i,j,k);
        temp_CLDTMP(m)=MERRA2.CLDTMP(i,j,k);
        temp_PBLTOP(m)=MERRA2.PBLTOP(i,j,k);
        temp_T2MDEW(m)=MERRA2.T2MDEW(i,j,k);
        temp_T2MWET(m)=MERRA2.T2MWET(i,j,k);
        temp_TO3(m)=MERRA2.TO3(i,j,k);
        temp_TOX(m)=MERRA2.TOX(i,j,k);
        temp_TQI(m)=MERRA2.TQI(i,j,k);
        temp_TQL(m)=MERRA2.TQL(i,j,k);
        temp_TQV(m)=MERRA2.TQV(i,j,k);
        temp_ZLCL(m)=MERRA2.ZLCL(i,j,k);
    end


%% Forming matrix

    %Forming the output structure
    algoinput.Latitude=lconcat;
    algoinput.Longitude=LongConcat;
    algoinput.Elevation=Elevationconcat;
    algoinput.CloudLayer=CloudLayerConcat;
    algoinput.ProfileTime=ProfileTimeConcat;
    algoinput.LayerTop=Geoprof_Lidar.LayerTop;
    algoinput.LayerBase=Geoprof_Lidar.LayerBase;
    algoinput.Height=Geoprof_Lidar.Height;
    algoinput.CloudFraction=Geoprof_Lidar.CloudFraction;
    
    %From geoprof
    algoinput.CloudMask=Geoprof.CloudMask;

    algoinput.RadianceBand1=Modis_Radiance.Band_1;
    algoinput.RadianceBand2=Modis_Radiance.Band_2;
    algoinput.RadianceBand3=Modis_Radiance.Band_3;
    algoinput.RadianceBand4=Modis_Radiance.Band_4;
    algoinput.RadianceBand5=Modis_Radiance.Band_5;
    algoinput.RadianceBand6=Modis_Radiance.Band_6;
    algoinput.RadianceBand7=Modis_Radiance.Band_7;
    algoinput.RadianceBand17=Modis_Radiance.Band_17;
    algoinput.RadianceBand18=Modis_Radiance.Band_18;
    algoinput.RadianceBand19=Modis_Radiance.Band_19;
    algoinput.RadianceBand26=Modis_Radiance.Band_26;

    algoinput.SurfaceType=SurfaceTypeConcat;

    algoinput.CloudLiquidWater=Rain_Profile.Cloud_Liquid_Water;

    % Data correlation : some values are taken off because correlated with
    % others. Used dataset is tavg1 2D slv NX
    algoinput.SLP=temp_SLP; %sea level pressure
    algoinput.PS=temp_PS; %surface pressure
    algoinput.U850=temp_U850; %eastward wind 850 hPa
    algoinput.U500=temp_U500; %"" at 500
    algoinput.U250=temp_U250; %at 250, correlated with U500
    algoinput.V850=temp_V850; %northward wind at 850 hPa
    algoinput.V500=temp_V500; %'' at 500
    algoinput.V250=temp_V250; %'' at 250, correlated with V250
    algoinput.T850=temp_T850; % air temperature at 850 hpa
    algoinput.T500=temp_T500; %correlated with T850
    algoinput.T250=temp_T250;
    algoinput.Q850=temp_Q850; % specific humidity at 850 hPa
    algoinput.Q500=temp_Q500;
    algoinput.Q250=temp_Q250;
    algoinput.H1000=temp_H1000; %height at 1000 mb, correlated with SLP
    algoinput.H850=temp_H850; %height at 850 Pa
    algoinput.H500=temp_H500;
    algoinput.H250=temp_H250; %correlated with H500
    algoinput.OMEGA500=temp_OMEGA500; %omega at 500 hPa
    algoinput.U10M=temp_U10M; %10 meter eastward wind
    algoinput.U2M=temp_U2M; %2-meter eastward wind
    algoinput.U50M=temp_U50M; %eastward wind 50 meter
    algoinput.V10M=temp_V10M; %northward wind 10-meter
    algoinput.V2M=temp_V2M;
    algoinput.V50M=temp_V50M;
    algoinput.T10M=temp_T10M; %10 meter air temperature
    algoinput.T2M=temp_T2M; %correlated with T10M
    algoinput.QV10M=temp_QV10M; %10 meter specific humidity
    algoinput.QV2M=temp_QV2M; %correlated QV10M
    algoinput.TS=temp_TS; %surface skin temperature
    algoinput.DISPH=temp_DISPH; %zero plane displacement height
    algoinput.TROPPV=temp_TROPPV; %tropopause pressure based on EPV estimate
    algoinput.TROPPT=temp_TROPPT; %tropopause pressure based on thermal estimate
    algoinput.TROPPB=temp_TROPPB; %tropopause pressure based on blended estimate
    algoinput.TROPT=temp_TROPT; %tropopause temperature using blended TROPP
    algoinput.TROPQ=temp_TROPQ; %tropopause specific humidity using blended TROPP
    algoinput.CLDPRS=temp_CLDPRS; %cloud top pressure
    algoinput.CLDTMP=temp_CLDTMP; %cloud top temperature
    algoinput.PBLTOP=temp_PBLTOP; %pbltop pressure, correlated with
    %surface pressure
    algoinput.T2MDEW=temp_T2MDEW; %dew point temperature at 2 m
    algoinput.T2MWET=temp_T2MWET; %wet bulb temperature at 2 m %correlated
    %with T10M
    algoinput.TO3=temp_TO3; %total column ozone
    algoinput.TOX=temp_TOX; %total column odd oxygen
    algoinput.TQI=temp_TQI; %total precipitable ice water
    algoinput.TQL=temp_TQL; %total precipitable liquid water
    algoinput.TQV=temp_TQV; %total precipitable water vapor, correlated
    %with Q850
    algoinput.ZLCL=temp_ZLCL; %lifting condensation level

    name=[Database_Foldername{loop1} '_algoinput.mat'];
    cd ../
    save(name,'algoinput')
    cd ../

end

