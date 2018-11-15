close all
clear all
clc

%% Load data
tic
load('algoinput.mat')
algoinput25=algoinput; 
clear algoinput

%% Load model

load('Model\tree1.mat');
load('Model\tree2.mat');
load('Model\tree3.mat');
load('Model\tree4.mat');
load('Model\tree5.mat');
load('Model\tree6.mat');
load('Model\tree7.mat');
load('Model\tree8.mat');
load('Model\tree9.mat');
load('Model\tree10.mat');

%% Parameterization

%% Training Points

%% Validation

lat=algoinput25.Latitude;
long=algoinput25.Longitude;
elev=single(algoinput25.Elevation);
surftyp=single(algoinput25.SurfaceType);
rad1=single(algoinput25.RadianceBand1);
rad2=single(algoinput25.RadianceBand2);
rad3=single(algoinput25.RadianceBand3);
rad4=single(algoinput25.RadianceBand4);
rad5=single(algoinput25.RadianceBand5);
rad6=single(algoinput25.RadianceBand6);
rad7=single(algoinput25.RadianceBand7);
rad17=single(algoinput25.RadianceBand17);
rad18=single(algoinput25.RadianceBand18);
rad19=single(algoinput25.RadianceBand19);
rad26=single(algoinput25.RadianceBand26);
slp=single(algoinput25.SLP);
ps=single(algoinput25.PS);
%u850=single(algoinput25.U850);
%u500=single(algoinput25.U500);
u250=single(algoinput25.U250);
% v850=single(algoinput25.V850);
% v500=single(algoinput25.V500);
% v250=single(algoinput25.V250);
t850=single(algoinput25.T850);
t500=single(algoinput25.T500);
t250=single(algoinput25.T250);
% q850=single(algoinput25.Q850);
% q500=single(algoinput25.Q500);
% q250=single(algoinput25.Q250);
h1000=single(algoinput25.H1000);
h850=single(algoinput25.H850);
h500=single(algoinput25.H500);
h250=single(algoinput25.H250);
% omega500=single(algoinput25.OMEGA500);
% u10M=single(algoinput25.U10M);
% u2M=single(algoinput25.U2M);
% v10M=single(algoinput25.V10M);
% u50M=single(algoinput25.U50M);
% v2M=single(algoinput25.V2M);
% v50M=single(algoinput25.V50M);
t10M=single(algoinput25.T10M);
t2M=single(algoinput25.T2M);
ts=single(algoinput25.TS);
% qv10M=single(algoinput25.QV10M);
% qv2M=single(algoinput25.QV2M);
%disph=single(algoinput25.DISPH);
troppt=single(algoinput25.TROPPT);
troppb=single(algoinput25.TROPPB);
%troppv=single(algoinput25.TROPPV);
tropt=single(algoinput25.TROPT);
%tropq=single(algoinput25.TROPQ);
cldprs=single(algoinput25.CLDPRS);
cldtmp=single(algoinput25.CLDTMP);
pbltop=single(algoinput25.PBLTOP);
t2mdew=single(algoinput25.T2MDEW);
t2mwet=single(algoinput25.T2MWET);
tO3=single(algoinput25.TO3);
% tql=single(algoinput25.TQL);
tqv=single(algoinput25.TQV);
zlcl=single(algoinput25.ZLCL);

clear algoinput25

%Prediction
Ypred1_tot = []; 
Ypred2_tot = []; 
Ypred3_tot = []; 
Ypred4_tot = []; 
Ypred5_tot = []; 
Ypred6_tot = []; 
Ypred7_tot = []; 
Ypred8_tot = []; 
Ypred9_tot = []; 
Ypred10_tot = []; 

