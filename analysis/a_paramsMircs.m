% saccades rate
clear
close all

% methods={'Unrecog', 'Recog', 'Full' };
% currcolor={[246,75,75]./255,[74,77,255]./255,'k'};

methods={'subMirc', 'Mirc' ,'Full'};
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};

% methods={'subMirc', 'Mirc' ,'refSub',  'refMIRC'};
% currcolor={[246,75,75]./255,[74,77,255]./255,'k','k'};

% methods={'No' ,'Yes','both' ,'full' };
% methods={'session 1' 'session 2' 'session 3','session 4' };

% % First session for sub+mirc and full
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
%     };
% % All sessions for both (sub+mirc) RECOGNITION VS NO RECOGNITION
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
% %                 'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth.mat',...
%     };

% All sessions for sub+mirc and RECOGNITION
paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc0Full0Ref0_recBoth.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc1Full0Ref0_recBoth.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
    };

% per session order 1-4
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\onlySession1_Sub1Mirc1Full1Ref1_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\onlySession2_Sub1Mirc1Full1Ref1_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\onlySession3_Sub1Mirc1Full1Ref1_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\onlySession4_Sub1Mirc1Full1Ref1_recBoth.mat',...
%     };
% all sessions for each type
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc0Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc1Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth.mat',...
%     };
% First session for sub+mirc all
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth.mat',...
%     };
% all sessionS for sub+mirc RECOGNITION
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc1Full0Ref0_rec Yes.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc1Full0Ref0_rec No.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth.mat',...
%     };
%%

for i=1:size(paths,2)
    figure(1)
    load(paths{i});
    %recognitions
    subplot(2,2,2)
    hold on
    bar(i,mean(didRecog),'FaceColor',currcolor{i},'FaceAlpha',0.5,'EdgeColor',[0 .0 0]);
    errorbar(i,mean(didRecog),ste(didRecog),'Color',currcolor{i},'LineWidth',2);
    set(gca, 'XTick', 1:3, 'XTickLabel', methods,'Fontsize',15);title('Recognition Rates','Fontsize',20)
%     numOfSacc
    subplot(2,2,1)
    hold on
    bar(i,mean(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),'FaceColor',currcolor{i},'FaceAlpha',0.5,'EdgeColor',[0 0 0]);
    errorbar(i,mean(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),ste(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),'.','Color',currcolor{i},'LineWidth',2);
    set(gca, 'XTick', 1:3, 'XTickLabel', methods,'Fontsize',15);title('Number of Saccades (per second)','Fontsize',20)
    %driftTime - ISI
    if i==1 || i==2
        subplot(4,4,9)
%         subplot(2,2,2)
        title('Drift Duration','Fontsize',20)
        xlabel('Time [ms]','Fontsize',20)
    else
        subplot(4,4,13)
