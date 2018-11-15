close all
clear all
clc

%% Load data

algoinput22=load('Data/DataFeb22_algoinput.mat')
algoinput22=algoinput22.algoinput;

algoinput23=load('Data/DataFeb23_algoinput.mat')
algoinput23=algoinput23.algoinput;

algoinput24=load('Data/DataFeb24_algoinput.mat')
algoinput24=algoinput24.algoinput;

algoinput25=load('Data/DataFeb25_algoinput.mat')
algoinput25=algoinput25.algoinput;

%% Parameterization
cloudFractionTraining=[algoinput22.CloudFraction;algoinput23.CloudFraction;algoinput24.CloudFraction];
cloudFractionValidation=algoinput25.CloudFraction;
cft=flipud(cloudFractionTraining');
cfv=flipud(cloudFractionValidation');

cloudMaskTraining=[algoinput22.CloudMask;algoinput23.CloudMask;algoinput24.CloudMask];
cloudMaskValidation=algoinput25.CloudMask;
cmt=flipud(cloudMaskTraining');
cmv=flipud(cloudMaskValidation');

lowest_layer=20;
highest_layer=100;
nlayer=10;
step=(highest_layer-lowest_layer)/nlayer;
condition=20;

[parameterst,newplott,cmtnew] = parametrizeFractionMask(cft,cmt,lowest_layer,step,nlayer,condition);
[parametersv,newplotv,cmvnew] = parametrizeFractionMask(cfv,cmv,lowest_layer,step,nlayer,condition);


%Take training points
layerparameters=flipud(parameterst);


%% Training Points
%Define number of bagged trees
numtrees=20;


lat=single([algoinput22.Latitude;algoinput23.Latitude;algoinput24.Latitude]); 
long=single([algoinput22.Longitude;algoinput23.Longitude;algoinput24.Longitude]);
elev=single([algoinput22.Elevation;algoinput23.Elevation;algoinput24.Elevation]);
surftyp=single([algoinput22.SurfaceType;algoinput23.SurfaceType;algoinput24.SurfaceType]);
rad1=single([algoinput22.RadianceBand1;algoinput23.RadianceBand1;algoinput24.RadianceBand1]);
rad2=single([algoinput22.RadianceBand2;algoinput23.RadianceBand2;algoinput24.RadianceBand2]);
rad3=single([algoinput22.RadianceBand3;algoinput23.RadianceBand3;algoinput24.RadianceBand3]);
rad4=single([algoinput22.RadianceBand4;algoinput23.RadianceBand4;algoinput24.RadianceBand4]);
rad5=single([algoinput22.RadianceBand5;algoinput23.RadianceBand5;algoinput24.RadianceBand5]);
rad6=single([algoinput22.RadianceBand6;algoinput23.RadianceBand6;algoinput24.RadianceBand6]);
rad7=single([algoinput22.RadianceBand7;algoinput23.RadianceBand7;algoinput24.RadianceBand7]);
rad17=single([algoinput22.RadianceBand17;algoinput23.RadianceBand17;algoinput24.RadianceBand17]);
rad18=single([algoinput22.RadianceBand18;algoinput23.RadianceBand18;algoinput24.RadianceBand18]);
rad19=single([algoinput22.RadianceBand19;algoinput23.RadianceBand19;algoinput24.RadianceBand19]);
rad26=single([algoinput22.RadianceBand26;algoinput23.RadianceBand26;algoinput24.RadianceBand26]);
slp=single([algoinput22.SLP;algoinput23.SLP;algoinput24.SLP]);
ps=single([algoinput22.PS;algoinput23.PS;algoinput24.PS]);
u850=single([algoinput22.U850;algoinput23.U850;algoinput24.U850]);
u500=single([algoinput22.U500;algoinput23.U500;algoinput24.U500]);
u250=single([algoinput22.U250;algoinput23.U250;algoinput24.U250]);
v850=single([algoinput22.V850;algoinput23.V850;algoinput24.V850]);
v500=single([algoinput22.V500;algoinput23.V500;algoinput24.V500]);
v250=single([algoinput22.V250;algoinput23.V250;algoinput24.V250]);
t850=single([algoinput22.T850;algoinput23.T850;algoinput24.T850]);
t500=single([algoinput22.T500;algoinput23.T500;algoinput24.T500]);
t250=single([algoinput22.T250;algoinput23.T250;algoinput24.T250]);
q850=single([algoinput22.Q850;algoinput23.Q850;algoinput24.Q850]);
q500=single([algoinput22.Q500;algoinput23.Q500;algoinput24.Q500]);
q250=single([algoinput22.Q250;algoinput23.Q250;algoinput24.Q250]);
h1000=single([algoinput22.H1000;algoinput23.H1000;algoinput24.H1000]);
h850=single([algoinput22.H850;algoinput23.H850;algoinput24.H850]);
h500=single([algoinput22.H500;algoinput23.H500;algoinput24.H500]);
h250=single([algoinput22.H250;algoinput23.H250;algoinput24.H250]);
omega500=single([algoinput22.OMEGA500;algoinput23.OMEGA500;algoinput24.OMEGA500]);
u10M=single([algoinput22.U10M;algoinput23.U10M;algoinput24.U10M]);
u50M=single([algoinput22.U50M;algoinput23.U50M;algoinput24.U50M]);
u2M=single([algoinput22.U2M;algoinput23.U2M;algoinput24.U2M]);
v10M=single([algoinput22.V10M;algoinput23.V10M;algoinput24.V10M]);
v2M=single([algoinput22.V2M;algoinput23.V2M;algoinput24.V2M]);
v50M=single([algoinput22.V50M;algoinput23.V50M;algoinput24.V50M]);
t10M=single([algoinput22.T10M;algoinput23.T10M;algoinput24.T10M]);
t2M=single([algoinput22.T2M;algoinput23.T2M;algoinput24.T2M]);
qv10M=single([algoinput22.QV10M;algoinput23.QV10M;algoinput24.QV10M]);
qv2M=single([algoinput22.QV2M;algoinput23.QV2M;algoinput24.QV2M]);
ts=single([algoinput22.TS;algoinput23.TS;algoinput24.TS]);
disph=single([algoinput22.DISPH;algoinput23.DISPH;algoinput24.DISPH]);
troppt=single([algoinput22.TROPPT;algoinput23.TROPPT;algoinput24.TROPPT]);
troppb=single([algoinput22.TROPPB;algoinput23.TROPPB;algoinput24.TROPPB]);
troppv=single([algoinput22.TROPPV;algoinput23.TROPPV;algoinput24.TROPPV]);
tropt=single([algoinput22.TROPT;algoinput23.TROPT;algoinput24.TROPT]);
tropq=single([algoinput22.TROPQ;algoinput23.TROPQ;algoinput24.TROPQ]);
cldprs=single([algoinput22.CLDPRS;algoinput23.CLDPRS;algoinput24.CLDPRS]);
cldtmp=single([algoinput22.CLDTMP;algoinput23.CLDTMP;algoinput24.CLDTMP]);
pbltop=single([algoinput22.PBLTOP;algoinput23.PBLTOP;algoinput24.PBLTOP]);
t2mdew=single([algoinput22.T2MDEW;algoinput23.T2MDEW;algoinput24.T2MDEW]);
t2mwet=single([algoinput22.T2MWET;algoinput23.T2MWET;algoinput24.T2MWET]);
tO3=single([algoinput22.TO3;algoinput23.TO3;algoinput24.TO3]);
tql=single([algoinput22.TQL;algoinput23.TQL;algoinput24.TQL]);
tqv=single([algoinput22.TQV;algoinput23.TQV;algoinput24.TQV]);
zlcl=single([algoinput22.ZLCL;algoinput23.ZLCL;algoinput24.ZLCL]);


%X=[elev surftyp rad1 rad2 rad3 rad4 rad5 rad6 rad7 rad17 rad18 rad19 rad26 slp ps u850 u500 v850 v500 t850 t250 q850 q500 q250 h850 h500 omega500 u10M v10M v2M v5M t10M qv10M disph troppt tropt tropq cldprs t2mdew tO3 tql zlcl];%lat long 

%For 8 var
X8=[elev surftyp rad1 rad2 rad3 rad4 rad5 rad6 rad7 rad17 rad18 rad19 rad26 cldprs troppb troppt pbltop ps slp h250 h500];

%For 24 var
X24=[elev surftyp rad1 rad2 rad3 rad4 rad5 rad6 rad7 rad17 rad18 rad19 rad26 cldprs troppb troppt pbltop ps slp h250 h500 zlcl h850 h1000 tO3 cldtmp ts t2M t10M tqv t2mdew t2mwet t850 t500 tropt t250 u250];

%For 30 var
X30=[elev surftyp rad1 rad2 rad3 rad4 rad5 rad6 rad7 rad17 rad18 rad19 rad26 cldprs troppb troppt pbltop ps slp h250 h500 zlcl h850 h1000 tO3 cldtmp ts t2M t10M tqv t2mdew t2mwet t850 t500 tropt t250 u250 u500 u850 v250 u50M u10M u2M disph];


Y1=single(layerparameters(1,:)');
Y2=single(layerparameters(2,:)');
Y3=single(layerparameters(3,:)');
Y4=single(layerparameters(4,:)'); 
Y5=single(layerparameters(5,:)');
Y6=single(layerparameters(6,:)');
Y7=single(layerparameters(7,:)');
Y8=single(layerparameters(8,:)');
Y9=single(layerparameters(9,:)');
Y10=single(layerparameters(10,:)');

tree1=TreeBagger(numtrees,X24,Y1)
tree2=TreeBagger(numtrees,X24,Y2)
tree3=TreeBagger(numtrees,X24,Y3)
tree4=TreeBagger(numtrees,X8,Y4)
tree5=TreeBagger(numtrees,X8,Y5)
tree6=TreeBagger(numtrees,X8,Y6)
tree7=TreeBagger(numtrees,X8,Y7)
tree8=TreeBagger(numtrees,X24,Y8)
tree9=TreeBagger(numtrees,X24,Y9)
tree10=TreeBagger(numtrees,X24,Y10)

%view(tree1,'Mode','graph')
%view(tree2,'Mode','graph')

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
u850=single(algoinput25.U850);
u500=single(algoinput25.U500);
u250=single(algoinput25.U250);
v850=single(algoinput25.V850);
v500=single(algoinput25.V500);
v250=single(algoinput25.V250);
t850=single(algoinput25.T850);
t500=single(algoinput25.T500);
t250=single(algoinput25.T250);
q850=single(algoinput25.Q850);
q500=single(algoinput25.Q500);
q250=single(algoinput25.Q250);
h1000=single(algoinput25.H1000);
h850=single(algoinput25.H850);
h500=single(algoinput25.H500);
h250=single(algoinput25.H250);
omega500=single(algoinput25.OMEGA500);
u10M=single(algoinput25.U10M);
u2M=single(algoinput25.U2M);
v10M=single(algoinput25.V10M);
u50M=single(algoinput25.U50M);
v2M=single(algoinput25.V2M);
v50M=single(algoinput25.V50M);
t10M=single(algoinput25.T10M);
t2M=single(algoinput25.T2M);
ts=single(algoinput25.TS);
qv10M=single(algoinput25.QV10M);
qv2M=single(algoinput25.QV2M);
disph=single(algoinput25.DISPH);
troppt=single(algoinput25.TROPPT);
troppb=single(algoinput25.TROPPB);
troppv=single(algoinput25.TROPPV);
tropt=single(algoinput25.TROPT);
tropq=single(algoinput25.TROPQ);
cldprs=single(algoinput25.CLDPRS);
cldtmp=single(algoinput25.CLDTMP);
pbltop=single(algoinput25.PBLTOP);
t2mdew=single(algoinput25.T2MDEW);
t2mwet=single(algoinput25.T2MWET);
tO3=single(algoinput25.TO3);
tql=single(algoinput25.TQL);
tqv=single(algoinput25.TQV);
zlcl=single(algoinput25.ZLCL);

%For 8 var
Xpred8=[elev surftyp rad1 rad2 rad3 rad4 rad5 rad6 rad7 rad17 rad18 rad19 rad26 cldprs troppb troppt pbltop ps slp h250 h500];

%For 24 var
Xpred24=[elev surftyp rad1 rad2 rad3 rad4 rad5 rad6 rad7 rad17 rad18 rad19 rad26 cldprs troppb troppt pbltop ps slp h250 h500 zlcl h850 h1000 tO3 cldtmp ts t2M t10M tqv t2mdew t2mwet t850 t500 tropt t250 u250];

%For 30 var
Xpred30=[elev surftyp rad1 rad2 rad3 rad4 rad5 rad6 rad7 rad17 rad18 rad19 rad26 cldprs troppb troppt pbltop ps slp h250 h500 zlcl h850 h1000 tO3 cldtmp ts t2M t10M tqv t2mdew t2mwet t850 t500 tropt t250 u250 u500 u850 v250 u50M u10M u2M disph];


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

%Get comparison points
layerparameters=flipud(parametersv);


%Y_b for the original points 

Y1_b=single(layerparameters(1,:)');
Y2_b=single(layerparameters(2,:)');
Y3_b=single(layerparameters(3,:)');
Y4_b=single(layerparameters(4,:)'); 
Y5_b=single(layerparameters(5,:)');
Y6_b=single(layerparameters(6,:)');
Y7_b=single(layerparameters(7,:)');
Y8_b=single(layerparameters(8,:)');
Y9_b=single(layerparameters(9,:)');
Y10_b=single(layerparameters(10,:)');


%% Error quantification 

%Conversion

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


accuracyall=[];
recallall=[];
F1all=[];
MCCall=[];

% evaluate_accuracy
disp('layer 1')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y1_b, Ypred1);
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

disp('layer 2')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y2_b, Ypred2)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

disp('layer 3')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y3_b, Ypred3)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

disp('layer 4')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y4_b, Ypred4)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

disp('layer 5')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y5_b, Ypred5)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

disp('layer 6')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y6_b, Ypred6)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

disp('layer 7')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y7_b, Ypred7)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

disp('layer 8')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y8_b, Ypred8)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];


disp('layer 9')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y9_b, Ypred9)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

disp('layer 10')
[Accuracy,Recall_TPR, F1, MCC]=evaluate_accuracy_DT(Y10_b, Ypred10)
accuracyall=[accuracyall Accuracy];
recallall=[recallall Recall_TPR];
F1all=[F1all F1];
MCCall=[MCCall MCC];

xlswrite('resultImprovedModelpca2.xlsx',accuracyall,1)
xlswrite('resultImprovedModelpca2.xlsx',recallall,2)
xlswrite('resultImprovedModelpca2.xlsx',F1all,3)
xlswrite('resultImprovedModelpca2.xlsx',MCCall,4)

