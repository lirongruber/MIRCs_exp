% CONVERGENCE WITHIN TRIAL
clear
close all
% 'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat'
% 'OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat';
% 'OnlyFirst1_Sub1Mirc1Full0Ref0_rec No.mat';
% 'OnlyFirst1_Sub0Mirc1Full0Ref0_rec No.mat';
% 'OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat';
% 'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth_MIRC_GROUP.mat';
% 'OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth.mat'
% 'OnlyFirst1_Sub1Mirc1Full0Ref0_rec Yes.mat';
% 'OnlyFirst1_Sub1Mirc0Full0Ref0_rec Yes.mat';
% 'OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat';
% 'OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat';
% 'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth_SUBMIRC_GROUP.mat';

path='C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\';
paths={
    [path ...
    'OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat']
    [path ...
    'OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat']
    %     [path ...
    %     'OnlyFirst0_Sub0Mirc0Full1Ref1_recBoth.mat']
    %     [path ...
    %     'OnlyFirst0_Sub1Mirc1Full0Ref0_rec No_subMIRCGROUP.mat']
    %     [path ...
    %     'OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes_subMIRCGROUP.mat']
    %     [path ...
    %     'OnlyFirst0_Sub1Mirc1Full0Ref0_rec No_MIRCGROUP.mat']
    %     [path ...
    %     'OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes_MIRCGROUP.mat']
    %     [path ...
    %     'OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_subMIRCGROUP']
    %     [path ...
    %     'OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_MIRCGROUP']
    %     [path ...
    %     'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth_subMIRCGROUP']
    %     [path ...
    %     'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth_MIRCGROUP']
    };
paths=paths';
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};


for var=1:8
    for group=1:length(paths)
        load(paths{group});
        meansPerRank{1,group}=zeros(1,26);
        switch var
            case 2
                for i=1:length(drifts_vel_deg2sec)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0) zeros(1,26-length(drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0)))]];
                end
                rel_title='Drift Speed';
                rel_y='speed [deg/sec]';
                rel_min=2.5;
                rel_max=5;
            case 3
                for i=1:length(drifts_amp_degrees)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_amp_degrees{1,i}(drifts_amp_degrees{1,i}~=0) zeros(1,26-length(drifts_amp_degrees{1,i}(drifts_amp_degrees{1,i}~=0)))]];
                end
                rel_title='Drift Amplitudes';
                rel_y='amplitude[deg]';
                rel_min=0.5;
                rel_max=2.5;
            case 5
                for i=1:length(saccs_amp_degrees)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [saccs_amp_degrees{1,i}(saccs_amp_degrees{1,i}~=0) zeros(1,26-length(saccs_amp_degrees{1,i}(saccs_amp_degrees{1,i}~=0)))]];
                end
                rel_title='Saccades Amplitudes';
                rel_y='amplitude[deg]';
                rel_min=0;
                rel_max=2;
            case 4
                for i=1:length(drifts_curve_CI)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_curve_CI{1,i}(drifts_curve_CI{1,i}~=0) zeros(1,26-length(drifts_curve_CI{1,i}(drifts_curve_CI{1,i}~=0)))]];
                end
                rel_title='Drift Curvature';
                rel_y='CI [AU]';
                rel_min=0.5;
                rel_max=0.8;
                case 6
                for i=1:length(saccs_time_ms)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [saccs_time_ms{1,i}(saccs_time_ms{1,i}~=0) zeros(1,26-length(saccs_time_ms{1,i}(saccs_time_ms{1,i}~=0)))]];
                end
                rel_title='Saccades Duration';
                rel_y='duration[ms]';
                rel_min=1;
                rel_max=2.5;
                case 7
                for i=1:length(saccs_vel_deg2sec)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [saccs_vel_deg2sec{1,i}(saccs_vel_deg2sec{1,i}~=0) zeros(1,26-length(saccs_vel_deg2sec{1,i}(saccs_vel_deg2sec{1,i}~=0)))]];
                end
                rel_title='Saccades Speed';
                rel_y='speed[deg/sec]';
                rel_min=300;
                rel_max=800;
                case 8
                for i=1:length(saccs_maxvel_deg2sec)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [saccs_maxvel_deg2sec{1,i}(saccs_maxvel_deg2sec{1,i}~=0) zeros(1,26-length(saccs_maxvel_deg2sec{1,i}(saccs_maxvel_deg2sec{1,i}~=0)))]];
                end
                rel_title='Saccades maxSpeed';
                rel_y='speed[deg/sec]';
                rel_min=20;
                rel_max=100;
            case 1
                for i=1:length(drifts_time_ms)
                    meansPerRank{1,group}=[meansPerRank{1,group} ; [drifts_time_ms{1,i}(drifts_time_ms{1,i}~=0) zeros(1,26-length(drifts_time_ms{1,i}(drifts_time_ms{1,i}~=0)))]];
                end
                rel_title='ISI';
                rel_y='Drift duration [ms]';
                rel_min=100;
                rel_max=600;
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
        if group>3 %group==2 || group==4 || group==6 %
            subplot(2,4,var+4)
        else
            subplot(2,4,var)
        end
        hold all
        h{group}=errorbar(relmeans,relstes,'Color',currcolor{group},'lineWidth',2);
        
        plot(ones(1,2).*avNumofD-steNumofD,[(rel_max-rel_min)*0.7+rel_min (rel_max-rel_min)*0.73+rel_min],'Color',currcolor{group},'lineWidth',2)
        plot(ones(1,2).*avNumofD+steNumofD,[(rel_max-rel_min)*0.7+rel_min (rel_max-rel_min)*0.73+rel_min],'Color',currcolor{group},'lineWidth',2)
        plot([avNumofD-steNumofD avNumofD+steNumofD],[0.713*(rel_max-rel_min)+rel_min 0.713*(rel_max-rel_min)+rel_min],'Color',currcolor{group})
        axis([0 9 rel_min rel_max])
        text(0.1,(rel_max-rel_min)*0.75+rel_min,'Trial end (mean+STE):','Fontsize',14)
        title(rel_title,'Fontsize',20)
        xlabel('fixation #','Fontsize',18)
        ylabel(rel_y,'Fontsize',20)
        
        %save for phase-plane
        vars{var,group}=relmeans;
        %
    end
    for r=1:8
        currCol1=meansPerRank{1,1}(:,r);
        currCol1=currCol1(currCol1~=0);
        currCol2=meansPerRank{1,2}(:,r);
        currCol2=currCol2(currCol2~=0);
        [s(r),t(r)]=ttest2(currCol1,currCol2);
        if s(r)==1
            subplot(2,4,var)
