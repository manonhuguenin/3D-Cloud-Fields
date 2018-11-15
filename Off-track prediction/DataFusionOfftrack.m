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
tic

cd ('Data/')

load('MOD02_35.mat')
load('MOD03_35.mat')
load('MERRA2.mat')

%MOD03
Latitude=MOD03.Latitude;
Longitude=MOD03.Longitude;
Elevation=MOD03.Height;
Time=MOD03.Time;

%% Clean data
szLt=size(Longitude);

for i=1:szLt(1)
    for j=1:szLt(2)
        lat= Latitude(i,j);
        lon= Longitude(i,j);
        elev= Elevation(i,j);
        if lat<-90 || lat>90
            Latitude(i,j)=Latitude(i-1,j);
        end
        if lon<-180 || lon>180
            Longitude(i,j)=Longitude(i-1,j);
        end
        if elev<-400 || elev>10000
             Elevation(i,j)=Elevation(i-1,j);
        end
    end
end

%% MERRA2
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

longIndex=zeros(szLt);
latIndex=zeros(szLt);

for i=1:size(Longitude,1)
    for k = 1:size(Longitude,2)
        for j = 1:size(LongMerra)
            if abs(Longitude(i,k)-LongMerra(j))<=deltaLong
                longIndex(i,k)=j;
            end
        end
    end
end

for i=1:size(Latitude,1)
    for k=1:size(Latitude,2)
        for j = 1:size(LatMerra)
            if abs(Latitude(i,k)-LatMerra(j))<=deltaLat
                latIndex(i,k)=j;
            end
        end
    end
end

%Get corresponding index of profile time to MERRA resolution

% ProfileTimeIndex=zeros(size(Longitude,1),1);
% 
% for i=1:size(ProfileTimeIndex,1)
%     ProfileTimeIndex(i)=floor(i/4874.6)+1; %203(nb of scans per file)*12(nb of 5-min slots in 1hour)=2436
% end

%% Reformat MERRA variables

temp_SLP=zeros(szLt);
temp_PS=zeros(szLt);
% temp_U850=zeros(szLt);
% temp_U500=zeros(szLt);
temp_U250=zeros(szLt);
% temp_V850=zeros(szLt);
% temp_V500=zeros(szLt);
% temp_V250=zeros(szLt);
temp_T850=zeros(szLt);
temp_T500=zeros(szLt);
temp_T250=zeros(szLt);
% temp_Q850=zeros(szLt);
% temp_Q500=zeros(szLt);
% temp_Q250=zeros(szLt);
temp_H1000=zeros(szLt);
temp_H850=zeros(szLt);
temp_H500=zeros(szLt);
temp_H250=zeros(szLt);
% temp_OMEGA500=zeros(szLt);
% temp_U10M=zeros(szLt);
% temp_U2M=zeros(szLt);
% temp_U50M=zeros(szLt);
% temp_V10M=zeros(szLt);
% temp_V2M=zeros(szLt);
% temp_V50M=zeros(szLt);
temp_T10M=zeros(szLt);
temp_T2M=zeros(szLt);
% temp_QV10M=zeros(szLt);
% temp_QV2M=zeros(szLt);
temp_TS=zeros(szLt);
% temp_DISPH=zeros(szLt);
% temp_TROPPV=zeros(szLt);
temp_TROPPT=zeros(szLt);
temp_TROPPB=zeros(szLt);
temp_TROPT=zeros(szLt);
% temp_TROPQ=zeros(szLt);
temp_CLDPRS=zeros(szLt);
temp_CLDTMP=zeros(szLt);
temp_PBLTOP=zeros(szLt);
temp_T2MDEW=zeros(szLt);
temp_T2MWET=zeros(szLt);
temp_TO3=zeros(szLt);
temp_TOX=zeros(szLt);
% temp_TQI=zeros(szLt);
% temp_TQL=zeros(szLt);
temp_TQV=zeros(szLt);
temp_ZLCL=zeros(szLt);


