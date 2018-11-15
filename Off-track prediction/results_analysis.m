clc
clear all

%% Load data
cd Data

load('Ypred1_tot.mat');
load('Ypred2_tot.mat');
load('Ypred3_tot.mat');
load('Ypred4_tot.mat');
load('Ypred5_tot.mat');
load('Ypred6_tot.mat');
load('Ypred7_tot.mat');
load('Ypred8_tot.mat');
load('Ypred9_tot.mat');
load('Ypred10_tot.mat');

load('MOD35.mat');

cd ..

CloudMask=MOD35.Cloud_Mask;

%% Data analysis

%CloudMask
sizeCM=size(CloudMask);
CloudMaskBinary=zeros(sizeCM);

for i=1:sizeCM(1)
    for j=1:sizeCM(2)
        if CloudMask(i,j)<1
            CloudMaskBinary(i,j)=1;
        end
    end
end

%Prediction
CMpredicted=zeros(sizeCM);

for i=1:sizeCM(1)
    for j=1:sizeCM(2)
        if Ypred1_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred2_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred3_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred4_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred5_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred6_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred7_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred8_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred9_tot(i,j)==1
            CMpredicted(i,j)=1;
        elseif Ypred10_tot(i,j)==1
            CMpredicted(i,j)=1;
        end
    end
end

%YpredallDT=cat(3,Ypred1_tot,Ypred2_tot,Ypred3_tot,Ypred4_tot,Ypred5_tot,Ypred6_tot,Ypred7_tot,Ypred8_tot,Ypred9_tot,Ypred10_tot);

[Accuracy,Recall_TPR, F1,MCC] = evaluate_accuracy(CloudMaskBinary,CMpredicted)

%% Plots

beginning=10000;
endValue = 12000;

[Ypred] = plotResults35(CloudMaskBinary,CMpredicted,beginning,endValue);


%% Off-track error percent

CMerror=abs(CMpredicted-CloudMaskBinary);
errorline=sum(CMerror)/65404;

figure(4)
plot((-270*5/2):5:(270*5/2),errorline);
axis([(-270*5/2-1) (270*5/2+1) 0 1]); 
xlabel('Cross-track distance (km)', 'fontsize',15)
ylabel('Percentage of wrong prediction','fontsize',15)
title('Repartition of wrong prediction on the cross-track axis', 'fontsize',15)


