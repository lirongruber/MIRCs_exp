% saccades rate
clear
% close all

currcolor={'b','m','c','k'};
% currcolor={[120 178 171]./255,[80 156 135]./255,[71 131 108]./255,[45 116 82]./255};
% currcolor={[181,8,4]./255,[234,166,18]./255,[133,134,15]./255,[131,188,195]./255};

methods={'subMirc' 'Mirc' 'fullImage',  'refImage'};
% methods={'No' ,'Yes','both' ,'full' };
% methods={'session 1' 'session 2' 'session 3','session 4' };

% % sub mircs per RECOGNITION
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_rec Yes.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
%     };
% % mircs per RECOGNITION
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_rec No.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
%     };
% First session for sub+mirc and RECOGNITION
paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth.mat',...
    };
% % per session order 1-4 
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\onlySession1_Sub1Mirc1Full1Ref1_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\onlySession2_Sub1Mirc1Full1Ref1_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\onlySession3_Sub1Mirc1Full1Ref1_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\onlySession4_Sub1Mirc1Full1Ref1_recBoth.mat',...
%     };
% % all sessions for each type 
% paths={'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc0Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc1Full0Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth.mat',...
%     };
% % First session for sub+mirc all 
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
figure(2)
for i=1:4
load(paths{i});
%recognitions
subplot(2,2,2)
hold on
bar(i,mean(didRecog),'FaceColor',[220 220 220]./255,'EdgeColor',[0 .0 0]);
errorbar(i,mean(didRecog),ste(didRecog),'Color',currcolor{i},'LineWidth',2);
set(gca, 'XTick', 1:4, 'XTickLabel', methods,'Fontsize',12);title('Recognition Rates','Fontsize',20)
%numOfSacc
subplot(2,2,1)
hold on
bar(i,mean(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),'FaceColor',[220 220 220]./255,'EdgeColor',[0 0 0]);
errorbar(i,mean(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),ste(num_of_sacc_per_sec(num_of_sacc_per_sec~=0)),'.','Color',currcolor{i},'LineWidth',2);
set(gca, 'XTick', 1:4, 'XTickLabel', methods,'Fontsize',12);title('Number of Saccades (per second)','Fontsize',20)
%driftAmp
if i==1 || i==2
subplot(4,2,5)
title('Drift Amplitude','Fontsize',20)
else  
subplot(4,2,7)
xlabel('amp [deg]','Fontsize',20)
end
hold on
curr_drifts_amp_degrees{i}=[];
for ii=1:length(drifts_amp_degrees)
    curr_drifts_amp_degrees{i}=[curr_drifts_amp_degrees{i} drifts_amp_degrees{1,ii}];
end
currmean=median(curr_drifts_amp_degrees{i}(curr_drifts_amp_degrees{i}~=0));
h=histogram(curr_drifts_amp_degrees{i}(curr_drifts_amp_degrees{i}~=0),0:0.2:30,'Normalization','probability','FaceColor',currcolor{i});
plot([currmean currmean],[0 0.2],'--','Color',currcolor{i})
axis([0 15 0 0.2])
%driftVel
if i==1 || i==2
subplot(4,2,6)
title('Drift Speed','Fontsize',20)
else
subplot(4,2,8)
xlabel('speed [deg/sec]','Fontsize',20)
end
hold on
curr_drifts_vel_deg2sec{i}=[];
for ii=1:length(drifts_vel_deg2sec)
    curr_drifts_vel_deg2sec{i}=[curr_drifts_vel_deg2sec{i} drifts_vel_deg2sec{1,ii}];
end
currmean=median(curr_drifts_vel_deg2sec{i}(curr_drifts_vel_deg2sec{i}~=0));
h=histogram(curr_drifts_vel_deg2sec{i}(curr_drifts_vel_deg2sec{i}~=0),0:0.2:30,'Normalization','probability','FaceColor',currcolor{i});
plot([currmean currmean],[0 0.2],'--','Color',currcolor{i})
axis([0 15 0 0.2])
end


% [s,t]=ttest2(curr_drifts_amp_degrees{1}(curr_drifts_amp_degrees{1}~=0),curr_drifts_amp_degrees{2}(curr_drifts_amp_degrees{2}~=0));
% if s==1
%     figure(3)
%     subplot(2,1,1)
%     plot(5,0.2,'*g')
% end
% [s,t]=ttest2(curr_drifts_amp_degrees{3}(curr_drifts_amp_degrees{3}~=0),curr_drifts_amp_degrees{4}(curr_drifts_amp_degrees{4}~=0));
% if s==1
%     figure(3)
%     subplot(2,1,2)
%     plot(5,0.2,'*g')
% end
% [s,t]=ttest2(curr_drifts_vel_deg2sec{1}(curr_drifts_vel_deg2sec{1}~=0),curr_drifts_vel_deg2sec{2}(curr_drifts_vel_deg2sec{2}~=0));
% if s==1
%     figure(4)
%     subplot(2,1,1)
%     plot(5,0.2,'*g')
% end
% [s,t]=ttest2(curr_drifts_vel_deg2sec{3}(curr_drifts_vel_deg2sec{3}~=0),curr_drifts_vel_deg2sec{4}(curr_drifts_vel_deg2sec{4}~=0));
% if s==1
%     figure(4)
%     subplot(2,1,2)
%     plot(5,0.2,'*g')
% end


% set(gca, 'XTick', 1:4, 'XTickLabel', methods,'Fontsize',12);