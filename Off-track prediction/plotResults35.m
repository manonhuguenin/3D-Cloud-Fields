function [Yvalid,Ypred,Yerror] = plotResults35(YvalidAll,YpredAll,beginning,endValue)
    Yvalid=zeros(271,endValue-beginning);
    Ypred=zeros(271,endValue-beginning);
    Yerror=zeros(271,endValue-beginning);
    for i=(beginning+1):endValue
        for j=1:271
            if YvalidAll(i,j)==1
                Yvalid(j,i-beginning)=1;
            end
            if YpredAll(i,j)==1
                Ypred(j,i-beginning)=1;
            end
            if YpredAll(i,j)~=YvalidAll(i,j)
                if YvalidAll(i,j)==1
                    %false negative
                    Yerror(j,i-beginning)=1/2;
                else
                    Yerror(j,i-beginning)=1/3;
                end
            else
                if YvalidAll(i,j)==1
                    Yerror(j,i-beginning)=1;
                end
            end
        end
    end
    
    mapSky=[0 154/255 1 ; 1 1 1];
    mapError=[0 154/255 1 ;48/255 225/255 22/255 ; 225/255 76/255 22/255 ; 1 1 1];
    
    Xplot=0:5:((endValue-beginning)*5-1);
    Yplot=(-270*5/2):5:(270*5/2);
    
    %subplot(3,1,1);
    figure(1);
    %contourf(flipud(Ypred))
    contourf(Xplot,Yplot,Ypred)
    %set(gca,'XTick',0:500:((endValue-beginning)*5),'XTickLabel',0:500:((endValue-beginning)*5))
    xlabel('Along-track distance (km)','fontsize',15)
    ylabel('Cross-track distance (km)','fontsize',15)
    title('Predicted Cloud Mask','fontsize',15)
    colormap(mapSky)
    colorbar('Ticks',[1/4,3/4],...
         'TickLabels',{'No Cloud','Cloud'})


    figure(2);
    %subplot(3,1,2);
    %contourf(flipud(Yvalid))
    contourf(Xplot,Yplot,Yvalid)
    xlabel('Along-track distance (km)','fontsize',15)
    ylabel('Cross-track distance (km)','fontsize',15)
    title('MOD35 Cloud Mask','fontsize',15)
    colormap(mapSky)
    colorbar('Ticks',[1/4,3/4],...
         'TickLabels',{'No Cloud','Cloud'})

    figure(3);
    %errorPlot=subplot(3,1,3);
    %contourf(flipud(Yerror))
    contourf(Xplot,Yplot,Yerror)
    xlabel('Along-track distance (km)','fontsize',15)
    ylabel('Cross-track distance (km)','fontsize',15)
    colormap(mapError)
    title('Prediction performance visualization','fontsize',15)
    colorbar('Ticks',[1/8,3/8,5/8,7/8],...
         'TickLabels',{'True negative','False positive','False negative','True positive'})
    
end

