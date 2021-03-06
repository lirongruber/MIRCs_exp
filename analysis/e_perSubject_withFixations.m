%per Subject

clear
% close all

currcolor={'b','m','c','k'};
% currcolor={[120 178 171]./255,[80 156 135]./255,[71 131 108]./255,[45 116 82]./255};
% currcolor={[181,8,4]./255,[234,166,18]./255,[133,134,15]./255,[131,188,195]./255};

%mircs: subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM'}
%submircs: subjects={'EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'}
%all: subjects={'AK','FS','EM','GG','GH','GS','HL','IN','LS','NA','NG','RB','SE','SG','SS','TT','UK','YB','YM','YS'};
p=[0,0];
subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM','EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'};
for i=1:length(subjects)
    if exist(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No_subMIRCGROUP.mat'],'file')
        type=1;
        p(type)=p(type)+1;
        name='subMIRCs';
        trial(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No_subMIRCGROUP.mat']);
        reference(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_subMIRCGROUP.mat']);
        
        types(i)=type;
        color=[0 220 220];
    else
        type=2;
        p(type)=p(type)+1;
        name='MIRCs';
        trial(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes_MIRCGROUP.mat']);
        reference(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_MIRCGROUP.mat']);
        types(i)=type;
        color=[220 220 0];
    end
    
    if exist(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat'])
        trial(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat']);
        reference(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat']);
        
        figure(2)
        subplot(2,1,1)
        bar(i*2-1,mean(reference(i).num_of_sacc_per_sec),'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
        hold on
        bar(i*2,mean(trial(i).num_of_sacc_per_sec),'FaceColor',color./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
        errorbar(i*2-1,mean(reference(i).num_of_sacc_per_sec),ste(reference(i).num_of_sacc_per_sec),'.','Color','k','LineWidth',2);
        errorbar(i*2,mean(trial(i).num_of_sacc_per_sec),ste(trial(i).num_of_sacc_per_sec),'.','Color','b','LineWidth',2);
        set(gca, 'XTick', 1:2:40, 'XTickLabel', subjects,'Fontsize',12);
        legend('reference','trial')
        title(' Number of Saccades (per second)','Fontsize',20)
        axis([0 41 0 5])
        %
        subplot(2,1,2)
        
        r_curr_drifts_vel_deg2sec=[];
        for ii=1:length(reference(i).drifts_vel_deg2sec)
            r_curr_drifts_vel_deg2sec=[r_curr_drifts_vel_deg2sec reference(i).drifts_vel_deg2sec{1,ii}];
        end
        reference(i).drifts_vel_deg2sec=r_curr_drifts_vel_deg2sec;
        
        r_curr_drifts_amp_degrees=[];
        for ii=1:length(reference(i).drifts_amp_degrees)
            r_curr_drifts_amp_degrees=[r_curr_drifts_amp_degrees reference(i).drifts_amp_degrees{1,ii}];
        end
        reference(i).drifts_amp_degrees=r_curr_drifts_amp_degrees;
        
        r_curr_drifts_time_ms=[];
        for ii=1:length(reference(i).drifts_time_ms)
            r_curr_drifts_time_ms=[r_curr_drifts_time_ms reference(i).drifts_time_ms{1,ii}];
        end
        reference(i).drifts_time_ms=r_curr_drifts_time_ms;
        
        t_curr_drifts_vel_deg2sec=[];
        for ii=1:trial(i).numberOfRelevantTrials
            t_curr_drifts_vel_deg2sec=[t_curr_drifts_vel_deg2sec trial(i).drifts_vel_deg2sec{1,length(trial(i).drifts_vel_deg2sec)-ii+1}]; %
        end
        trial(i).drifts_vel_deg2sec=t_curr_drifts_vel_deg2sec;
        
         t_curr_drifts_amp_degrees=[];
        for ii=1:length(trial(i).drifts_amp_degrees)
            t_curr_drifts_amp_degrees=[t_curr_drifts_amp_degrees trial(i).drifts_amp_degrees{1,ii}];
        end
        trial(i).drifts_amp_degrees=t_curr_drifts_amp_degrees;
        
        t_curr_drifts_time_ms=[];
        for ii=1:length(trial(i).drifts_time_ms)
            t_curr_drifts_time_ms=[t_curr_drifts_time_ms trial(i).drifts_time_ms{1,ii}];
        end
        trial(i).drifts_time_ms=t_curr_drifts_time_ms;
        
%         currmean=mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0));
        currmean=mean(r_curr_drifts_amp_degrees(r_curr_drifts_amp_degrees~=0));
        bar(i*2-1,currmean,'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
        hold on
%         errorbar(i*2-1,currmean,ste(r_curr_drifts_vel_deg2sec),'.','Color','k','LineWidth',2);
        errorbar(i*2-1,currmean,ste(r_curr_drifts_amp_degrees),'.','Color','k','LineWidth',2);
        set(gca, 'XTick', 1:2:40, 'XTickLabel', subjects,'Fontsize',12);
%         title('Drift Speed' ,'Fontsize',20)
title('Drift Amp' ,'Fontsize',20)
        axis([0 41 0 10])
        
%         currmean=mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0));
        currmean=mean(t_curr_drifts_amp_degrees(t_curr_drifts_amp_degrees~=0));
        bar(i*2,currmean,'FaceColor',color./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
        hold on
%         errorbar(i*2,currmean,ste(t_curr_drifts_vel_deg2sec),'.','Color','b','LineWidth',2);
        errorbar(i*2,currmean,ste(t_curr_drifts_amp_degrees),'.','Color','b','LineWidth',2);
        
        figure(type+9)
        subplot(2,10,p(type))
        hold on
        errorbar(1,mean(trial(i).num_of_sacc_per_sec(end-trial(i).numberOfRelevantTrials+1:end)),ste(trial(i).num_of_sacc_per_sec(end-trial(i).numberOfRelevantTrials+1:end)),currcolor{type})
        plot(1,mean(trial(i).num_of_sacc_per_sec(end-trial(i).numberOfRelevantTrials+1:end)),['.' currcolor{type}])
        errorbar(2,mean(reference(i).num_of_sacc_per_sec),ste(reference(i).num_of_sacc_per_sec),'k')
        plot(2,mean(reference(i).num_of_sacc_per_sec),'.k')
        axis([0 4 0 5])
        ylabel('Number of Sacc')
        set(gca, 'XTick', 1:3, 'XTickLabel', {'trial','ref','full'},'Fontsize',12);
        
        subplot(2,10,10+p(type))
        hold on
        xlabel(subjects{1,i})
        ylabel('Drift speed')
        
        
        h=histogram(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0),0:0.2:30,'Normalization','probability','FaceColor',currcolor{type});
        plot([mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)) mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0))],[0 0.5],'--','Color',currcolor{type})
        errorbar(mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)),0.4,std(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)),'horizontal','Color',currcolor{type})
        
        h=histogram(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0),0:0.2:30,'Normalization','probability','FaceColor','k');
        plot([mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)) mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0))],[0 0.5],'--','Color','k')
        errorbar(mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)),0.4,std(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)),'horizontal','Color','k')
        
        axis([0 11 0 0.5])
        
        figure(type+9)
        subplot(2,10,1)
        title(name)
    end
