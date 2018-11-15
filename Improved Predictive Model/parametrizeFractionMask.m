function [parameters,newplot,cminew] = parametrizeFractionMask(cfi,cmi,layer_low,step,nlayer,condition)
    parameters=zeros(nlayer,size(cfi,2));
    newplot=zeros(size(cfi));
    cminew=zeros(size(cmi));
    for j=1:length(cmi(1,:))
        for i=1:125
            if cmi(i,j)>=20
                cminew(i,j)=1;
            else
                cminew(i,j)=0;
            end 
        end
    end
    
    
    for i=1:size(cfi,2)
        for j=0:nlayer-1
            if mean(cfi(layer_low+j*step:layer_low+(j+1)*step,i))>condition
                parameters(j+1,i)=1+parameters(j+1,i);
                %newplot(layer_low+j*step:layer_low+(j+1)*step,i)=ones(size(newplot(layer_low+j*step:layer_low+(j+1)*step,i)));
            end
            if mean(cminew(layer_low+j*step:layer_low+(j+1)*step,i))>0.2
                parameters(j+1,i)=1;
                %newplot(layer_low+j*step:layer_low+(j+1)*step,i)=ones(size(newplot(layer_low+j*step:layer_low+(j+1)*step,i)));
            end
        end
    end
end