for m=1:szLt(1)
    for n=1:szLt(2)
        i=single(longIndex(m,n));
        j=single(latIndex(m,n));
        k=single(Time(m));
        temp_SLP(m,n)=MERRA2.SLP(i,j,k);
        temp_PS(m,n)=MERRA2.PS(i,j,k);
%         temp_U850(m,n)=MERRA2.U500(i,j,k);
%         temp_U500(m,n)=MERRA2.U500(i,j,k);
        temp_U250(m,n)=MERRA2.U250(i,j,k);
%         temp_V850(m,n)=MERRA2.V850(i,j,k);
%         temp_V500(m,n)=MERRA2.V500(i,j,k);
%         temp_V250(m,n)=MERRA2.V250(i,j,k);
        temp_T850(m,n)=MERRA2.T850(i,j,k);
        temp_T500(m,n)=MERRA2.T500(i,j,k);
        temp_T250(m,n)=MERRA2.T250(i,j,k);
%         temp_Q850(m,n)=MERRA2.Q850(i,j,k);
%         temp_Q500(m,n)=MERRA2.Q500(i,j,k);
%         temp_Q250(m,n)=MERRA2.Q250(i,j,k);
        temp_H1000(m,n)=MERRA2.H1000(i,j,k);
        temp_H850(m,n)=MERRA2.H850(i,j,k);
        temp_H500(m,n)=MERRA2.H500(i,j,k);
        temp_H250(m,n)=MERRA2.H250(i,j,k);
%         temp_OMEGA500(m,n)=MERRA2.OMEGA500(i,j,k);
%         temp_U10M(m,n)=MERRA2.U10M(i,j,k);
%         temp_U2M(m,n)=MERRA2.U2M(i,j,k);
%         temp_U50M(m,n)=MERRA2.U50M(i,j,k);
%         temp_V10M(m,n)=MERRA2.V10M(i,j,k);
%         temp_V2M(m,n)=MERRA2.V2M(i,j,k);
%         temp_V50M(m,n)=MERRA2.V50M(i,j,k);
        temp_T10M(m,n)=MERRA2.T10M(i,j,k);
        temp_T2M(m,n)=MERRA2.T2M(i,j,k);
%         temp_QV10M(m,n)=MERRA2.QV10M(i,j,k);
%         temp_QV2M(m,n)=MERRA2.QV2M(i,j,k);
        temp_TS(m,n)=MERRA2.TS(i,j,k);
%         temp_DISPH(m,n)=MERRA2.DISPH(i,j,k);
%         temp_TROPPV(m,n)=MERRA2.TROPPV(i,j,k);
        temp_TROPPT(m,n)=MERRA2.TROPPT(i,j,k);
        temp_TROPPB(m,n)=MERRA2.TROPPB(i,j,k);
        temp_TROPT(m,n)=MERRA2.TROPT(i,j,k);
%         temp_TROPQ(m,n)=MERRA2.TROPQ(i,j,k);
        temp_CLDPRS(m,n)=MERRA2.CLDPRS(i,j,k);
        temp_CLDTMP(m,n)=MERRA2.CLDTMP(i,j,k);
        temp_PBLTOP(m,n)=MERRA2.PBLTOP(i,j,k);
        temp_T2MDEW(m,n)=MERRA2.T2MDEW(i,j,k);
        temp_T2MWET(m,n)=MERRA2.T2MWET(i,j,k);
        temp_TO3(m,n)=MERRA2.TO3(i,j,k);
%         temp_TOX(m,n)=MERRA2.TOX(i,j,k);
%         temp_TQI(m,n)=MERRA2.TQI(i,j,k);
%         temp_TQL(m,n)=MERRA2.TQL(i,j,k);
%         temp_TQV(m,n)=MERRA2.TQV(i,j,k);
        temp_ZLCL(m,n)=MERRA2.ZLCL(i,j,k);
    end
end



%Forming the output structure
algoinput.Latitude=Latitude;
algoinput.Longitude=Longitude;
algoinput.Elevation=Elevation;