end

%% comparing two groups (sub+mirc) reference scores:
Sub_driftSpeed=[];
Sub_saccRate=[];
Sub_driftAmp=[];
Sub_driftDur=[];
refSub_driftSpeed=[];
refSub_saccRate=[];
refSub_driftAmp=[];
refSub_driftDur=[];


Mirc_driftSpeed=[];
Mirc_saccRate=[];
Mirc_driftAmp=[];
Mirc_driftDur=[];
refMirc_driftSpeed=[];
refMirc_saccRate=[];
refMirc_driftAmp=[];
refMirc_driftDur=[];

for i=[1:7 9:20]
    if types(i)==1
        Sub_driftSpeed=[Sub_driftSpeed trial(i).drifts_vel_deg2sec];
        Sub_saccRate=[Sub_saccRate trial(i).num_of_sacc_per_sec];
        Sub_driftAmp=[Sub_driftAmp trial(i).drifts_amp_degrees];
        Sub_driftDur=[Sub_driftDur trial(i).drifts_time_ms];
        refSub_driftSpeed=[refSub_driftSpeed reference(i).drifts_vel_deg2sec];
        refSub_saccRate=[refSub_saccRate reference(i).num_of_sacc_per_sec];
        refSub_driftAmp=[refSub_driftAmp reference(i).drifts_amp_degrees];
        refSub_driftDur=[refSub_driftDur reference(i).drifts_time_ms];
    else
        Mirc_driftSpeed=[Mirc_driftSpeed trial(i).drifts_vel_deg2sec];
        Mirc_saccRate=[Mirc_saccRate trial(i).num_of_sacc_per_sec];
        Mirc_driftAmp=[Mirc_driftAmp trial(i).drifts_amp_degrees];
        Mirc_driftDur=[Mirc_driftDur trial(i).drifts_time_ms];
        refMirc_driftSpeed=[refMirc_driftSpeed reference(i).drifts_vel_deg2sec];
        refMirc_saccRate=[refMirc_saccRate reference(i).num_of_sacc_per_sec];
        refMirc_driftAmp=[refMirc_driftAmp reference(i).drifts_amp_degrees];
        refMirc_driftDur=[refMirc_driftDur reference(i).drifts_time_ms];
    end
