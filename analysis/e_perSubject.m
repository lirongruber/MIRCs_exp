%per Subject

clear
close all

currcolor={'b','m','c','k'};
% currcolor={[120 178 171]./255,[80 156 135]./255,[71 131 108]./255,[45 116 82]./255};
% currcolor={[181,8,4]./255,[234,166,18]./255,[133,134,15]./255,[131,188,195]./255};

%mircs: subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM'}
%submircs: subjects={'EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'}
%all: subjects={'AK','FS','EM','GG','GH','GS','HL','IN','LS','NA','NG','RB','SE','SG','SS','TT','UK','YB','YM','YS'};
p=[0,0];
subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM','EM','HL','NA','RB','SG','SS','YB','YS','SE','GS'}; %,'SE','GS'
for i=1:length(subjects)
    
    if exist(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No_subMIRCGROUP.mat'],'file')
        type=1;
        p(type)=p(type)+1;
        name='subMIRCs';
        trial(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No_subMIRCGROUP.mat']);
        refe(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_subMIRCGROUP.mat']);
        full(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth_subMIRCGROUP.mat']);
        types(i)=type;
        color=[0 0 255];
    else
        type=2;
        p(type)=p(type)+1;
        name='MIRCs';
        trial(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes_MIRCGROUP.mat']);
        refe(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_MIRCGROUP.mat']);
        full(i)=load(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth_MIRCGROUP.mat']);
        types(i)=type;
        color=[255 0 255];
    end
    
    figure(2)
    subplot(2,1,1)
    bar(i*2,mean(trial(i).num_of_sacc_per_sec),'FaceColor',color./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
    bar(i*2-1,mean(refe(i).num_of_sacc_per_sec),'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
    hold on
%     bar(i*2,mean(trial(i).num_of_sacc_per_sec),'FaceColor',color./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
    errorbar(i*2,mean(trial(i).num_of_sacc_per_sec),ste(refe(i).num_of_sacc_per_sec),'.','Color','k','LineWidth',2);
    errorbar(i*2-1,mean(refe(i).num_of_sacc_per_sec),ste(refe(i).num_of_sacc_per_sec),'.','Color','k','LineWidth',2);
%     errorbar(i*2,mean(trial(i).num_of_sacc_per_sec),ste(trial(i).num_of_sacc_per_sec),'.','Color','b','LineWidth',2);
    set(gca, 'XTick', 1:2:40, 'XTickLabel', subjects,'Fontsize',12);
%     legend('reference','trial')
    title(' Number of Saccades (per second)','Fontsize',20)
    axis([0 41 0 5])
    %
    subplot(2,1,2)
    f_curr_drifts_vel_deg2sec=[];
    for ii=1:length(full(i).drifts_vel_deg2sec)
        f_curr_drifts_vel_deg2sec=[f_curr_drifts_vel_deg2sec full(i).drifts_vel_deg2sec{1,ii}];
    end
    full(i).drifts_vel_deg2sec=f_curr_drifts_vel_deg2sec;
    
    r_curr_drifts_vel_deg2sec=[];
    for ii=1:length(refe(i).drifts_vel_deg2sec)
        r_curr_drifts_vel_deg2sec=[r_curr_drifts_vel_deg2sec refe(i).drifts_vel_deg2sec{1,ii}];
    end
    refe(i).drifts_vel_deg2sec=r_curr_drifts_vel_deg2sec;
    
    t_curr_drifts_vel_deg2sec=[];
    for ii=1:trial(i).numberOfRelevantTrials
        t_curr_drifts_vel_deg2sec=[t_curr_drifts_vel_deg2sec trial(i).drifts_vel_deg2sec{1,length(trial(i).drifts_vel_deg2sec)-ii+1}];
    end
    trial(i).drifts_vel_deg2sec=t_curr_drifts_vel_deg2sec;
    
    currmean=mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0));
    bar(i*2-1,currmean,'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
    hold on
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
    errorbar(1,mean(trial(i).num_of_sacc_per_sec),ste(trial(i).num_of_sacc_per_sec),currcolor{type})
    plot(1,mean(trial(i).num_of_sacc_per_sec),['.' currcolor{type}])
    errorbar(2,mean(refe(i).num_of_sacc_per_sec),ste(refe(i).num_of_sacc_per_sec),'k')
    plot(2,mean(refe(i).num_of_sacc_per_sec),'.k')
    errorbar(3,mean(full(i).num_of_sacc_per_sec),ste(full(i).num_of_sacc_per_sec),'c')
    plot(3,mean(full(i).num_of_sacc_per_sec),'.c')
    axis([0 4 0 5])
    ylabel('Number of Sacc')
    set(gca, 'XTick', 1:3, 'XTickLabel', {'trial','ref','full'},'Fontsize',12);
    
    subplot(2,10,10+p(type))
    hold on
    %     errorbar(1,mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)),ste(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)), currcolor{type})
    %     plot(1,mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)),['.' currcolor{type}])
    %     errorbar(2,mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)),ste(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)),'k')
    %     plot(2,mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)),'.k')
    %     errorbar(3,mean(f_curr_drifts_vel_deg2sec(f_curr_drifts_vel_deg2sec~=0)),ste(f_curr_drifts_vel_deg2sec(f_curr_drifts_vel_deg2sec~=0)),'c')
    %     plot(3,mean(f_curr_drifts_vel_deg2sec(f_curr_drifts_vel_deg2sec~=0)),'.c')
        xlabel(subjects{1,i})
    %     axis([0 4 0 9])
        ylabel('Drift speed')
    %     set(gca, 'XTick', 1:3, 'XTickLabel', {'trial','ref','full'},'Fontsize',12);
    %
   
    h=histogram(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0),0:0.2:30,'Normalization','probability','FaceColor',currcolor{type});
    plot([mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)) mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0))],[0 0.5],'--','Color',currcolor{type})
    errorbar(mean(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)),0.4,std(t_curr_drifts_vel_deg2sec(t_curr_drifts_vel_deg2sec~=0)),'horizontal','Color',currcolor{type})
    
    h=histogram(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0),0:0.2:30,'Normalization','probability','FaceColor','k');
    plot([mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)) mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0))],[0 0.5],'--','Color','k')
    errorbar(mean(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)),0.4,std(r_curr_drifts_vel_deg2sec(r_curr_drifts_vel_deg2sec~=0)),'horizontal','Color','k')
    
    %     h=histogram(f_curr_drifts_vel_deg2sec(f_curr_drifts_vel_deg2sec~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
    %     plot([mean(f_curr_drifts_vel_deg2sec(f_curr_drifts_vel_deg2sec~=0)) mean(f_curr_drifts_vel_deg2sec(f_curr_drifts_vel_deg2sec~=0))],[0 0.2],'--','Color','c')
    %     errorbar(mean(f_curr_drifts_vel_deg2sec(f_curr_drifts_vel_deg2sec~=0)),0.4,std(f_curr_drifts_vel_deg2sec(f_curr_drifts_vel_deg2sec~=0)),'horizontal','Color','c')
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
fullSub_driftSpeed=[];
fullSub_saccRate=[];

Mirc_driftSpeed=[];
Mirc_saccRate=[];
refMirc_driftSpeed=[];
refMirc_saccRate=[];
fullMirc_driftSpeed=[];
fullMirc_saccRate=[];

for i=1:size(subjects,2)
    if types(i)==1
        Sub_driftSpeed=[Sub_driftSpeed trial(i).drifts_vel_deg2sec];
        Sub_saccRate=[Sub_saccRate trial(i).num_of_sacc_per_sec];
        refSub_driftSpeed=[refSub_driftSpeed refe(i).drifts_vel_deg2sec];
        refSub_saccRate=[refSub_saccRate refe(i).num_of_sacc_per_sec];
        fullSub_driftSpeed=[fullSub_driftSpeed full(i).drifts_vel_deg2sec];
        fullSub_saccRate=[fullSub_saccRate full(i).num_of_sacc_per_sec];
    else
        Mirc_driftSpeed=[Mirc_driftSpeed trial(i).drifts_vel_deg2sec];
        Mirc_saccRate=[Mirc_saccRate trial(i).num_of_sacc_per_sec];
        refMirc_driftSpeed=[refMirc_driftSpeed refe(i).drifts_vel_deg2sec];
        refMirc_saccRate=[refMirc_saccRate refe(i).num_of_sacc_per_sec];
        fullMirc_driftSpeed=[fullMirc_driftSpeed full(i).drifts_vel_deg2sec];
        fullMirc_saccRate=[fullMirc_saccRate full(i).num_of_sacc_per_sec];
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
h=histogram(refSub_driftSpeed(refSub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','b');
plot([median(refSub_driftSpeed(refSub_driftSpeed~=0)) median(refSub_driftSpeed(refSub_driftSpeed~=0))],[0 0.2],'--','Color','b')
h=histogram(refMirc_driftSpeed(refMirc_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','m');
plot([median(refMirc_driftSpeed(refMirc_driftSpeed~=0)) median(refMirc_driftSpeed(refMirc_driftSpeed~=0))],[0 0.2],'--','Color','m')
% h=histogram(fullSub_driftSpeed(fullSub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
% plot([median(fullSub_driftSpeed(fullSub_driftSpeed~=0)) median(fullSub_driftSpeed(fullSub_driftSpeed~=0))],[0 0.2],'--','Color','c')
axis([0 15 0 0.2])

title('Reference : Drift speed')

% plot(2,mean(refMirc_driftSpeed(refMirc_driftSpeed~=0)),'.k')
% errorbar(2,mean(refMirc_driftSpeed(refMirc_driftSpeed~=0)),ste(refMirc_driftSpeed(refMirc_driftSpeed~=0)),'k')
% plot(2,mean(Mirc_driftSpeed(Mirc_driftSpeed~=0)),'.m')
% errorbar(2,mean(Mirc_driftSpeed(Mirc_driftSpeed~=0)),ste(Mirc_driftSpeed(Mirc_driftSpeed~=0)),'m')
% plot(2,mean(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)),'.c')
% errorbar(2,mean(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)),ste(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)),'c')
% axis([0 3 0 5.5])

subplot(1,2,2)
hold on
h=histogram(Sub_driftSpeed(Sub_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','b');
plot([mean(Sub_driftSpeed(Sub_driftSpeed~=0)) median(Sub_driftSpeed(Sub_driftSpeed~=0))],[0 0.2],'--','Color','b')
h=histogram(Mirc_driftSpeed(Mirc_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','m');
plot([mean(Mirc_driftSpeed(Mirc_driftSpeed~=0)) median(Mirc_driftSpeed(Mirc_driftSpeed~=0))],[0 0.2],'--','Color','m')
% h=histogram(fullMirc_driftSpeed(fullMirc_driftSpeed~=0),0:0.2:30,'Normalization','probability','FaceColor','c');
% plot([median(fullMirc_driftSpeed(fullMirc_driftSpeed~=0)) median(fullMirc_driftSpeed(fullMirc_driftSpeed~=0))],[0 0.2],'--','Color','c')
axis([0 15 0 0.2])

title('Trials : Drift speed')
legend ('subMIRCs participants','Median','MIRCs participants','Median')

figure(4)
hold on
plot(1,mean(refSub_saccRate),'.k')
errorbar(1,mean(refSub_saccRate),ste(refSub_saccRate),'k')
plot(1,mean(Sub_saccRate),'.b')
errorbar(1,mean(Sub_saccRate),ste(Sub_saccRate),'b')
plot(1,mean(fullSub_saccRate),'.c')
errorbar(1,mean(fullSub_saccRate),ste(fullSub_saccRate),'c')

plot(2,mean(refMirc_saccRate),'.k')
errorbar(2,mean(refMirc_saccRate),ste(refMirc_saccRate),'k')
plot(2,mean(Mirc_saccRate),'.m')
errorbar(2,mean(Mirc_saccRate),ste(Mirc_saccRate),'m')
plot(2,mean(fullMirc_saccRate),'.c')
errorbar(2,mean(fullMirc_saccRate),ste(fullMirc_saccRate),'c')
axis([0 3 0 3])
title('Saccadic rate')