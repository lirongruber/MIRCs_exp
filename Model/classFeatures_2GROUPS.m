% plotting "class"... (TWO GROUPS)
close all
% class={ class{1,:} class{3,:} ; class{2,:}  class{4,:} };

% colors={[74,77,255]./255,[246,75,75]./255,[74,77,255]./255,[246,75,75]./255};
% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};

colors={[74,77,255]./255,[246,75,75]./255};
folders={'Recognized','Not Recognized'};

% colors={[2,122,164]./256,[244,147,31]./256}; % blue yellow green orange
% folders={'MIRCs Yes','subMIRCs No'};
% class={ class{1,:} ; class{4,:} };
% class=one_class;
% class=control_class;
STDforOutL=2; %number of std from mean to include
perNonNan2include=0.9;

forSVM={};
numofSubPlot=size(folders,2)+1;
forStat_infoPerRec={};
for c=1:size(class,1)
    numOfinfoRec=nan(size(class,2),30);
    numOfinfoRec_rev=nan(size(class,2),30);
    targetSpeed=nan(size(class,2),30);
    targetSpeed_rev=nan(size(class,2),30);
    %     insAct_Speed=nan(size(class,2),30);
    %     insAct_Speed_rev=nan(size(class,2),30);
    varSpeed=nan(size(class,2),30);
    varSpeed_rev=nan(size(class,2),30);
    infoPerRec=nan(size(class,2),30);
    infoPerRec_rev=nan(size(class,2),30);
    ampFixation=nan(size(class,2),30);
    ampFixation_rev=nan(size(class,2),30);
    TimeFixation=nan(size(class,2),30);
    TimeFixation_rev=nan(size(class,2),30);
    distFixation=nan(size(class,2),30);
    distFixation_rev=nan(size(class,2),30);
    varInfoPerRec=nan(size(class,2),30);
    varInfoPerRec_rev=nan(size(class,2),30);
    
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            %number of info receptors
            numOfinfoRec(t,1:size(currT.numOfinfoRec,2))=currT.numOfinfoRec;
            numOfinfoRec_rev(t,1:size(currT.numOfinfoRec,2))=flip(currT.numOfinfoRec);
            
            % mean rec activations
            infoPerRec(t,1:size(currT.meanInfoPerRec,2))=currT.meanInfoPerRec;
            infoPerRec_rev(t,1:size(currT.meanInfoPerRec,2))=flip(currT.meanInfoPerRec);
            
            %speed
            targetSpeed(t,1:size(currT.targetSpeed,2))=currT.targetSpeed;
            targetSpeed_rev(t,1:size(currT.targetSpeed,2))=flip(currT.targetSpeed);
            
            % amp
            ampFixation(t,1:size(currT.ampFixation,2))=currT.ampFixation;
            ampFixation_rev(t,1:size(currT.ampFixation,2))=flip(currT.ampFixation);
            
            % dist
            distFixation(t,1:size(currT.distFixation,2))=currT.distFixation;
            distFixation_rev(t,1:size(currT.distFixation,2))=flip(currT.distFixation);
            
            %time
            TimeFixation(t,1:size(currT.timeFixation,2))=currT.timeFixation;
            TimeFixation_rev(t,1:size(currT.timeFixation,2))=flip(currT.timeFixation);
            
            %             %final ins_act
            %             insAct_Speed(t,1:size(currT.finalInsInfoPerRec,2))=currT.finalInsInfoPerRec./currT.finalInsSpeed;
            %             insAct_Speed_rev(t,1:size(currT.finalInsInfoPerRec,2))=flip(currT.finalInsInfoPerRec)./flip(currT.finalInsSpeed);
            
            % var activations
            varInfoPerRec(t,1:size(currT.varInfoPerRec,2))=currT.varInfoPerRec;
            varInfoPerRec_rev(t,1:size(currT.varInfoPerRec,2))=flip(currT.varInfoPerRec);
            
            % var speed
            varSpeed(t,1:size(currT.varSpeed,2))=currT.varSpeed;
            varSpeed_rev(t,1:size(currT.varSpeed,2))=flip(currT.varSpeed);
            
        end
    end
    
    %1
    numOfinfoRec=numOfinfoRec(:,sum(isnan(numOfinfoRec))<size(numOfinfoRec,1)*perNonNan2include);
    numOfinfoRec_rev=numOfinfoRec_rev(:,sum(isnan(numOfinfoRec_rev))<size(numOfinfoRec_rev,1)*perNonNan2include);
    %2
    infoPerRec=infoPerRec(:,sum(isnan(infoPerRec))<size(infoPerRec,1)*perNonNan2include);
    infoPerRec_rev=infoPerRec_rev(:,sum(isnan(infoPerRec_rev))<size(infoPerRec_rev,1)*perNonNan2include);
    %3
    targetSpeed=targetSpeed(:,sum(isnan(targetSpeed))<size(targetSpeed,1)*perNonNan2include);
    targetSpeed_rev=targetSpeed_rev(:,sum(isnan(targetSpeed_rev))<size(targetSpeed_rev,1)*perNonNan2include);
    %8
    TimeFixation=TimeFixation(:,sum(isnan(TimeFixation))<size(TimeFixation,1)*perNonNan2include);
    TimeFixation_rev=TimeFixation_rev(:,sum(isnan(TimeFixation_rev))<size(TimeFixation_rev,1)*perNonNan2include);
    %20
    varInfoPerRec=varInfoPerRec(:,sum(isnan(varInfoPerRec))<size(varInfoPerRec,1));
    varInfoPerRec_rev=varInfoPerRec_rev(:,sum(isnan(varInfoPerRec_rev))<size(varInfoPerRec_rev,1)*perNonNan2include);
    %30
    varSpeed=varSpeed(:,sum(isnan(varSpeed))<size(varSpeed,1)*perNonNan2include);
    varSpeed_rev=varSpeed_rev(:,sum(isnan(varSpeed_rev))<size(varSpeed_rev,1)*perNonNan2include);
    %6
    ampFixation=ampFixation(:,sum(isnan(ampFixation))<size(ampFixation,1)*perNonNan2include);
    ampFixation_rev=ampFixation_rev(:,sum(isnan(ampFixation_rev))<size(ampFixation_rev,1)*perNonNan2include);
    %7
    distFixation=distFixation(:,sum(isnan(distFixation))<size(distFixation,1)*perNonNan2include);
    distFixation_rev=distFixation_rev(:,sum(isnan(distFixation_rev))<size(distFixation_rev,1)*perNonNan2include);
    
    figure(1) %number of info receptors
    subplot(2,numofSubPlot+1,c)
    hold on
    plot(numOfinfoRec','.','color','k')
    %     M=nanmean(numOfinfoRec);
    %     S=nanstd(numOfinfoRec).*3;
    M=nanmean(numOfinfoRec(:));
    S=nanstd(numOfinfoRec(:))*STDforOutL;
    numOfinfoRec(~((numOfinfoRec<= M+S)&(numOfinfoRec>= M-S)))=nan;
    plot(numOfinfoRec','.','color',colors{c})
    plot(nanmedian(numOfinfoRec),'color',colors{c})
    
    subplot(2,numofSubPlot+1,c+numofSubPlot+1)
    hold on
    plot(numOfinfoRec_rev','.','color','k')
    M=nanmean(numOfinfoRec_rev(:));
    S=nanstd(numOfinfoRec_rev(:))*STDforOutL;
    numOfinfoRec_rev(~((numOfinfoRec_rev<= M+S)&(numOfinfoRec_rev>= M-S)))=nan;
    plot(nanmedian(numOfinfoRec_rev),'color',colors{c})
    plot(numOfinfoRec_rev','.','color',colors{c})
    
    subplot(2,numofSubPlot+1,numofSubPlot)
    numOfinfoRec(numOfinfoRec==0)=nan;
    errorbar(nanmedian(numOfinfoRec),nanstd(numOfinfoRec)./sum(~isnan(numOfinfoRec),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('fixation number','Fontsize',18)
    title(' Number of informative receptors','Fontsize',20)
    if c==numofSubPlot-1
%         legend(folders)
    end
    box off
    
    subplot(2,numofSubPlot+1,numofSubPlot*2+1)
    numOfinfoRec_rev(numOfinfoRec_rev==0)=nan;
    errorbar(nanmedian(numOfinfoRec_rev),nanstd(numOfinfoRec_rev)./sum(~isnan(numOfinfoRec_rev),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('reversed fixation number from trial end')
    
    subplot(2,numofSubPlot+1,numofSubPlot+1)
    histogram(numOfinfoRec(~isnan(numOfinfoRec)),'FaceColor',colors{c},'BinEdges',0:200:4000,'normalization','probability')
    hold on
    %     plot([nanmedian(numOfinfoRec(:)) nanmedian(numOfinfoRec(:))], [0 .4],'color',colors{c})
    plot(nanmedian(numOfinfoRec(:)),.2,'*','color',colors{c})
    xlabel('Number of informative receptors')
    
    
    subplot(2,numofSubPlot+1,numofSubPlot*2+2)
    histogram(numOfinfoRec_rev(~isnan(numOfinfoRec_rev)),'FaceColor',colors{c},'BinEdges',0:200:4000,'normalization','probability')
    hold on
    %     plot([nanmedian(numOfinfoRec_rev(:)) nanmedian(numOfinfoRec_rev(:))], [0 .4],'color',colors{c})
    plot(nanmedian(numOfinfoRec_rev(:)),.2,'*','color',colors{c})
    xlabel('Number of informative receptors')
    forStat_numOfinfoRec{c}=numOfinfoRec;
    
    
    figure(2) % mean rec activations
    subplot(2,numofSubPlot+1,c)
    hold all
    plot(infoPerRec','.','color','k')
    M=nanmean(infoPerRec(:));
    S=nanstd(infoPerRec(:))*STDforOutL;
    infoPerRec(~((infoPerRec<= M+S)&(infoPerRec>= M-S)))=nan;
    plot(infoPerRec','.','color',colors{c})
    plot(nanmedian(infoPerRec),'color',colors{c})
    
    subplot(2,numofSubPlot+1,c+numofSubPlot+1)
    hold on
    plot(infoPerRec_rev','.','color','k')
    M=nanmean(infoPerRec_rev(:));
    S=nanstd(infoPerRec_rev(:))*STDforOutL;
    infoPerRec_rev(~((infoPerRec_rev<= M+S)&(infoPerRec_rev>= M-S)))=nan;
    plot(infoPerRec_rev','.','color',colors{c})
    plot(nanmean(infoPerRec_rev),'color',colors{c})
    
    subplot(2,numofSubPlot+1,numofSubPlot)
    errorbar(nanmean(infoPerRec),nanstd(infoPerRec)./sum(~isnan(infoPerRec),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('fixation number ','Fontsize',18)
    title('Mean retinal activation','Fontsize',20)
    if c==numofSubPlot-1
%         legend(folders)
    end
    box off
    
    subplot(2,numofSubPlot+1,numofSubPlot*2+1)
    errorbar(nanmean(infoPerRec_rev),nanstd(infoPerRec_rev)./sum(~isnan(infoPerRec_rev),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('reversed fixation number from trial end')
    
    subplot(2,numofSubPlot+1,numofSubPlot+1)
    histogram(infoPerRec(~isnan(infoPerRec)),'FaceColor',colors{c},'BinEdges',-15:3:15,'normalization','probability')
    hold on
    %     plot([nanmean(infoPerRec(:)) nanmean(infoPerRec(:))], [0 .3],'color',colors{c})
    plot(nanmean(infoPerRec(:)),.45,'*','color',colors{c})
    xlabel('Mean receptors activation')
    
    
    subplot(2,numofSubPlot+1,numofSubPlot*2+2)
    histogram(infoPerRec_rev(~isnan(infoPerRec_rev)),'FaceColor',colors{c},'BinEdges',-15:3:15,'normalization','probability')
    hold on
    %     plot([nanmean(infoPerRec_rev(:)) nanmean(infoPerRec_rev(:))], [0 .3],'color',colors{c})
    plot(nanmean(infoPerRec_rev(:)),.45,'*','color',colors{c})
    xlabel('Mean receptors activation')
    forStat_infoPerRec{c}=infoPerRec;
    
    %     figure(20)
    
    %     f=min(size(infoPerRec,2),8);
    %     for i=1:f
    %         subplot(2,ceil(f/2),i)
    %         histogram(infoPerRec(:,i),'FaceColor',colors{c},'BinEdges',-8:2:8)
    %         hold on
    %         plot([nanmean(infoPerRec(:,i)) nanmean(infoPerRec(:,i))], [0 40],'color',colors{c})
    %         xlabel('Mean receptors activation')
    %         title(['Fixation ' num2str(i)])
    %     end
    
    figure(3) %speed
    subplot(2,numofSubPlot,c)
    hold on
    plot(targetSpeed','.','color','k')
    M=nanmean(targetSpeed(:));
    S=nanstd(targetSpeed(:))*STDforOutL;
    targetSpeed(~((targetSpeed<= M+S)&(targetSpeed>= M-S)))=nan;
    plot(targetSpeed','.','color',colors{c})
    plot(nanmean(targetSpeed),'color',colors{c})
    
    forSVM{c}=targetSpeed;
    
    subplot(2,numofSubPlot,c+numofSubPlot)
    hold on
    plot(targetSpeed_rev','.','color','k')
    M=nanmean(targetSpeed_rev(:));
    S=nanstd(targetSpeed_rev(:))*STDforOutL;
    targetSpeed_rev(~((targetSpeed_rev<= M+S)&(targetSpeed_rev>= M-S)))=nan;
    plot(targetSpeed_rev','.','color',colors{c})
    plot(nanmean(targetSpeed_rev),'color',colors{c})
    
    subplot(2,numofSubPlot,numofSubPlot)
    hold on
    errorbar(nanmean(targetSpeed),nanstd(targetSpeed)./sum(~isnan(targetSpeed),1),'color',colors{c})
    %     [r,p]=corr(nanmean(targetSpeed)',nanmean(infoPerRec(:,1:size(targetSpeed,2)))');
    %     text(10,c+2, ['corr: r=' num2str(round(r,2)) ',p=' num2str(round(p,2))],'color',colors{c})
    xlabel('fixation number from trial start')
    title('Target eye-Speed')
    if c==numofSubPlot-1
        legend(folders)
    end
    
    subplot(2,numofSubPlot,numofSubPlot*2)
    errorbar(nanmean(targetSpeed_rev),nanstd(targetSpeed_rev)./sum(~isnan(targetSpeed_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    
    figure(6)
    subplot(2,numofSubPlot,c)
    hold on
    plot(ampFixation','.','color','k')
    M=nanmean(ampFixation(:));
    S=nanstd(ampFixation(:))*STDforOutL;
    ampFixation(~((ampFixation<= M+S)&(ampFixation>= M-S)))=nan;
    plot(ampFixation','.','color',colors{c})
    plot(nanmean(ampFixation),'color',colors{c})
    
    subplot(2,numofSubPlot,c+numofSubPlot)
    hold on
    plot(ampFixation_rev','.','color','k')
    M=nanmean(ampFixation_rev(:));
    S=nanstd(ampFixation_rev(:))*STDforOutL;
    ampFixation_rev(~((ampFixation_rev<= M+S)&(ampFixation_rev>= M-S)))=nan;
    plot(ampFixation_rev','.','color',colors{c})
    plot(nanmean(ampFixation_rev),'color',colors{c})
    
    subplot(2,numofSubPlot,numofSubPlot)
    errorbar(nanmean(ampFixation),nanstd(ampFixation)./sum(~isnan(ampFixation),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Fixation Amplitude')
    if c==numofSubPlot-1
        legend(folders)
    end
    
    subplot(2,numofSubPlot,numofSubPlot*2)
    errorbar(nanmean(ampFixation_rev),nanstd(ampFixation_rev)./sum(~isnan(ampFixation_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    figure(7)
    subplot(2,numofSubPlot,c)
    hold on
    plot(distFixation','.','color','k')
    M=nanmean(distFixation(:));
    S=nanstd(distFixation(:))*STDforOutL;
    distFixation(~((distFixation<= M+S)&(distFixation>= M-S)))=nan;
    plot(distFixation','.','color',colors{c})
    plot(nanmean(distFixation),'color',colors{c})
    
    subplot(2,numofSubPlot,c+numofSubPlot)
    hold on
    plot(distFixation_rev','.','color','k')
    M=nanmean(distFixation_rev(:));
    S=nanstd(distFixation_rev(:))*STDforOutL;
    distFixation_rev(~((distFixation_rev<= M+S)&(distFixation_rev>= M-S)))=nan;
    plot(distFixation_rev','.','color',colors{c})
    plot(nanmean(distFixation_rev),'color',colors{c})
    
    subplot(2,numofSubPlot,numofSubPlot)
    errorbar(nanmean(distFixation),nanstd(distFixation)./sum(~isnan(distFixation),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Fixation Distance')
    if c==numofSubPlot-1
        legend(folders)
    end
    
    subplot(2,numofSubPlot,numofSubPlot*2)
    errorbar(nanmean(distFixation_rev),nanstd(distFixation_rev)./sum(~isnan(distFixation_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    figure(8)
    subplot(2,numofSubPlot,c)
    hold on
    plot(TimeFixation','.','color','k')
    M=nanmean(TimeFixation(:));
    S=nanstd(TimeFixation(:))*STDforOutL;
    TimeFixation(~((TimeFixation<= M+S)&(TimeFixation>= M-S)))=nan;
    plot(TimeFixation','.','color',colors{c})
    plot(nanmean(TimeFixation),'color',colors{c})
    
    subplot(2,numofSubPlot,c+numofSubPlot)
    hold on
    plot(TimeFixation_rev','.','color','k')
    M=nanmean(TimeFixation_rev(:));
    S=nanstd(TimeFixation_rev(:))*STDforOutL;
    TimeFixation_rev(~((TimeFixation_rev<= M+S)&(TimeFixation_rev>= M-S)))=nan;
    plot(TimeFixation_rev','.','color',colors{c})
    plot(nanmean(TimeFixation_rev),'color',colors{c})
    
    subplot(2,numofSubPlot,numofSubPlot)
    errorbar(nanmean(TimeFixation),nanstd(TimeFixation)./sum(~isnan(TimeFixation),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Fixation Duration')
    if c==numofSubPlot-1
        legend(folders)
    end
    
    subplot(2,numofSubPlot,numofSubPlot*2)
    errorbar(nanmean(TimeFixation_rev),nanstd(TimeFixation_rev)./sum(~isnan(TimeFixation_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    activation(c).act=nanmean(infoPerRec);
end

tilefigs;

% figure(20)
%     f=min(size(infoPerRec,2),8);
%     for i=1:f
%         [t,p]=ttest(forStat_infoPerRec{1,1}(:,i),forStat_infoPerRec{1,2}(:,i));
%         if t==1
%         subplot(2,f/2,i)
%         plot(0,30,'*')
%         end
%     end
[h,p] = kstest2(nanmean(forStat_infoPerRec{1,1}),nanmean(forStat_infoPerRec{1,2}));
if h==1
    figure(2)
    subplot(2,4,3)
    text(3,-1.7,'* KS test','FontSize',22)
else
    figure(2)
    subplot(2,4,3)
    text(3,-1.7,'[NS] KS test','FontSize',22)
end

[h,p] = kstest2(nanmean(forStat_numOfinfoRec{1,1}),nanmean(forStat_numOfinfoRec{1,2}));
if h==1
    figure(1)
    subplot(2,4,3)
    text(3,100,'* KS','Fontsize',22)
else
    figure(1)
    subplot(2,4,3)
    text(3,100,'[NS]* KS','Fontsize',22)
end




