%final figures

clear
% close all
compPath='/Users/lirongruber/Documents/GitHub/MIRCS_processedData/processedData/';
% compPath='C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\';

%% figure 1

methods={'subMirc', 'Mirc' ,'Full'};
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};
% currcolor={[180	5	26]./255,[	5	26	180]./255,'k'};

% First session for sub+mirc and full
paths1={[compPath 'OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat'],...
    [compPath 'OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat'],...
    [compPath 'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat'],...
    };
% All sessions for sub+mirc and RECOGNITION
paths2={[compPath 'OnlyFirst0_Sub1Mirc0Full0Ref0_recBoth.mat'],...
    [compPath 'OnlyFirst0_Sub0Mirc1Full0Ref0_recBoth.mat'],...
    [compPath 'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat'],...
    };

for i=1:size(paths1,2)
    figure(1)
    load(paths1{i});
    %recognitions
    subplot(1,2,1)
    hold on
    bar(i+3,mean(didRecog),'FaceColor',currcolor{i},'FaceAlpha',0.5,'EdgeColor',[0 .0 0]);
    errorbar(i+3,mean(didRecog),ste(didRecog),'Color',currcolor{i},'LineWidth',2);
end
pilotResults=[0.3 0.32 0.085  0.05];
pilotTitles={'Stabilized', 'Fixated'};
bar(1:2,pilotResults(1:2),'FaceColor',currcolor{2}.*0.5,'FaceAlpha',0.5,'EdgeColor',[0 .0 0]);
errorbar(1,pilotResults(1),pilotResults(3),'Color',currcolor{2}.*0.5,'LineWidth',2);
errorbar(2,pilotResults(2),pilotResults(4),'Color',currcolor{2}.*0.5,'LineWidth',2);
set(gca, 'XTick', [1:2 4:6], 'XTickLabel', [pilotTitles methods],'Fontsize',25);
xtickangle(45)
title('First trials of each image','Fontsize',40);
ylabel('Recognition Rates','Fontsize',40)

text(0.8,0.41, '5x10', 'FontSize', 20)
text(1.8,0.41, '5x10', 'FontSize', 20)
text(0.85,0.5, 'Pilot MIRCs', 'FontSize', 20)
text(3.7,0.32, '10x10', 'FontSize', 20)
text(4.7,0.87, '10x10', 'FontSize', 20)
text(5.7,0.95, '20x10', 'FontSize', 20)
text(-1,1.05,'a', 'FontSize', 40)
text(8,1.05,'b', 'FontSize', 40)

methods={ 'Recog','Unrecog' };
base=0;
baseNot=0;
for i=1:size(paths2,2)-1
    load(paths2{i});
    recog(i,1)=sum(didRecog);
    recog(i,2)=size(didRecog,2)-sum(didRecog);
end
figure(1)
subplot(1,2,2)
hold on
edgecolor={[74,77,255]./255,[246,75,75]./255};
for i=1:2
ba=bar(i,recog(:,i)','BarLayout','stacked', 'FaceColor','flat','FaceAlpha',0.5,'EdgeColor',edgecolor{i},'LineWidth',3);
ba(1).CData = currcolor{1};
text(i-0.1,recog(1,i)-10, num2str(recog(1,i)), 'FontSize', 25)
ba(2).CData = currcolor{2};
text(i-0.1,recog(1,i)+recog(2,i)-10, num2str(recog(2,i)), 'FontSize', 25)
end
set(gca, 'XTick', 1:2, 'XTickLabel', methods,'Fontsize',25);
xtickangle(45)
title('All trials','Fontsize',40);
ylabel('Total number of trials','Fontsize',40);
axis([-1 4 0 300])

%% figure 2

methods={'Unrecog', 'Recog' };
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};
paths={[ compPath 'OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat'],...
    [compPath 'OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat'],...
    };
