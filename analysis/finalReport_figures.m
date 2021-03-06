%final figures

clear
% close all

%% figure 2

methods={'subMirc', 'Mirc' ,'Full'};
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};

% First session for sub+mirc and full
paths1={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
    };
% All sessions for sub+mirc and RECOGNITION
paths2={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc0Full0Ref0_recBoth.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc1Full0Ref0_recBoth.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
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
set(gca, 'XTick', [1:2 4:6], 'XTickLabel', [pilotTitles methods],'Fontsize',15);
title('First trials of each image','Fontsize',20);
ylabel('Recognition Rates','Fontsize',20)

text(0.8,0.41, '5x10', 'FontSize', 15)
text(1.8,0.41, '5x10', 'FontSize', 15)
text(0.85,0.5, 'Pilot MIRCs', 'FontSize', 15)
text(3.7,0.32, '10x10', 'FontSize', 15)
text(4.7,0.87, '10x10', 'FontSize', 15)
text(5.7,0.95, '20x10', 'FontSize', 15)
text(-1,1.05,'a', 'FontSize', 30)

for i=1:size(paths2,2)-1
    figure(1)
    load(paths2{i});
    %recognitions
    subplot(1,2,2)
    hold on
    bar(i,mean(didRecog),'FaceColor',currcolor{i},'FaceAlpha',0.5,'EdgeColor',[0 .0 0]);
    errorbar(i,mean(didRecog),ste(didRecog),'Color',currcolor{i},'LineWidth',2);
    set(gca, 'XTick', 1:3, 'XTickLabel', methods,'Fontsize',15);title('All trials','Fontsize',20);
    means(i)
end
text(0.6,0.6, '20x10', 'FontSize', 15)
text(1.6,0.78, '20x10', 'FontSize', 15)
text(-1,1.05,'b', 'FontSize', 30)

%% figure 3

methods={'Unrecog', 'Recog' };
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};
paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat',...
    };
for i=1:size(paths,2)
    figure(2)
    load(paths{i});
    %     numOfSacc
    subplot(2,2,1)
    hold on
    bar(i,mean(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),'FaceColor',currcolor{i},'FaceAlpha',0.5,'EdgeColor',[0 0 0]);
    errorbar(i,mean(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),ste(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),'.','Color',currcolor{i},'LineWidth',2);
    set(gca, 'XTick', 1:2, 'XTickLabel', methods,'Fontsize',15);title('Number of Saccades (per sec)','Fontsize',20)
end
text(-1,3.3,'a', 'FontSize', 30)


path='C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\';
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
                subFigLetter='b';
            case 2
                for i=1:length(drifts_vel_deg2sec)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0) zeros(1,25-length(drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0)))]];
                end
                rel_title='Mean Fixation Speed';
                rel_y='speed [deg/sec]';
                rel_min=2.5;
                rel_max=5;
                subFigLetter='c';
            case 3
                for i=1:length(drifts_amp_degrees)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_amp_degrees{1,i}(drifts_amp_degrees{1,i}~=0) zeros(1,25-length(drifts_amp_degrees{1,i}(drifts_amp_degrees{1,i}~=0)))]];
                end
                rel_title='Fixation Amplitudes';
                rel_y='amplitude[deg]';
                rel_min=0.5;
                rel_max=2.5;
                subFigLetter='d';
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
        h{group}=errorbar(relmeans,relstes,'Color',currcolor{group},'lineWidth',2);
        
        plot(ones(1,2).*avNumofD-steNumofD,[(rel_max-rel_min)*0.7+rel_min (rel_max-rel_min)*0.73+rel_min],'Color',currcolor{group},'lineWidth',2)
        plot(ones(1,2).*avNumofD+steNumofD,[(rel_max-rel_min)*0.7+rel_min (rel_max-rel_min)*0.73+rel_min],'Color',currcolor{group},'lineWidth',2)
        plot([avNumofD-steNumofD avNumofD+steNumofD],[0.713*(rel_max-rel_min)+rel_min 0.713*(rel_max-rel_min)+rel_min],'Color',currcolor{group})
        axis([0 9 rel_min rel_max])
        text(0.1,(rel_max-rel_min)*0.75+rel_min,'Trial end (mean+STE):','Fontsize',14)
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