%             plot(r,(rel_max-rel_min)*0.6+rel_min,'*k')
        end
    end
    [hh,pp] = kstest2(meansPerRank{2,1},meansPerRank{2,2});
    if hh==1
        subplot(2,4,var)
        text(4,(rel_max-rel_min)*0.2+rel_min,'* KS','Fontsize',22)
    end
end

% %% draw phase-planes
% figure(22)
% subplot(2,3,1)
% hold on
% plot(vars{1,1},vars{2,1},'Color',currcolor{1})
% plot(vars{1,1}(1),vars{2,1}(1),'*k','MarkerSize',8)
% plot(vars{1,2},vars{2,2},'Color',currcolor{2})
% plot(vars{1,2}(1),vars{2,2}(1),'*k','MarkerSize',8)
% xlabel('duration')
% ylabel('velocity')
% 
% subplot(2,3,4)
% hold on
% plot(-6:6,xcorr(vars{1,1},vars{2,1}))
% xlabel('lag')
% ylabel('xcorr')
% 
% subplot(2,3,2)
% hold on
% plot(vars{1,1},vars{3,1},'Color',currcolor{1})
% plot(vars{1,1}(1),vars{3,1}(1),'*k','MarkerSize',8)
% plot(vars{1,2},vars{3,2},'Color',currcolor{2})
% plot(vars{1,2}(1),vars{3,2}(1),'*k','MarkerSize',8)
% xlabel('duration')
% ylabel('amplitude')
% 
% subplot(2,3,5)
% hold on
% plot(-6:6,xcorr(vars{1,1},vars{3,1}))
% xlabel('lag')
% ylabel('xcorr')
% 
% subplot(2,3,3)
% hold on
% plot(vars{2,1},vars{3,1},'Color',currcolor{1})
% plot(vars{2,1}(1),vars{3,1}(1),'*k','MarkerSize',8)
% plot(vars{2,2},vars{3,2},'Color',currcolor{2})
% plot(vars{2,2}(1),vars{3,2}(1),'*k','MarkerSize',8)
% xlabel('velocity')
% ylabel('amplitude')
% 
% subplot(2,3,6)
% hold on
% plot(-6:6,xcorr(vars{2,1},vars{3,1}))
% xlabel('lag')
% ylabel('xcorr')
% 
% 
% % tilefigs;