end

    figure(3)
    hold on
    subplot(1,2,1)
    hold on
    h=histogram(refSub_driftAmp(refSub_driftAmp~=0),0:0.2:30,'Normalization','probability','FaceColor','k');
    hold on
    plot([median(refSub_driftAmp(refSub_driftAmp~=0)) median(refSub_driftAmp(refSub_driftAmp~=0))],[0 0.2],'--','Color','k')
    h=histogram(Sub_driftAmp(Sub_driftAmp~=0),0:0.2:30,'Normalization','probability','FaceColor','b');
    plot([median(Sub_driftAmp(Sub_driftAmp~=0)) median(Sub_driftAmp(Sub_driftAmp~=0))],[0 0.2],'--','Color','b')
    % h=histogram(fullSub_driftSpeed(fullSub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
    % plot([median(fullSub_driftSpeed(fullSub_driftSpeed~=0)) median(fullSub_driftSpeed(fullSub_driftSpeed~=0))],[0 0.2],'--','Color','c')
    axis([0 15 0 0.2])
    
    subplot(1,2,2)
    hold on
    h=histogram(refMirc_driftAmp(refMirc_driftAmp~=0),0:0.2:30,'Normalization','probability','FaceColor','k');
    plot([median(refMirc_driftAmp(refMirc_driftAmp~=0)) median(refMirc_driftAmp(refMirc_driftAmp~=0))],[0 0.2],'--','Color','k')
    h=histogram(Mirc_driftAmp(Mirc_driftAmp~=0),0:0.2:30,'Normalization','probability','FaceColor','m');
    plot([median(Mirc_driftAmp(Mirc_driftAmp~=0)) median(Mirc_driftAmp(Mirc_driftAmp~=0))],[0 0.2],'--','Color','m')
    % h=histogram(fullMirc_driftSpeed(fullMirc_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
    % plot([median(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)) median(fullMirc_driftSpeed(fullMirc_driftSpeed~=0))],[0 0.2],'--','Color','c')
    axis([0 15 0 0.2])
    title('Drift amp')
    
    figure(4)
    hold on
    subplot(1,2,1)
    hold on
    h=histogram(refSub_driftSpeed(refSub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','k');
    hold on
    plot([median(refSub_driftSpeed(refSub_driftSpeed~=0)) median(refSub_driftSpeed(refSub_driftSpeed~=0))],[0 0.2],'--','Color','k')
    h=histogram(Sub_driftSpeed(Sub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','b');
    plot([median(Sub_driftSpeed(Sub_driftSpeed~=0)) median(Sub_driftSpeed(Sub_driftSpeed~=0))],[0 0.2],'--','Color','b')
    % h=histogram(fullSub_driftSpeed(fullSub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
    % plot([median(fullSub_driftSpeed(fullSub_driftSpeed~=0)) median(fullSub_driftSpeed(fullSub_driftSpeed~=0))],[0 0.2],'--','Color','c')
    axis([0 15 0 0.2])
    
    subplot(1,2,2)
    hold on
    h=histogram(refMirc_driftSpeed(refMirc_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','k');
    plot([median(refMirc_driftSpeed(refMirc_driftSpeed~=0)) median(refMirc_driftSpeed(refMirc_driftSpeed~=0))],[0 0.2],'--','Color','k')
    h=histogram(Mirc_driftSpeed(Mirc_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','m');
    plot([median(Mirc_driftSpeed(Mirc_driftSpeed~=0)) median(Mirc_driftSpeed(Mirc_driftSpeed~=0))],[0 0.2],'--','Color','m')
    % h=histogram(fullMirc_driftSpeed(fullMirc_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
    % plot([median(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)) median(fullMirc_driftSpeed(fullMirc_driftSpeed~=0))],[0 0.2],'--','Color','c')
    axis([0 15 0 0.2])
    title('Drift speed')
    
    figure(5)
    hold on
    subplot(1,2,1)
    hold on
    h=histogram(refSub_driftDur(refSub_driftDur~=0),0:50:1000,'Normalization','probability','FaceColor','k');
    hold on
    plot([median(refSub_driftDur(refSub_driftDur~=0)) median(refSub_driftDur(refSub_driftDur~=0))],[0 0.2],'--','Color','k')
    h=histogram(Sub_driftDur(Sub_driftDur~=0),0:50:1000,'Normalization','probability','FaceColor','b');
    plot([median(Sub_driftDur(Sub_driftDur~=0)) median(Sub_driftDur(Sub_driftDur~=0))],[0 0.2],'--','Color','b')
    % h=histogram(fullSub_driftSpeed(fullSub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
    % plot([median(fullSub_driftSpeed(fullSub_driftSpeed~=0)) median(fullSub_driftSpeed(fullSub_driftSpeed~=0))],[0 0.2],'--','Color','c')
%     axis([0 15 0 0.2])
    
    subplot(1,2,2)
    hold on
    h=histogram(refMirc_driftDur(refMirc_driftDur~=0),0:50:1000,'Normalization','probability','FaceColor','k');
    plot([median(refMirc_driftDur(refMirc_driftDur~=0)) median(refMirc_driftDur(refMirc_driftDur~=0))],[0 0.2],'--','Color','k')
    h=histogram(Mirc_driftDur(Mirc_driftDur~=0),0:50:1000,'Normalization','probability','FaceColor','m');
    plot([median(Mirc_driftDur(Mirc_driftDur~=0)) median(Mirc_driftDur(Mirc_driftDur~=0))],[0 0.2],'--','Color','m')
    % h=histogram(fullMirc_driftSpeed(fullMirc_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
    % plot([median(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)) median(fullMirc_driftSpeed(fullMirc_driftSpeed~=0))],[0 0.2],'--','Color','c')
%     axis([0 15 0 0.2])
    title('Drift Dur')
    
    figure(6)
    hold on
    plot(1,mean(refSub_saccRate),'.k')
    errorbar(1,mean(refSub_saccRate),ste(refSub_saccRate),'k')
    plot(1,mean(Sub_saccRate),'.b')
    errorbar(1,mean(Sub_saccRate),ste(Sub_saccRate),'b')
    
    plot(2,mean(refMirc_saccRate),'.k')
    errorbar(2,mean(refMirc_saccRate),ste(refMirc_saccRate),'k')
    plot(2,mean(Mirc_saccRate),'.m')
    errorbar(2,mean(Mirc_saccRate),ste(Mirc_saccRate),'m')
    
    axis([0 3 0 3])
    title('Saccadic rate')