for i=1:size(paths,2)
    figure(2)
    load(paths{i});
    %     numOfSacc
    subplot(2,2,1)
    hold on
    bar(i,mean(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),'FaceColor',currcolor{i},'FaceAlpha',0.5,'EdgeColor',[0 0 0]);
    errorbar(i,mean(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),ste(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),'.','Color',currcolor{i},'LineWidth',3);
    set(gca, 'XTick', 1:2, 'XTickLabel', methods,'Fontsize',15);title('Number of Saccades (per sec)','Fontsize',20)
end
text(-1,3.3,'c', 'FontSize', 30)


path=compPath;
paths={
    [path ...
    'OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat']
    [path ...
    'OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat']
    };
paths=paths';
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};

for var=1:3
    for group=1:length(paths)
        load(paths{group});
        meansPerRank{1,group}=zeros(1,25);
        switch var
            case 1
                for i=1:length(drifts_time_ms)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_time_ms{1,i}(drifts_time_ms{1,i}~=0) zeros(1,25-length(drifts_time_ms{1,i}(drifts_time_ms{1,i}~=0)))]];
                end
                rel_title='Fixation Duration';
                rel_y='ISI [ms]';
                rel_min=100;
                rel_max=600;
                subFigLetter='d';
            case 2
                for i=1:length(drifts_vel_deg2sec)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0) zeros(1,25-length(drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0)))]];
                end
                rel_title='Mean Fixation Speed';
                rel_y='speed [deg/sec]';
                rel_min=2.5;
                rel_max=5;
                subFigLetter='e';
            case 3
                for i=1:length(drifts_amp_degrees)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_amp_degrees{1,i}(drifts_amp_degrees{1,i}~=0) zeros(1,25-length(drifts_amp_degrees{1,i}(drifts_amp_degrees{1,i}~=0)))]];
                end
                rel_title='Fixation Amplitudes';
                rel_y='amplitude[deg]';
                rel_min=0.5;
                rel_max=2.5;
                subFigLetter='f';
        end
        for d=1:size(meansPerRank{1,group},1)
            currd=meansPerRank{1,group}(d,:);
            numberOfDrift(d)=length(currd(currd~=0));
        end
        avNumofD=mean(numberOfDrift);
        steNumofD=ste(numberOfDrift);
        relmeans=[];
        relstes=[];
        num_rel_trial=[];
        for r=1:20
            currCol=meansPerRank{1,group}(:,r);
            num_rel_trial(r)=length(currCol(currCol~=0));
            if num_rel_trial(r)> 0.2*length(currCol)
                relmeans(r)=mean(currCol(currCol~=0));
                relstes(r)=ste(currCol(currCol~=0));
            end
        end
        meansPerRank{2,group}=relmeans;
       
        figure(2)
        subplot(2,2,var+1)
        hold all
        h=errorbar(relmeans,relstes,'Color',currcolor{group},'lineWidth',2);
        if var==0
            plot(ones(1,2).*avNumofD-steNumofD,[(rel_max-rel_min)*0.7+rel_min (rel_max-rel_min)*0.73+rel_min],'Color',currcolor{group},'lineWidth',2)
            plot(ones(1,2).*avNumofD+steNumofD,[(rel_max-rel_min)*0.7+rel_min (rel_max-rel_min)*0.73+rel_min],'Color',currcolor{group},'lineWidth',2)
            plot([avNumofD-steNumofD avNumofD+steNumofD],[0.713*(rel_max-rel_min)+rel_min 0.713*(rel_max-rel_min)+rel_min],'Color',currcolor{group})
        else
            plot(ones(1,2).*avNumofD-steNumofD,[(rel_max-rel_min)*0.8+rel_min (rel_max-rel_min)*0.83+rel_min],'Color',currcolor{group},'lineWidth',2)
            plot(ones(1,2).*avNumofD+steNumofD,[(rel_max-rel_min)*0.8+rel_min (rel_max-rel_min)*0.83+rel_min],'Color',currcolor{group},'lineWidth',2)
            plot([avNumofD-steNumofD avNumofD+steNumofD],[0.813*(rel_max-rel_min)+rel_min 0.813*(rel_max-rel_min)+rel_min],'Color',currcolor{group})
        end
        axis([0 9 rel_min rel_max])
