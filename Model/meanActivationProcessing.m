%working with meanActivation

% close all
% class={ class{1,:} class{3,:} ; class{2,:}  class{4,:} };

load('classFullImages.mat')
temp=cell(1,126);
fullImages={class{1,:} , temp{1,:} };
load('class.mat')
nonRecog={class{2,:}  class{4,:}};
recog={class{1,:}  class{3,:}};
class={fullImages{1,:}  ;  nonRecog{1,:} ; recog{1,:}};

colors={[0 0 0],[74,77,255]./255,[246,75,75]./255};
folders={'fullImage','Recognized','Not Recognized'};

numofSubPlot=size(folders,2)+1;
for c=1:size(class,1)
    meanPerFix=[];
    
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            % mean rec activations
            meanRecAct=currT.meanRecActivation;
            figure(20) % mean rec activations
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
   subplot(2,numofSubPlot+1,4)
   plot(nanmean(meanPerFix),'color',colors{c})
   hold on
    
end
