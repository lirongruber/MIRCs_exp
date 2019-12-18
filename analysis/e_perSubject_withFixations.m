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
    if exist(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat'],'file')
        type=1;
        p(type)=p(type)+1;
        name='subMIRCs';
        trial(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat']);
        fixation(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No_fixation.mat']);

        types(i)=type;
        color=[0 220 220];
    else
        type=2;
        p(type)=p(type)+1;
        name='MIRCs';
        trial(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat']);
        fixation(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes_fixation.mat']);
        types(i)=type;
        color=[220 220 0];
    end
    
    figure(2)
    subplot(2,1,1)
    bar(i*2-1,mean(fixation(i).num_of_sacc_per_sec),'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
    hold on
    bar(i*2,mean(trial(i).num_of_sacc_per_sec),'FaceColor',color./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
    errorbar(i*2-1,mean(fixation(i).num_of_sacc_per_sec),ste(fixation(i).num_of_sacc_per_sec),'.','Color','k','LineWidth',2);
    errorbar(i*2,mean(trial(i).num_of_sacc_per_sec),ste(trial(i).num_of_sacc_per_sec),'.','Color','b','LineWidth',2);
    set(gca, 'XTick', 1:2:40, 'XTickLabel', subjects,'Fontsize',12);
    legend('fixation','trial')
    title(' Number of Saccades (per second)','Fontsize',20)
    axis([0 41 0 5])
    %
    subplot(2,1,2)
    
    r_curr_drifts_vel_deg2sec=[];
    for ii=1:length(fixation(i).drifts_vel_deg2sec)
        r_curr_drifts_vel_deg2sec=[r_curr_drifts_vel_deg2sec fixation(i).drifts_vel_deg2sec{1,ii}];
    end
    fixation(i).drifts_vel_deg2sec=r_curr_drifts_vel_deg2sec;
    
    t_curr_drifts_vel_deg2sec=[];
    for ii=1:trial(i).numberOfRelevantTrials
        t_curr_drifts_vel_deg2sec=[t_curr_drifts_vel_deg2sec trial(i).drifts_vel_deg2sec{1,length(trial(i).drifts_vel_deg2sec)-ii+1}];
    end
    trial(i).drifts_vel_deg2sec=t_curr_drifts_vel_deg2sec;
    
    currmean=mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0));
    bar(i*2-1,currmean,'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
    errorbar(i*2-1,currmean,ste(r_curr_drifts_vel_deg2sec),'.','Color','k','LineWidth',2);
    set(gca, 'XTick', 1:2:40, 'XTickLabel', subjects,'Fontsize',12);
    title('Drift Speed' ,'Fontsize',20)
    axis([0 41 0 10])
    
    currmean=mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0));
    bar(i*2,currmean,'FaceColor',color./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
    hold on
    errorbar(i*2,currmean,ste(t_curr_drifts_vel_deg2sec),'.','Color','b','LineWidth',2);
    
    figure(type+9)
    subplot(2,10,p(type))
    hold on
    errorbar(1,mean(trial(i).num_of_sacc_per_sec(end-trial(i).numberOfRelevantTrials+1:end)),ste(trial(i).num_of_sacc_per_sec(end-trial(i).numberOfRelevantTrials+1:end)),currcolor{type})
    plot(1,mean(trial(i).num_of_sacc_per_sec(end-trial(i).numberOfRelevantTrials+1:end)),['.' currcolor{type}])
    errorbar(2,mean(fixation(i).num_of_sacc_per_sec),ste(fixation(i).num_of_sacc_per_sec),'k')
    plot(2,mean(fixation(i).num_of_sacc_per_sec),'.k')
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

%% comparing two groups (sub+mirc) reference scores:
Sub_driftSpeed=[];
Sub_saccRate=[];
refSub_driftSpeed=[];
refSub_saccRate=[];


Mirc_driftSpeed=[];
Mirc_saccRate=[];
refMirc_driftSpeed=[];
refMirc_saccRate=[];


for i=1:20
    if types(i)==1
        Sub_driftSpeed=[Sub_driftSpeed trial(i).drifts_vel_deg2sec];
        Sub_saccRate=[Sub_saccRate trial(i).num_of_sacc_per_sec(end-trial(i).numberOfRelevantTrials+1:end)];
        refSub_driftSpeed=[refSub_driftSpeed fixation(i).drifts_vel_deg2sec];
        refSub_saccRate=[refSub_saccRate fixation(i).num_of_sacc_per_sec];
            else
        Mirc_driftSpeed=[Mirc_driftSpeed trial(i).drifts_vel_deg2sec];
        Mirc_saccRate=[Mirc_saccRate trial(i).num_of_sacc_per_sec(end-trial(i).numberOfRelevantTrials+1:end)];
        refMirc_driftSpeed=[refMirc_driftSpeed fixation(i).drifts_vel_deg2sec];
        refMirc_saccRate=[refMirc_saccRate fixation(i).num_of_sacc_per_sec];
           end
end

figure(3)
hold on
% plot(1,mean(refSub_driftSpeed(refSub_driftSpeed~=0)),'.k')
% errorbar(1,mean(refSub_driftSpeed(refSub_driftSpeed~=0)),ste(refSub_driftSpeed(refSub_driftSpeed~=0)),'k')
% plot(1,mean(Sub_driftSpeed(Sub_driftSpeed~=0)),'.b')
% errorbar(1,mean(Sub_driftSpeed(Sub_driftSpeed~=0)),ste(Sub_driftSpeed(Sub_driftSpeed~=0)),'b')
% plot(1,mean(fullSub_driftSpeed(fullSub_driftSpeed~=0)),'.c')
% errorbar(1,mean(fullSub_driftSpeed(fullSub_driftSpeed~=0)),ste(fullSub_driftSpeed(fullSub_driftSpeed~=0)),'c')
subplot(1,2,1)
hold on
h=histogram(refSub_driftSpeed(refSub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','k');
plot([median(refSub_driftSpeed(refSub_driftSpeed~=0)) median(refSub_driftSpeed(refSub_driftSpeed~=0))],[0 0.2],'--','Color','k')
h=histogram(Sub_driftSpeed(Sub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','b');
plot([median(Sub_driftSpeed(Sub_driftSpeed~=0)) median(Sub_driftSpeed(Sub_driftSpeed~=0))],[0 0.2],'--','Color','b')
% h=histogram(fullSub_driftSpeed(fullSub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
% plot([median(fullSub_driftSpeed(fullSub_driftSpeed~=0)) median(fullSub_driftSpeed(fullSub_driftSpeed~=0))],[0 0.2],'--','Color','c')
axis([0 15 0 0.2])

% plot(2,mean(refMirc_driftSpeed(refMirc_driftSpeed~=0)),'.k')
% errorbar(2,mean(refMirc_driftSpeed(refMirc_driftSpeed~=0)),ste(refMirc_driftSpeed(refMirc_driftSpeed~=0)),'k')
% plot(2,mean(Mirc_driftSpeed(Mirc_driftSpeed~=0)),'.m')
% errorbar(2,mean(Mirc_driftSpeed(Mirc_driftSpeed~=0)),ste(Mirc_driftSpeed(Mirc_driftSpeed~=0)),'m')
% plot(2,mean(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)),'.c')
% errorbar(2,mean(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)),ste(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)),'c')
% axis([0 3 0 5.5])

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

figure(4)
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