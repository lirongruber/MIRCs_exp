%working with meanActivation

% close all
% class={ class{1,:} class{3,:} ; class{2,:}  class{4,:} };
colors={[74,77,255]./255,[246,75,75]./255};
folders={'Recognized','Not Recognized'};

numofSubPlot=size(folders,2)+1;
for c=1:size(class,1)
    meanPerFix=[];
    
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            % mean rec activations
            meanRecAct=currT.meanRecActivation;
            figure(10) % mean rec activations
            subplot(2,numofSubPlot+1,c)
            hold all
            for fixNum=1:size(meanRecAct,2)
%                 plot(fixNum,mean(meanRecAct{1,fixNum}),'.','color','k')
                meanPerFix(t,fixNum)=sum(meanRecAct{1,fixNum});
            end
        end
    end
    meanPerFix(meanPerFix==0)=nan;
   plot(nanmean(meanPerFix),'color',colors{c})
   subplot(2,numofSubPlot+1,3)
   plot(nanmean(meanPerFix),'color',colors{c})
   hold on
    
end
