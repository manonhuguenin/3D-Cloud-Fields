function [Accuracy,Recall_TPR, F1,MCC] = evaluate_accuracy(Y,Ypred)
n=size(Y,1)
TP=0;
TN=0;
FP=0;
FN=0;
for i = 1:n
    if Y(i)==1 && Ypred(i)==1
        TP=TP+1;
    end
    if Y(i)==0 && Ypred(i)==0
        TN=TN+1;
    end
    if Ypred(i)==1 && Y(i)==0
        FP=FP+1;
    end
    if Ypred(i)==0 && Y(i)==1
        FN=FN+1;
    end
   
end

TP
TN
FP
FN
Accuracy = (TP+TN)/(TP+TN+FP+FN)
Recall_TPR= TP/(TP+FN)
F1 = 2*TP/(2*TP+FP+FN)
MCC=(TP*TN-FP*FN)/sqrt((TP+FN)*(TP+FP)*(TN+FP)*(TN+FN))

end