algoinput.RadianceBand1=MOD02.Band_1_tot;
algoinput.RadianceBand2=MOD02.Band_2_tot;
algoinput.RadianceBand3=MOD02.Band_3_tot;
algoinput.RadianceBand4=MOD02.Band_4_tot;
algoinput.RadianceBand5=MOD02.Band_5_tot;
algoinput.RadianceBand6=MOD02.Band_6_tot;
algoinput.RadianceBand7=MOD02.Band_7_tot;
algoinput.RadianceBand17=MOD02.Band_17_tot;
algoinput.RadianceBand18=MOD02.Band_18_tot;
algoinput.RadianceBand19=MOD02.Band_19_tot;
algoinput.RadianceBand26=MOD02.Band_26_tot;

algoinput.SurfaceType=MOD03.LandSeaMask;


% Data correlation : some values are taken off because correlated with
% others. Used dataset is tavg1 2D slv NX
algoinput.SLP=temp_SLP; %sea level pressure
algoinput.PS=temp_PS; %surface pressure
%algoinput.U850=temp_U850; %eastward wind 850 hPa
%algoinput.U500=temp_U500; %"" at 500
algoinput.U250=temp_U250; %at 250, correlated with U500
%algoinput.V850=temp_V850; %northward wind at 850 hPa
%algoinput.V500=temp_V500; %'' at 500
%algoinput.V250=temp_V250; %'' at 250, correlated with V250
algoinput.T850=temp_T850; % air temperature at 850 hpa
algoinput.T500=temp_T500; %correlated with T850
algoinput.T250=temp_T250;
%algoinput.Q850=temp_Q850; % specific humidity at 850 hPa
%algoinput.Q500=temp_Q500;
%algoinput.Q250=temp_Q250;
algoinput.H1000=temp_H1000; %height at 1000 mb, correlated with SLP
algoinput.H850=temp_H850; %height at 850 Pa
algoinput.H500=temp_H500;
algoinput.H250=temp_H250; %correlated with H500
%algoinput.OMEGA500=temp_OMEGA500; %omega at 500 hPa
%algoinput.U10M=temp_U10M; %10 meter eastward wind
%algoinput.U2M=temp_U2M; %2-meter eastward wind
%algoinput.U50M=temp_U50M; %eastward wind 50 meter
%algoinput.V10M=temp_V10M; %northward wind 10-meter
%algoinput.V2M=temp_V2M;
%algoinput.V50M=temp_V50M;
algoinput.T10M=temp_T10M; %10 meter air temperature
algoinput.T2M=temp_T2M; %correlated with T10M
%algoinput.QV10M=temp_QV10M; %10 meter specific humidity
%algoinput.QV2M=temp_QV2M; %correlated QV10M
algoinput.TS=temp_TS; %surface skin temperature
%algoinput.DISPH=temp_DISPH; %zero plane displacement height
%algoinput.TROPPV=temp_TROPPV; %tropopause pressure based on EPV estimate
algoinput.TROPPT=temp_TROPPT; %tropopause pressure based on thermal estimate
algoinput.TROPPB=temp_TROPPB; %tropopause pressure based on blended estimate
algoinput.TROPT=temp_TROPT; %tropopause temperature using blended TROPP
%algoinput.TROPQ=temp_TROPQ; %tropopause specific humidity using blended TROPP
algoinput.CLDPRS=temp_CLDPRS; %cloud top pressure
algoinput.CLDTMP=temp_CLDTMP; %cloud top temperature
algoinput.PBLTOP=temp_PBLTOP; %pbltop pressure, correlated with
%surface pressure
algoinput.T2MDEW=temp_T2MDEW; %dew point temperature at 2 m
algoinput.T2MWET=temp_T2MWET; %wet bulb temperature at 2 m %correlated
%with T10M
algoinput.TO3=temp_TO3; %total column ozone
%algoinput.TOX=temp_TOX; %total column odd oxygen
%algoinput.TQI=temp_TQI; %total precipitable ice water
%algoinput.TQL=temp_TQL; %total precipitable liquid water
algoinput.TQV=temp_TQV; %total precipitable water vapor, correlated
%with Q850
algoinput.ZLCL=temp_ZLCL; %lifting condensation level

name='algoinput.mat';
cd ../
save(name,'algoinput','-v7.3')

toc
