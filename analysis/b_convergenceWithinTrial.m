% CONVERGENCE WITHIN TRIAL
clear
% close all
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
    [path ...
    'OnlyFirst0_Sub0Mirc0Full1Ref1_recBoth.mat']
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
% currcolor={[181,8,4]./255,[133,134,15]./255,[181,8,4]./255,[133,134,15]./255};
% currcolor={[181,8,4]./255,'k',[181,8,4]./255,'k'};
currcolor={[133,134,15]./255,[234,166,18]./255,[181,8,4]./255,[131,188,195]./255};
currcolor={'b','m','k','c','m','k'};

for group=1:length(paths)
    load(paths{group});
    for var=1:4
        meansPerRank{group}=zeros(1,25);
        switch var
            case 2
                for i=1:length(drifts_vel_deg2sec)
                    meansPerRank{group}=[meansPerRank{group} ; [drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0) zeros(1,25-length(drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0)))]];
                end
                rel_title='Drift Speed';
                rel_y='speed [deg/sec]';
                rel_min=2.5;
                rel_max=5;
            case 3
                for i=1:length(drifts_amp_degrees)
                    meansPerRank{group}=[meansPerRank{group} ; [drifts_amp_degrees{1,i}(drifts_amp_degrees{1,i}~=0) zeros(1,25-length(drifts_amp_degrees{1,i}(drifts_amp_degrees{1,i}~=0)))]];
                end
                rel_title='Drift Amplitudes';
                rel_y='amplitude[deg]';
                rel_min=0.5;
                rel_max=2.5;
            case 4
                for i=1:length(saccs_amp_degrees)
                    meansPerRank{group}=[meansPerRank{group} ; [saccs_amp_degrees{1,i}(saccs_amp_degrees{1,i}~=0) zeros(1,25-length(saccs_amp_degrees{1,i}(saccs_amp_degrees{1,i}~=0)))]];
                end
                rel_title='Saccades Amplitudes';
                rel_y='amplitude[deg]';
                rel_min=0;
                rel_max=2;
%             case 4
%                 for i=1:length(saccs_vel_deg2sec)
%                     meansPerRank{group}=[meansPerRank{group} ; [saccs_vel_deg2sec{1,i}(saccs_vel_deg2sec{1,i}~=0) zeros(1,25-length(saccs_vel_deg2sec{1,i}(saccs_vel_deg2sec{1,i}~=0)))]];
%                 end
%                 rel_title='Saccades Speed';
%                 rel_y='mean speed [deg/sec]';
%                 rel_min=20;
%                 rel_max=60;
            case 1
                for i=1:length(drifts_time_ms)
                    meansPerRank{group}=[meansPerRank{group} ; [drifts_time_ms{1,i}(drifts_time_ms{1,i}~=0) zeros(1,25-length(drifts_time_ms{1,i}(drifts_time_ms{1,i}~=0)))]];
                end
                rel_title='ISI';
                rel_y='Drift duration [ms]';
                rel_min=100;
                rel_max=600;
        end
        for d=1:size(meansPerRank{group},1)
            currd=meansPerRank{group}(d,:);
            numberOfDrift(d)=length(currd(currd~=0));
        end
        avNumofD=mean(numberOfDrift);
        steNumofD=ste(numberOfDrift);
        relmeans=[];
        relstes=[];
        num_rel_trial=[];
        for r=1:20
            currCol=meansPerRank{group}(:,r);
            num_rel_trial(r)=length(currCol(currCol~=0));
            if num_rel_trial(r)> 0.2*length(currCol)
                relmeans(r)=mean(currCol(currCol~=0));
                relstes(r)=ste(currCol(currCol~=0));
            end
        end
        figure(2)
        if group>3 %group==2 || group==4 || group==6 %
            subplot(2,4,var+4)
        else
            subplot(2,4,var)
        end
        hold all
        h{group}=errorbar(relmeans,relstes,'Color',currcolor{group});
%         for i=1:length(relmeans)
%             text(i,((rel_max-rel_min)*0.05+rel_min+(rel_max-rel_min)*0.05*group),num2str(num_rel_trial(i)),'Color',currcolor{group});
%         end
        plot(ones(1,2).*avNumofD-steNumofD,[(rel_max-rel_min)*0.7+rel_min (rel_max-rel_min)*0.73+rel_min],'Color',currcolor{group})
        plot(ones(1,2).*avNumofD+steNumofD,[(rel_max-rel_min)*0.7+rel_min (rel_max-rel_min)*0.73+rel_min],'Color',currcolor{group})
        plot([avNumofD-steNumofD avNumofD+steNumofD],[0.713*(rel_max-rel_min)+rel_min 0.713*(rel_max-rel_min)+rel_min],'Color',currcolor{group})
        axis([0 9 rel_min rel_max])
        text(1,(rel_max-rel_min)*0.85+rel_min,'Sacc per trial (STE):','Fontsize',12)
        title(rel_title,'Fontsize',20)
        xlabel('rank','Fontsize',18)
        ylabel(rel_y,'Fontsize',20)
    end
end
% tilefigs;