for i=1:271
    elevi=elev(:,i);
    surftypi=surftyp(:,i);
    rad1i=rad1(:,i);
    rad2i=rad2(:,i);
    rad3i=rad3(:,i);
    rad4i=rad4(:,i);
    rad5i=rad5(:,i);
    rad6i=rad6(:,i);
    rad7i=rad7(:,i);
    rad17i=rad17(:,i);
    rad18i=rad18(:,i);
    rad19i=rad19(:,i);
    rad26i=rad26(:,i);
    cldprsi=cldprs(:,i);
    troppbi=troppb(:,i);
    troppti=troppt(:,i);
    pbltopi=pbltop(:,i);
    psi=ps(:,i);
    slpi=slp(:,i);
    h250i=h250(:,i);
    h500i=h500(:,i);
    zlcli=zlcl(:,i); 
    h850i=h850(:,i); 
    h1000i=h1000(:,i); 
    tO3i=tO3(:,i); 
    cldtmpi=cldtmp(:,i); 
    tsi=ts(:,i); 
    t2Mi=t2M(:,i); 
    t10Mi=t10M(:,i); 
    tqvi=tqv(:,i);
    t2mdewi=t2mdew(:,i); 
    t2mweti=t2mwet(:,i); 
    t850i=t850(:,i); 
    t500i=t500(:,i);
    tropti=tropt(:,i);
    t250i=t250(:,i);
    u250i=u250(:,i);
    
    %For 8 var
    Xpred8=[elevi surftypi rad1i rad2i rad3i rad4i rad5i rad6i rad7i rad17i rad18i rad19i rad26i cldprsi troppbi troppti pbltopi psi slpi h250i h500i];

    %For 24 var
    Xpred24=[elevi surftypi rad1i rad2i rad3i rad4i rad5i rad6i rad7i rad17i rad18i rad19i rad26i cldprsi troppbi troppti pbltopi psi slpi h250i h500i zlcli h850i h1000i tO3i cldtmpi tsi t2Mi t10Mi tqvi t2mdewi t2mweti t850i t500i tropti t250i u250i];

    %For 30 var
    %Xpred30=[elev surftyp rad1 rad2 rad3 rad4 rad5 rad6 rad7 rad17 rad18 rad19 rad26 cldprs troppb troppt pbltop ps slp h250 h500 zlcl h850 h1000 tO3 cldtmp ts t2M t10M tqv t2mdew t2mwet t850 t500 tropt t250 u250 u500 u850 v250 u50M u10M u2M disph];


    Ypred1 = predict(tree1,Xpred24); 
    Ypred2 = predict(tree2,Xpred24);
    Ypred3= predict(tree3,Xpred24);
    Ypred4= predict(tree4,Xpred8);
    Ypred5= predict(tree5,Xpred8);
    Ypred6= predict(tree6,Xpred8);
    Ypred7= predict(tree7,Xpred8);
    Ypred8= predict(tree8,Xpred24);
    Ypred9= predict(tree9,Xpred24);
    Ypred10= predict(tree10,Xpred24);
    
    Ypred1=str2num(cell2mat(Ypred1));
    Ypred2=str2num(cell2mat(Ypred2));
    Ypred3=str2num(cell2mat(Ypred3));
    Ypred4=str2num(cell2mat(Ypred4));
    Ypred5=str2num(cell2mat(Ypred5));
    Ypred6=str2num(cell2mat(Ypred6));
    Ypred7=str2num(cell2mat(Ypred7));
    Ypred8=str2num(cell2mat(Ypred8));
    Ypred9=str2num(cell2mat(Ypred9));
    Ypred10=str2num(cell2mat(Ypred10));
    
    Ypred1_tot = [Ypred1_tot Ypred1]; 
    Ypred2_tot = [Ypred2_tot Ypred2]; 
    Ypred3_tot = [Ypred3_tot Ypred3]; 
    Ypred4_tot = [Ypred4_tot Ypred4]; 
    Ypred5_tot = [Ypred5_tot Ypred5]; 
    Ypred6_tot = [Ypred6_tot Ypred6]; 
    Ypred7_tot = [Ypred7_tot Ypred7]; 
    Ypred8_tot = [Ypred8_tot Ypred8]; 
    Ypred9_tot = [Ypred9_tot Ypred9]; 
    Ypred10_tot = [Ypred10_tot Ypred10]; 

end
toc