%% figure 4
paths={...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
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
        subplot(2,2,2)
        
        errorbar((1:size(MeanVel,2)).*4,nanmean(MeanVel),nanstd(MeanVel)./sqrt(size(MeanVel,1)-sum(isnan(MeanVel))),'color',currcolor{1,group},'LineWidth',3)
        hold on
        plot((1:size(MeanVel,2)).*4,nanmean(MeanVel),'k')
        targetV1=nanmean(MeanVel);
        targetV=mean(targetV1(25:50)); %targetV=mean(targetV(100/4:200/4));
        targetV_STE=ste(targetV1(25:50));
        text(50,targetV*2-1,['Target speed (t >100ms) = ' num2str(round(targetV,2)) char(177)  num2str(round(targetV_STE,2))],'color',currcolor{1,group},'FontSize', 15)
        axis([0 200 0 9])
        
%         xlabel('time within pause [ms] ','Fontsize',18)
        ylabel('speed [deg/sec]','FontSize', 20)
        title('Fixation Instantaneous Speed','Fontsize',20)
        text(-30,10,'b','Fontsize',30)
        box off
        all{group}=nanmean(MeanVel);
    end
    
end
[s,t]=kstest2(all{1}(25:50),all{2}(25:50));
if s==1
    text(100,2.5,'* KS','Fontsize',22)
end

load('classFullImages.mat')
temp=cell(1,126);
fullImages={class{1,:} , temp{1,:} };
load('class.mat')
nonRecog={class{2,:}  class{4,:}};
recog={class{1,:}  class{3,:}};
class={fullImages{1,:}  ;  recog{1,:} ; nonRecog{1,:} };

colors={[0,0,0],[74,77,255]./255,[246,75,75]./255};
folders={'fullImage','Recognized','Not Recognized'};

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
    xlabel('fixation \#','Fontsize',18)
    title(' Number of informative receptors','Fontsize',20)
    box off
    forStat_numOfinfoRec{c}=numOfinfoRec;
    
    figure(3)
    subplot(2,2,3)
    errorbar(nanmean(infoPerRec),nanstd(infoPerRec)./sum(~isnan(infoPerRec),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('fixation \# ','Fontsize',18)
    title('Mean Retinal Activation','Fontsize',20)
    text(-2,1.5,'c','Fontsize',30)
    box off
    forStat_infoPerRec{c}=infoPerRec;
    
    figure(3)
    subplot(2,2,4)
    relSize=size(nanmean(Inst_infoPerRec),2);
    errorbar(0:8:8*relSize-1,nanmean(Inst_infoPerRec),nanstd(Inst_infoPerRec)./sum(~isnan(Inst_infoPerRec),1),'color',colors{c},'lineWidth',2)
    hold on
    xlabel('time within pause [ms] ','Fontsize',18)
    title('Retinal Instantaneous Activation','Fontsize',20)
    text(-35,.3,'d','Fontsize',30)
    box off
    forStat_Inst_infoPerRec{c}=Inst_infoPerRec;
    axis([0 200 -0.45 0.25])
end
[h,p] = kstest2(nanmean(forStat_infoPerRec{1,2}),nanmean(forStat_infoPerRec{1,3}));
if h==1
    figure(3)
    subplot(2,2,3)
    text(3,-1.7,'* KS','FontSize',22)
else
    figure(3)
    subplot(2,4,3)
    text(3,-1.7,'[NS] KS','FontSize',22)
end
[h,p] = kstest2(nanmean(forStat_numOfinfoRec{1,2}),nanmean(forStat_numOfinfoRec{1,3}));
if h==1
    figure(30)
    subplot(2,2,3)
    text(3,100,'* KS','Fontsize',22)
else
    figure(30)
    subplot(2,2,3)
    text(3,100,'[NS]* KS','Fontsize',22)
end
[h,p] = kstest2(nanmean(forStat_Inst_infoPerRec{1,2}(:,15:50)),nanmean(forStat_Inst_infoPerRec{1,3}(:,15:50)));
if h==1
    figure(3)
    subplot(2,2,4)
    text(100,0,'* KS','Fontsize',22)
    M(1)=mean(nanmean(forStat_Inst_infoPerRec{1,1}(:,13:50)));
    M(2)=mean(nanmean(forStat_Inst_infoPerRec{1,2}(:,13:50)));
    S(1)=ste(nanmean(forStat_Inst_infoPerRec{1,1}(:,13:50)));
    S(2)=ste(nanmean(forStat_Inst_infoPerRec{1,2}(:,13:50)));
    text(50,0.2,['Target activation (t >100ms) = ' num2str(round(M(1),3)) char(177)  num2str(round(S(1),3))],'color',currcolor{1,2},'FontSize', 12)
    text(50,0.15,['Target activation (t >100ms) = ' num2str(round(M(2),3)) char(177)  num2str(round(S(2),3))],'color',currcolor{1,1},'FontSize', 12)

else
    figure(3)
    subplot(2,2,4)
        text(100,-0.1,'[NS]* KS','Fontsize',22)
end

