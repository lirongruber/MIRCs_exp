
clear
close all

paths={'C:\Users\bnapp\Documents\phd-pre-proposal\analysis\processedData\exp0_100_exp12_000_exp123_000_exp122_000RecogBoth.mat',...
    'C:\Users\bnapp\Documents\phd-pre-proposal\analysis\processedData\exp0_000_exp12_100_exp123_000_exp122_000RecogBoth.mat',...
    'C:\Users\bnapp\Documents\phd-pre-proposal\analysis\processedData\exp0_000_exp12_000_exp123_100_exp122_000RecogBoth.mat',...
    'C:\Users\bnapp\Documents\phd-pre-proposal\analysis\processedData\exp0_000_exp12_000_exp123_000_exp122_100RecogBoth.mat',...
    };
methods={'fullImage' 'Mirc' 'subMirc' 'stabMirc'};
methods2={'fullImage' 'mean' 'Mirc' 'mean' 'subMirc' 'mean' 'stabMirc' 'mean'};
currcolor={'b','m','c','y'};
numOfSubjects=0;
for group=1:length(paths)
load(paths{group});
%recogNars
numOfSubjects=numOfSubjects+ceil((length(didRecog))/10);
figure(1)
hold on
bar(group,mean(didRecog));
errorbar(group,mean(didRecog),ste(didRecog),'.','Color',currcolor{group});
if group==length(paths)
set(gca, 'XTick', 1:4, 'XTickLabel', methods,'Fontsize',12);
ylabel('Percent of trials','Fontsize',18)
title(['Recognition Percentages (total subject=' num2str(numOfSubjects) ')'],'Fontsize',20)
end
%%numOfSacc
figure(2)
hold on
bar(group,mean(num_of_sacc_per_sec));
errorbar(group,mean(num_of_sacc_per_sec),ste(num_of_sacc_per_sec),'.','Color',currcolor{group});
if group==length(paths)
set(gca, 'XTick', 1:4, 'XTickLabel', methods,'Fontsize',12);
ylabel('saccdes per second [#/sec]','Fontsize',18)
title(['Number of sacc per second (total subject=' num2str(numOfSubjects) ')'],'Fontsize',20)
end
%%driftVel
figure(3)
hold on
curr_drifts_vel_deg2sec{group}=[];
for i=1:length(drifts_vel_deg2sec)
    curr_drifts_vel_deg2sec{group}=[curr_drifts_vel_deg2sec{group} drifts_vel_deg2sec{1,i}];
end
currmean=mean(curr_drifts_vel_deg2sec{group}(curr_drifts_vel_deg2sec{group}~=0));
h=histogram(curr_drifts_vel_deg2sec{group},0:0.25:30,'Normalization','probability','FaceColor',currcolor{group});
plot(currmean,0.2,'*','Color',currcolor{group})
if group==length(paths)
xlabel('velocity [deg/sec]','Fontsize',18);
ylabel('Percent of trials','Fontsize',18)
title(['Drift Velocity (total subject=' num2str(numOfSubjects) ')'],'Fontsize',20)
axis([1 14 0 0.3])
[s12,t12]=ttest2(curr_drifts_vel_deg2sec{1}(curr_drifts_vel_deg2sec{1}~=0),curr_drifts_vel_deg2sec{2}(curr_drifts_vel_deg2sec{2}~=0));
[s23,t23]=ttest2(curr_drifts_vel_deg2sec{2}(curr_drifts_vel_deg2sec{2}~=0),curr_drifts_vel_deg2sec{3}(curr_drifts_vel_deg2sec{3}~=0));
[s13,t13]=ttest2(curr_drifts_vel_deg2sec{1}(curr_drifts_vel_deg2sec{1}~=0),curr_drifts_vel_deg2sec{3}(curr_drifts_vel_deg2sec{3}~=0));
end
legend(methods2,'Fontsize',15)
%driftAmp
figure(4)
hold on
curr_drifts_amp_degrees{group}=[];
for i=1:length(drifts_amp_degrees)
    curr_drifts_amp_degrees{group}=[curr_drifts_amp_degrees{group} drifts_amp_degrees{1,i}];
end
currmean=mean(curr_drifts_amp_degrees{group}(curr_drifts_amp_degrees{group}~=0));
h=histogram(curr_drifts_amp_degrees{group},0:0.25:30,'Normalization','probability','FaceColor',currcolor{group});
plot(currmean,0.2,'*','Color',currcolor{group})
if group==length(paths)
xlabel('amplitude [deg/sec]','Fontsize',18);
ylabel('Percent of trials','Fontsize',18)
title(['Drift Amplitude (total subject=' num2str(numOfSubjects) ')'],'Fontsize',20)
axis([1 14 0 0.3])
% [s12,t12]=ttest2(curr_drifts_amp_degrees{1},curr_drifts_amp_degrees{2});
% [s23,t23]=ttest2(curr_drifts_amp_degrees{2},curr_drifts_amp_degrees{3});
% [s13,t13]=ttest2(curr_drifts_amp_degrees{1},curr_drifts_amp_degrees{3});
end
legend(methods2,'Fontsize',15)
%driftTime
figure(5)
hold on
curr_drifts_time_ms{group}=[];
for i=1:length(drifts_time_ms)
    curr_drifts_time_ms{group}=[curr_drifts_time_ms{group} drifts_time_ms{1,i}];
end
currmean=mean(curr_drifts_time_ms{group}(curr_drifts_time_ms{group}~=0));
h=histogram(curr_drifts_time_ms{group},0:100:3000,'Normalization','probability','FaceColor',currcolor{group});
plot(currmean,0.2,'*','Color',currcolor{group})
if group==length(paths)
xlabel('time [msec]','Fontsize',18);
ylabel('Percent of trials','Fontsize',18)
title(['Drift Time (total subject=' num2str(numOfSubjects) ')'],'Fontsize',20)
% axis([1 14 0 0.3])
% [s12,t12]=ttest2(curr_drifts_time_ms{1},curr_drifts_time_ms{2});
% [s23,t23]=ttest2(curr_drifts_time_ms{2},curr_drifts_time_ms{3});
% [s13,t13]=ttest2(curr_drifts_time_ms{1},curr_drifts_time_ms{3});
end
legend(methods2,'Fontsize',15)
%driftType
figure(6)
hold on
curr_drifts_Type{group}=[];
for i=1:length(labeled_saccade_vecs)
    curr_drifts_Type{group}=[curr_drifts_Type{group} labeled_saccade_vecs{1,i}(4,:)];
end
currTotal=length(find(curr_drifts_Type{group}));
strait(group)=sum(find(curr_drifts_Type{group}==1))/currTotal;
circular(group)=sum(find(curr_drifts_Type{group}==2))/currTotal;
other(group)=sum(find(curr_drifts_Type{group}==3))/currTotal;
if group==length(paths)
bar( [strait' circular' other'])
set(gca,'xtick',[]);
xlabel(' full images Mircs subMircs stabMircs','Fontsize',18);
shapesOfDrift={'circle' 'strait' 'other'};
legend(shapesOfDrift,'Fontsize',15)
title(['Drift Type (total subject=' num2str(numOfSubjects) ')'],'Fontsize',20)
end
end
% tilefigs;