%         subplot(2,2,2)
        xlabel('Time [ms]','Fontsize',20)
    end
    hold on
    curr_drifts_time_ms{i}=[];
    for ii=1:size(drifts_time_ms,2)
        curr_drifts_time_ms{i}=[curr_drifts_time_ms{i} drifts_time_ms{1,ii}];
    end
    currmean=mean(curr_drifts_time_ms{i}(curr_drifts_time_ms{i}~=0));
    h=histogram(curr_drifts_time_ms{i}(curr_drifts_time_ms{i}~=0),0:50:1000,'Normalization','probability','FaceColor',currcolor{i});
    hold on
    plot([currmean currmean],[0 0.2],'--','Color',currcolor{i})
    axis([0 1000 0 0.2])
    %driftAmp
    if i==1 || i==2
        subplot(4,4,10)
        title('Drift Amplitude','Fontsize',20)
        xlabel('amp [deg]','Fontsize',20)
    else
        subplot(4,4,14)
        xlabel('amp [deg]','Fontsize',20)
    end
    hold on
    curr_drifts_amp_degrees{i}=[];
    for ii=1:length(drifts_amp_degrees)
        curr_drifts_amp_degrees{i}=[curr_drifts_amp_degrees{i} drifts_amp_degrees{1,ii}];
    end
    currmean=mean(curr_drifts_amp_degrees{i}(curr_drifts_amp_degrees{i}~=0));
    h=histogram(curr_drifts_amp_degrees{i}(curr_drifts_amp_degrees{i}~=0),0:0.2:15,'Normalization','probability','FaceColor',currcolor{i});
    plot([currmean currmean],[0 0.2],'--','Color',currcolor{i})
    axis([0 5 0 0.2])
    %driftVel
    if i==1 || i==2
        subplot(4,4,11)
        title('Drift Speed','Fontsize',20)
        xlabel('speed [deg/sec]','Fontsize',20)
    else
        subplot(4,4,15)
        xlabel('speed [deg/sec]','Fontsize',20)
    end
    hold on
    curr_drifts_vel_deg2sec{i}=[];
    for ii=1:length(drifts_vel_deg2sec)
        curr_drifts_vel_deg2sec{i}=[curr_drifts_vel_deg2sec{i} drifts_vel_deg2sec{1,ii}];
    end
    currmean=mean(curr_drifts_vel_deg2sec{i}(curr_drifts_vel_deg2sec{i}~=0));
    h=histogram(curr_drifts_vel_deg2sec{i}(curr_drifts_vel_deg2sec{i}~=0),0:0.3:15,'Normalization','probability','FaceColor',currcolor{i});
    plot([currmean currmean],[0 0.2],'--','Color',currcolor{i})
    axis([0 10 0 0.2])
    %drift Curvature
    if i==1 || i==2
        subplot(4,4,12)
        title('Drift Curvature','Fontsize',20)
        xlabel('CI [AU]','Fontsize',20)
    else
        subplot(4,4,16)
        xlabel('CI [AU]','Fontsize',20)
    end
    hold on
    curr_drifts_Cur_CI{i}=[];
    for ii=1:length(drifts_curve_CI)
        curr_drifts_Cur_CI{i}=[curr_drifts_Cur_CI{i} drifts_curve_CI{1,ii}];
    end
    currmean=mean(curr_drifts_Cur_CI{i}(curr_drifts_Cur_CI{i}~=0));
    h=histogram(curr_drifts_Cur_CI{i}(curr_drifts_Cur_CI{i}~=0),0:0.05:1,'Normalization','probability','FaceColor',currcolor{i});
    plot([currmean currmean],[0 0.2],'--','Color',currcolor{i})
    axis([0 1 0 0.2])
end






[s,t]=ttest2(curr_drifts_time_ms{1}(curr_drifts_time_ms{1}~=0),curr_drifts_time_ms{2}(curr_drifts_time_ms{2}~=0));
if s==1
    figure(1)
    subplot(4,4,9)
    plot(5,0.2,'*k')
end
[s,t]=ttest2(curr_drifts_amp_degrees{1}(curr_drifts_amp_degrees{1}~=0),curr_drifts_amp_degrees{2}(curr_drifts_amp_degrees{2}~=0));
if s==1
    figure(1)
    subplot(4,4,10)
    plot(0.5,0.2,'*k')
end
[s,t]=ttest2(curr_drifts_vel_deg2sec{1}(curr_drifts_vel_deg2sec{1}~=0),curr_drifts_vel_deg2sec{2}(curr_drifts_vel_deg2sec{2}~=0));
if s==1
    figure(1)
    subplot(4,4,11)
    plot(0.5,0.2,'*k')
end
[s,t]=ttest2(curr_drifts_Cur_CI{1}(curr_drifts_Cur_CI{1}~=0),curr_drifts_Cur_CI{2}(curr_drifts_Cur_CI{2}~=0));
if s==1
    figure(1)
    subplot(4,4,12)
    plot(0.05,0.2,'*k')
end


% set(gca, 'XTick', 1:4, 'XTickLabel', methods,'Fontsize',12);