%         text(0.1,(rel_max-rel_min)*0.75+rel_min,'Trial end (mean+STE):','Fontsize',14)
        title(rel_title,'Fontsize',20)
        xlabel(['fixation ' '\#'],'Fontsize',18)
        ylabel(rel_y,'Fontsize',20)
    end
   
    [hh,pp] = kstest2(meansPerRank{2,1},meansPerRank{2,2});
    if hh==1
        subplot(2,2,var+1)
        text(4,(rel_max-rel_min)*0.2+rel_min,'* KS','Fontsize',22)
    end
    text(-2,rel_max+(rel_max-rel_min)*0.1,subFigLetter, 'FontSize', 30)
end

%% figure 3
%for filter figure

xlabel('time [ms]','Fontsize',40)
xticks([-100 -50 0])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',20)
ylabel('filter','Fontsize',40)

paths={...
    [compPath 'OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat'],...
    [compPath 'OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat'],...
%     [ compPath 'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat'],...
    };
type=1;
s=11;

currcolor={[246,75,75]./255,[74,77,255]./255,'k'};

windowAvSize_forMean=3;%1
windowAvSize_forStd=3;%3
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};

for group=1:length(paths)
    MeanVel=[];
    MeanVar=[];
    relD=0;
    
    if exist(paths{group})
        load(paths{group});
        for t =1:size(labeled_saccade_vecs,2)
            currSaccVec=labeled_saccade_vecs{1,t};
            XY_vec_deg=XY_vecs_deg{1,t};
            for i=0:size(currSaccVec,2)
                temp=[];
                if isempty(find(currSaccVec,1))
                    temp=XY_vec_deg';
                else
                    if i==0
                        temp=(XY_vec_deg(:,(1:currSaccVec(1,1)))');
                    else if i<size(currSaccVec,2)
                            temp=(XY_vec_deg(:,((currSaccVec(1,i)+currSaccVec(2,i)):currSaccVec(1,i+1)))');
                        else
                            temp=(XY_vec_deg(:,((currSaccVec(1,i)+currSaccVec(2,i)):end))');
                        end
                    end
                end
                
                if length(temp)>25 && size(currSaccVec,2)>2 && sum(sum(isnan(temp)))==0
                    currAmp=[];
                    local_curvature=[];
                    for j=2:length(temp)
                        currAmp(j-1) = sqrt((temp(j,1)-temp(j-1,1))^2+(temp(j,2)-temp(j-1,2))^2);
                    end
                    %
                    if max(currAmp)<0.12
                        relD=relD+1;
                        %for any given drift
                        M=movmean(currAmp./4*1000,windowAvSize_forMean);
                        V=movvar(currAmp./4*1000,windowAvSize_forStd);
                        
                        MeanVel(relD,1:length(M))=M;
                        MeanVar(relD,1:length(M))=V;
                        
                    end
                end
                MeanVel(MeanVel==0)=nan;
                MeanVar(MeanVar==0)=nan;
                
            end
        end
        
        figure(3)
%         subplot(2,2,2)
        subplot(2,3,4)
                
        
        errorbar((1:size(MeanVel,2)).*4,nanmean(MeanVel),nanstd(MeanVel)./sqrt(size(MeanVel,1)-sum(isnan(MeanVel))),'color',currcolor{1,group},'LineWidth',3)
        hold on
        plot((1:size(MeanVel,2)).*4,nanmean(MeanVel),'k')
        targetV1=nanmean(MeanVel);
        targetV=mean(targetV1(25:50)); %targetV=mean(targetV(100/4:200/4));
        targetV_STE=ste(targetV1(25:50));
        text(40,targetV*2-1,['Target speed (t >100ms) = ' num2str(round(targetV,2)) char(177)  num2str(round(targetV_STE,2))],'color',currcolor{1,group},'FontSize', 15)
        axis([0 200 2.5 7.2])
%         axis([0 8 2.5 7.2])
        
        ylabel('speed [deg/sec]','FontSize', 30)
        xlabel('time within pause [ms] ','Fontsize',30)
        title('Fixation Instantaneous Speed','Fontsize',30)
        box off
        all{group}=nanmean(MeanVel);
    end
    
end
[s,t]=kstest2(all{1}(25:50),all{2}(25:50));
if s==1
    text(100,2.8,'* KS','Fontsize',22)
end

% load('classFullImages.mat')
% temp=cell(1,126);
% fullImages={class{1,:} , temp{1,:} };
load('class.mat')
nonRecog={class{2,:}  class{4,:}};
recog={class{1,:}  class{3,:}};
% class={fullImages{1,:}  ;  recog{1,:} ; nonRecog{1,:} };
class={ recog{1,:} ; nonRecog{1,:} };


% colors={[0,0,0],[74,77,255]./255,[246,75,75]./255};
colors={[74,77,255]./255,[246,75,75]./255};
% folders={'fullImage','Recognized','Not Recognized'};
folders={'Recognized','Not Recognized'};

STDforOutL=2; %number of std from mean to include
perNonNan2include=0.9;

forSVM={};
numofSubPlot=size(folders,2)+1;
forStat_infoPerRec={};
for c=1:size(class,1)
    numOfinfoRec=nan(size(class,2),30);
    infoPerRec=nan(size(class,2),30);
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            %number of info receptors
            numOfinfoRec(t,1:size(currT.numOfinfoRec,2))=currT.numOfinfoRec;
            % mean rec activations
            infoPerRec(t,1:size(currT.meanInfoPerRec,2))=currT.meanInfoPerRec;
            % mean rec Inst_activations
            temp=zeros(12,200);
            for f=1:size(currT.meanRecActivation,2)
                temp(f,1:size(currT.meanRecActivation{1,f},2))=currT.meanRecActivation{1,f};
            end
            temp(temp==0)=nan;
            meanTemp=nanmean(temp);
            Inst_infoPerRec(t,1:size(meanTemp,2))=meanTemp;
        end
    end
    
    %1
    numOfinfoRec=numOfinfoRec(:,sum(isnan(numOfinfoRec))<size(numOfinfoRec,1)*perNonNan2include);
    M=nanmean(numOfinfoRec(:));
    S=nanstd(numOfinfoRec(:))*STDforOutL;
    numOfinfoRec(~((numOfinfoRec<= M+S)&(numOfinfoRec>= M-S)))=nan;
    numOfinfoRec(numOfinfoRec==0)=nan;
    %2
    Inst_infoPerRec(Inst_infoPerRec==0)=nan;
    infoPerRec=infoPerRec(:,sum(isnan(infoPerRec))<size(infoPerRec,1)*perNonNan2include);
    M=nanmean(infoPerRec(:));
    S=nanstd(infoPerRec(:))*STDforOutL;
    infoPerRec(~((infoPerRec<= M+S)&(infoPerRec>= M-S)))=nan;
    %3
    Inst_infoPerRec=Inst_infoPerRec(:,sum(isnan(Inst_infoPerRec))<size(Inst_infoPerRec,1)*perNonNan2include);
    M=nanmean(Inst_infoPerRec(:));
    S=nanstd(Inst_infoPerRec(:))*STDforOutL;
    Inst_infoPerRec(~((Inst_infoPerRec<= M+S)&(Inst_infoPerRec>= M-S)))=nan;
    
    figure(30)
    subplot(2,2,3)
    numOfinfoRec(numOfinfoRec==0)=nan;
    errorbar(nanmedian(numOfinfoRec),nanstd(numOfinfoRec)./sum(~isnan(numOfinfoRec),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('fixation \#','Fontsize',30)
    title(' Number of informative receptors','Fontsize',30)
    box off
    forStat_numOfinfoRec{c}=numOfinfoRec;
    
    figure(3)
%     subplot(2,2,3)
    subplot(2,3,5)

    errorbar(nanmean(infoPerRec),nanstd(infoPerRec)./sum(~isnan(infoPerRec),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('fixation \# ','Fontsize',30)
    ylabel('activation [NA]','Fontsize',30)
    title('Mean Retinal Activation','Fontsize',30)
%     text(-2,5.5,'c','Fontsize',30)
%     text(9,5.5,'d','Fontsize',30)
%     text(-2,1.5,'e','Fontsize',30)
%     text(9,1.5,'f','Fontsize',30)
    text(-11.3,1.7,'c','Fontsize',40)
    text(-1,1.7,'d','Fontsize',40)
    text(9.5,1.7,'e','Fontsize',40)
    box off
    forStat_infoPerRec{c}=infoPerRec;
    
    figure(3)
%     subplot(2,2,4)
    subplot(2,3,6)

    relSize=size(nanmean(Inst_infoPerRec),2);
    errorbar(0:8:8*relSize-1,nanmean(Inst_infoPerRec),nanstd(Inst_infoPerRec)./sum(~isnan(Inst_infoPerRec),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('time within pause [ms] ','Fontsize',30)
    ylabel('activation [NA]','Fontsize',30)
    title('Retinal Instantaneous Activation','Fontsize',30)
    
    box off
    forStat_Inst_infoPerRec{c}=Inst_infoPerRec;
    axis([0 200 -0.45 0.25])
end
[h,p] = kstest2(nanmean(forStat_infoPerRec{1,1}),nanmean(forStat_infoPerRec{1,2}));
if h==1
    figure(3)
%     subplot(2,2,3)
     subplot(2,3,5)
    text(3,-1.7,'* KS','FontSize',22)
else
    figure(3)
%     subplot(2,2,3)
     subplot(2,3,5)
    text(3,-1.7,'[NS] KS','FontSize',22)
end
[h,p] = kstest2(nanmean(forStat_numOfinfoRec{1,1}),nanmean(forStat_numOfinfoRec{1,2}));
if h==1
    figure(30)
    subplot(2,2,3)
    text(3,100,'* KS','Fontsize',22)
else
    figure(30)
    subplot(2,2,3)
    text(3,100,'[NS]* KS','Fontsize',22)
end
[h,p] = kstest2(nanmean(forStat_Inst_infoPerRec{1,1}(:,15:50)),nanmean(forStat_Inst_infoPerRec{1,2}(:,15:50)));
if h==1
    figure(3)
%     subplot(2,2,4)
     subplot(2,3,6)
    text(100,0,'* KS','Fontsize',22)
    M(1)=mean(nanmean(forStat_Inst_infoPerRec{1,1}(:,13:50)));
    M(2)=mean(nanmean(forStat_Inst_infoPerRec{1,2}(:,13:50)));
    S(1)=ste(nanmean(forStat_Inst_infoPerRec{1,1}(:,13:50)));
    S(2)=ste(nanmean(forStat_Inst_infoPerRec{1,2}(:,13:50)));
    text(10,0.2,['Target activation (t >100ms) = ' num2str(round(M(1),3)) char(177)  num2str(round(S(1),3))],'color',currcolor{1,2},'FontSize', 15)
    text(10,0.15,['Target activation (t >100ms) = ' num2str(round(M(2),3)) char(177)  num2str(round(S(2),3))],'color',currcolor{1,1},'FontSize', 15)

else
    figure(3)
%     subplot(2,2,4)
     subplot(2,3,6)
        text(100,-0.1,'[NS]* KS','Fontsize',22)
end

%% figure 4
%subplot 1
load('instSpeed.mat')
instAct=perCorrect_l;
load('instActivation.mat')
instSpeed=perCorrect_l;

figure(4)
subplot(2,1,1)
hold on
s=0;
colors={[178,32,40]./255,[32,178,170]./255};
titles={'SVM - instanteneus Speed vs. Activation'};

for test={instAct, instSpeed} 
    s=s+1;
    errorbar(1:size(test{1},1),mean(test{1}',1),std(test{1}',1),'color',colors{s},'LineWidth',4)
end
plot(0:8, 0.5*ones(1,9),'k--')
ylabel('fraction','Fontsize',20)
xlabel('fixation number','Fontsize',20)
axis([0 8 0.3 0.85])
text(-0.5,0.9,'a','Fontsize',30)
title(titles{1},'Fontsize',20)
legend('speed','activation','')
legend boxoff
box off


figure(5)
%subplot 2
load('meanSpeedandAct.mat')
meanSpeedAct=perCorrect_l;
subplot(3,2,3)
hold on

errorbar(1,mean(meanSpeedAct(1,:)),std(meanSpeedAct(1,:)),'color',colors{1},'LineWidth',4)
errorbar(2,mean(meanSpeedAct(2,:)),std(meanSpeedAct(2,:)),'color',colors{2},'LineWidth',4)
xticks([1 2])
xticklabels({'Speed' ,'Activation'})
% xtickangle(20)
%yticks([0.4 0.5 0.6])
title('SVM - Mean values','Fontsize',20)
plot(0:3, 0.5*ones(1,4),'k--')
ylabel('fraction correct','Fontsize',20)
axis([0 3 0.3 0.85])
box off
text(-0.5,0.95,'b','Fontsize',30)
text(3.5,0.95,'c','Fontsize',30)
text(-0.5,0.13,'d','Fontsize',30)
text(3.5,0.13,'e','Fontsize',30)

%subplot 3
load('fullTrial_800ms.mat')
full_800=perCorrect_l;
load('windows_800ms.mat')
windows_800=windows;

load('fullTrial_400ms.mat')
full_400=perCorrect_l;
load('windows_400ms.mat')
windows_400=windows;

load('fullTrial_200ms.mat')
full_200=perCorrect_l;
load('windows_200ms.mat')
windows_200=windows;

subplot(3,2,5)
hold on
s=0;

newcolors = {[1.00 0.54 0.00],[0.47 0.25 0.80],[0.25 0.80 0.54]};
% colororder(newcolors)
titles={'SVM - Full trials'};
windows={windows_200(:,1)',windows_400(:,1)',windows_800(:,1)'};
for test={full_200,full_400,full_800}
    s=s+1;
    errorbar(windows{s}.*8,mean(test{1}',1),std(test{1}',1),'color',newcolors{s},'LineWidth',2)
end
axis([0 3000 0.3 0.85])
legend boxoff 
plot(0:375, 0.5*ones(1,376),'k--')
legend('window=200 ms','window=400 ms','window=800 ms')
ylabel('fraction correct','Fontsize',20)
xlabel('starting time','Fontsize',20)
title(titles{1},'Fontsize',20)
box off

%subplot 4-
load('control1_withinGroups.mat')
control1=perCorrect_l;

load('control2_betweenGroups.mat')
control2=perCorrect_l;

load('control3_withinTrial.mat')
control3=perCorrect_l;

subplot(3,2,4)
hold on
s=0;

newcolors = {[1.00 0.54 0.00],[0.47 0.25 0.80],[0.25 0.80 0.54]};
% colororder(newcolors)
titles={'SVM - Mixed controls'};
for test={control1,control2,control3}
    s=s+1;
    errorbar(1:7,mean(test{1}',1),std(test{1}',1),'color',newcolors{s},'LineWidth',2)
end
axis([0 8 0.3 0.85])
legend boxoff 
plot(0:375, 0.5*ones(1,376),'k--')
legend('Mixing within groups','Mixing between groups','Mixing within trials')
% ylabel('fraction correct','Fontsize',20)
xlabel('fixation number','Fontsize',20)
title(titles{1},'Fontsize',20)
box off

%subplot 5-
load('frameStart.mat')
firstFrame=perCorrect_l;

load('FrameEnd.mat')
lastFrame=perCorrect_l;

load('FrameMean.mat')
meanFrame=perCorrect_l;

subplot(3,2,6)
hold on
s=0;

newcolors = {[1.00 0.54 0.00],[0.47 0.25 0.80],[0.25 0.80 0.54]};
% newcolors = [...
%              1.00 0.54 0.00
%              0.47 0.25 0.80
%              0.25 0.80 0.54];
% colororder(newcolors)
titles={'SVM - Saccadic based controls'};
for test={firstFrame,lastFrame,meanFrame} %
    s=s+1;
    errorbar(1:7,mean(test{1}(1:7,:)',1),std(test{1}(1:7,:)',1),'color',newcolors{s},'LineWidth',2)
end
axis([0 8 0.3 0.85])
plot(0:8, 0.5*ones(1,9),'k--')
legend('begining frame','end frame','mean frame')
legend boxoff
% ylabel('fraction correct','Fontsize',20)
xlabel('fixation number','Fontsize',20)
title(titles{1},'Fontsize',20)
box off

%% supp figure 1
clear
close all

currcolor={'m','b','c','k'};
methods={'subMirc' 'Mirc'};

orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane'};
mircsIm=dir('C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\MIRCs');
subIm=dir('C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\subMIRCs');

% sub mircs
for i=1:length(orderPicsNames)
    sub_paths{1,i}=[compPath orderPicsNames{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat'];
end
for i=1:length(orderPicsNames)
    mirc_paths{1,i}=[compPath orderPicsNames{1,i} '_OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat'];
end

for image=1:10
    sub=load(sub_paths{1,image});
    mirc=load(mirc_paths{1,image});
    figure(10)
    bar(image*2-1,mean(sub.didRecog),'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.3);
    hold on
    errorbar(image*2-1,mean(sub.didRecog),ste(sub.didRecog),'.','Color',currcolor{1},'LineWidth',2);
    bar(image*2,mean(mirc.didRecog),'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.3);
    errorbar(image*2,mean(mirc.didRecog),ste(mirc.didRecog),'.','Color',currcolor{2},'LineWidth',2);
    set(gca, 'XTick', 1:2:20, 'XTickLabel', orderPicsNames,'Fontsize',30);
    xtickangle(45)
    title('Recognition per image','Fontsize',40)
    ylabel('Rate','Fontsize',40)
    axis([0 21 0 1.2])
    text(image*2-1,1.15,num2str(mean(mirc.didRecog)-mean(sub.didRecog)),'Fontsize',40)
    if (mean(mirc.didRecog)-mean(sub.didRecog))<0.4
        text(image*2-1,1.15,num2str(mean(mirc.didRecog)-mean(sub.didRecog)),'Fontsize',40,'Color','r')
    end
    box off
end
for pic=1:10
    for image=1:13
        curr_m=mircsIm(image+2).name;
        curr_s=subIm(image+2).name;
        if strcmp(orderPicsNames{1,pic}(1:min(4,size(orderPicsNames{1,pic},2))),curr_m(1:min(4,size(orderPicsNames{1,pic},2))))
            %             subplot(2,2,1)
            axes('pos',[(pic-1)*0.075+.16 .8 .06 .06])
            imshow(['C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\MIRCs\' curr_m])
            axes('pos',[(pic-1)*0.075+.12 .8 .06 .06])
            imshow(['C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\subMIRCs\' curr_s])
       break
        end
    end
end

%% figure S2
load('correlationThresholds.mat')
newcolors = {[184,216,160]./255,[232,160,0]./255,[192,40,120]./255,[16,72,144]./255,[32,200,184]./255,};

 figure(20)
 for c=1
     all_MEAN_histValues=correlationsTh{c};
%     subplot(1,4,c)
    hold on
    color=0;
    for i=1:10:size(0.02:0.02:1,2)
        color=color+1;
        perTh=all_MEAN_histValues(:,i);
        if c==1
        plot(perTh,'Color',newcolors{color})
        xlabel('fixation number','Fontsize',20)
        ylabel('percent of informative receptors','Fontsize',20)
        else
           plot(perTh,'--','Color',newcolors{color}) 
        end
    end
    legend( num2str([0.02 0.2 0.4 0.6 0.8]'))
    legend boxoff
    axis([0 9 0 0.2])
    title('Informative receptors','Fontsize',30)
text(4.5,0.185,'Threshold=','Fontsize',20)
 end