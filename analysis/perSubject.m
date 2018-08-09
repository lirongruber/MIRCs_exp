%per Subject

clear
% close all

currcolor={'b','m','c','k'};
% currcolor={[120 178 171]./255,[80 156 135]./255,[71 131 108]./255,[45 116 82]./255};
% currcolor={[181,8,4]./255,[234,166,18]./255,[133,134,15]./255,[131,188,195]./255};


subjects={'AK','FS','EM','GG','GH','GS','HL','IN','LS','NA','NG','RB','SE','SG','SS','TT','UK','YB','YM','YS'};
for t=1:2
    
    for i=1:length(subjects)
        if t==1
            load(['C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth.mat']);
        else
            load(['C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,i} '_OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat']);
        end
        figure(1)
        subplot(2,2,t)
        bar(i,mean(num_of_sacc_per_sec),'FaceColor',[0 220 220]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
        hold on
        errorbar(i,mean(num_of_sacc_per_sec),ste(num_of_sacc_per_sec),'.','Color',currcolor{1},'LineWidth',2);
        set(gca, 'XTick', 1:20, 'XTickLabel', subjects,'Fontsize',12);
        if t==1
            title('Referenced images : Number of Saccades (per second)','Fontsize',20)
        else
            title('Full images : Number of Saccades (per second)','Fontsize',20)
        end
        axis([0 21 0 7.5])
        %
        subplot(2,2,t+2)
        curr_drifts_vel_deg2sec=[];
        for ii=1:length(drifts_vel_deg2sec)
            curr_drifts_vel_deg2sec=[curr_drifts_vel_deg2sec drifts_vel_deg2sec{1,ii}];
        end
        currmean=median(curr_drifts_vel_deg2sec(curr_drifts_vel_deg2sec~=0));
        bar(i,mean(curr_drifts_vel_deg2sec),'FaceColor',[0 220 220]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
        hold on
        errorbar(i,mean(curr_drifts_vel_deg2sec),ste(curr_drifts_vel_deg2sec),'.','Color',currcolor{1},'LineWidth',2);
        set(gca, 'XTick', 1:20, 'XTickLabel', subjects,'Fontsize',12);
        title('Drift Speed' ,'Fontsize',20)
        axis([0 21 0 7.5])
        
        %     h=histogram(curr_drifts_vel_deg2sec{i}(curr_drifts_vel_deg2sec{i}~=0),0:0.2:30,'Normalization','probability','FaceColor',currcolor{1});
        %     hold all
        %     plot([currmean currmean],[0 0.2],'--')
        %     title('Drift Speed','Fontsize',20)
        %     axis([0 15 0 0.2])
    end
end
