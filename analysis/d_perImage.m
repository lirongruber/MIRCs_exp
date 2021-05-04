% clear
close all

currcolor={'m','b','c','k'};
% currcolor={[120 178 171]./255,[80 156 135]./255,[71 131 108]./255,[45 116 82]./255};
% currcolor={[181,8,4]./255,[234,166,18]./255,[133,134,15]./255,[131,188,195]./255};

methods={'subMirc' 'Mirc'};
% methods={'No' ,'Yes','both' };

orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane','house','mouth','nose'};
mircsIm=dir([ SavingPath '\ImagesForExp\MIRCs']);
subIm=dir([ SavingPath '\ImagesForExp\subMIRCs']);

% sub mircs
for i=1:length(orderPicsNames)
    sub_paths{1,i}=[SavingPath '\data\processedData\' orderPicsNames{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat'];
end
for i=1:length(orderPicsNames)
    mirc_paths{1,i}=[SavingPath '\data\processedData\' orderPicsNames{1,i} '_OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat'];
end

for image=1:10
    sub=load(sub_paths{1,image});
    mirc=load(mirc_paths{1,image});
    %recognition
%     figure(image)
%     subplot(2,2,1)
%     bar(1:2,[mean(sub.didRecog) mean(mirc.didRecog)],'FaceColor',[220 220 220]./255,'EdgeColor',[0 .0 0]);
%     hold on
%     errorbar(1,mean(sub.didRecog) ,ste(sub.didRecog),'.','Color',currcolor{1},'LineWidth',2);
%     errorbar(2,mean(mirc.didRecog),ste(mirc.didRecog),'.','Color',currcolor{2},'LineWidth',2);
%     set(gca, 'XTick', 1:2, 'XTickLabel', methods,'Fontsize',12);title('Recognition Rates','Fontsize',20)
%     title(orderPicsNames{1,image})
%     axis([0 3 0 1])
    
    figure(20)
%     subplot(2,2,1)
    bar(image*2-1,mean(sub.didRecog),'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.3);
    hold on
    errorbar(image*2-1,mean(sub.didRecog),ste(sub.didRecog),'.','Color',currcolor{1},'LineWidth',2);
    bar(image*2,mean(mirc.didRecog),'FaceColor',[0 0 0]./255,'EdgeColor',[0 0 0],'FaceAlpha',.3);
    errorbar(image*2,mean(mirc.didRecog),ste(mirc.didRecog),'.','Color',currcolor{2},'LineWidth',2);
    set(gca, 'XTick', 1:2:21, 'XTickLabel', orderPicsNames,'Fontsize',20);
    xtickangle(45)
    title('Recognition per image','Fontsize',40)
    ylabel('Rate','Fontsize',40)
    axis([0 21 0 1.2])
    text(image*2-1,1.15,num2str(mean(mirc.didRecog)-mean(sub.didRecog)),'Fontsize',40)
    if (mean(mirc.didRecog)-mean(sub.didRecog))<0.4
        text(image*2-1,1.15,num2str(mean(mirc.didRecog)-mean(sub.didRecog)),'Fontsize',40,'Color','r')
    end
    box off
%     %numOfSacc
%     figure(image)
%     subplot(2,2,2)
%     bar(1:2,[mean(sub.num_of_sacc_per_sec) mean(mirc.num_of_sacc_per_sec)],'FaceColor',[220 220 220]./255,'EdgeColor',[0 0 0]);
%     hold on
%     errorbar(1,mean(sub.num_of_sacc_per_sec) ,ste(sub.num_of_sacc_per_sec) ,'.','Color',currcolor{1},'LineWidth',2);
%     errorbar(2, mean(mirc.num_of_sacc_per_sec),ste(mirc.num_of_sacc_per_sec),'.','Color',currcolor{2},'LineWidth',2);
%     set(gca, 'XTick', 1:2, 'XTickLabel', methods,'Fontsize',20);
%     title('Number of Saccades (per second)','Fontsize',20)
%     
%     figure(20)
%     subplot(2,2,2)
%     bar(image*2-1,mean(sub.num_of_sacc_per_sec),'FaceColor',[0 220 220]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
%     hold on
%     errorbar(image*2-1,mean(sub.num_of_sacc_per_sec),ste(sub.num_of_sacc_per_sec),'.','Color',currcolor{1},'LineWidth',2);
%     bar(image*2,mean(mirc.num_of_sacc_per_sec),'FaceColor',[0 220 220]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
%     errorbar(image*2,mean(mirc.num_of_sacc_per_sec),ste(mirc.num_of_sacc_per_sec),'.','Color',currcolor{2},'LineWidth',2);
%     set(gca, 'XTick', 1:2:25, 'XTickLabel', orderPicsNames,'Fontsize',20);
%         xtickangle(45)
%         ylabel('Sacc rate [#/sec]','Fontsize',20)
%     title('Number of Saccades per Sec','Fontsize',20)
%     axis([0 27 0 4])
%     
%     %driftAmp
%     figure(image)
%     subplot(2,2,3)
%     sub_drifts_amp_degrees{image}=[];
%     mirc_drifts_amp_degrees{image}=[];
%     for ii=1:length(sub.drifts_amp_degrees)
%         sub_drifts_amp_degrees{image}=[sub_drifts_amp_degrees{image} sub.drifts_amp_degrees{1,ii}];
%     end
%     for ii=1:length(mirc.drifts_amp_degrees)
%         mirc_drifts_amp_degrees{image}=[mirc_drifts_amp_degrees{image} mirc.drifts_amp_degrees{1,ii}];
%     end
%     sub_mean=median(sub_drifts_amp_degrees{image}(sub_drifts_amp_degrees{image}~=0));
%     sub_ste=ste(sub_drifts_amp_degrees{image}(sub_drifts_amp_degrees{image}~=0));
%     mirc_mean=median(mirc_drifts_amp_degrees{image}(mirc_drifts_amp_degrees{image}~=0));
%     mirc_ste=ste(mirc_drifts_amp_degrees{image}(mirc_drifts_amp_degrees{image}~=0));
%     h1=histogram(sub_drifts_amp_degrees{image}(sub_drifts_amp_degrees{image}~=0),0:0.4:30,'Normalization','probability','FaceColor',currcolor{1});
%     n_h1=length(sub_drifts_amp_degrees{image}(sub_drifts_amp_degrees{image}~=0));
%     hold on
%     h2=histogram(mirc_drifts_amp_degrees{image}(mirc_drifts_amp_degrees{image}~=0),0:0.4:30,'Normalization','probability','FaceColor',currcolor{2});
%     n_h2=length(mirc_drifts_amp_degrees{image}(mirc_drifts_amp_degrees{image}~=0));
%     plot([sub_mean sub_mean],[0 0.4],'--','Color',currcolor{1})
%     %     text(1,0.35,['n=' num2str(n_h1)],'Color',currcolor{1},'Fontsize',20)
%     plot([mirc_mean mirc_mean],[0 0.4],'--','Color',currcolor{2})
%     %     text(1,0.38,['n=' num2str(n_h2)],'Color',currcolor{2},'Fontsize',20)
%     title('Drift Amplitude','Fontsize',20)
%     axis([0 15 0 0.4])
%     
%     figure(20)
%     subplot(2,2,3)
%     bar(image*2-1,sub_mean,'FaceColor',[0 220 220]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
%     hold on
%     errorbar(image*2-1,sub_mean,sub_ste,'.','Color',currcolor{1},'LineWidth',2);
%     bar(image*2,mirc_mean,'FaceColor',[0 220 220]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
%     errorbar(image*2,mirc_mean,mirc_ste,'.','Color',currcolor{2},'LineWidth',2);
%     set(gca, 'XTick', 1:2:25, 'XTickLabel', orderPicsNames,'Fontsize',20);
%     xtickangle(45)
%         ylabel('Amplitude [deg]','Fontsize',20)
%     title('Drift amplitude','Fontsize',20)
%     axis([0 27 0 3])
%     
%     
%     %driftVel
%     figure(image)
%     subplot(2,2,4)
%     sub_drifts_vel_deg2sec{image}=[];
%     mirc_drifts_vel_deg2sec{image}=[];
%     for ii=1:length(sub.drifts_vel_deg2sec)
%         sub_drifts_vel_deg2sec{image}=[sub_drifts_vel_deg2sec{image} sub.drifts_vel_deg2sec{1,ii}];
%     end
%     for ii=1:length(mirc.drifts_vel_deg2sec)
%         mirc_drifts_vel_deg2sec{image}=[mirc_drifts_vel_deg2sec{image} mirc.drifts_vel_deg2sec{1,ii}];
%     end
%     sub_mean=median(sub_drifts_vel_deg2sec{image}(sub_drifts_vel_deg2sec{image}~=0));
%     sub_ste=ste(sub_drifts_vel_deg2sec{image}(sub_drifts_vel_deg2sec{image}~=0));
%     mirc_mean=median(mirc_drifts_vel_deg2sec{image}(mirc_drifts_vel_deg2sec{image}~=0));
%     mirc_ste=ste(mirc_drifts_vel_deg2sec{image}(mirc_drifts_vel_deg2sec{image}~=0));
%     h1=histogram(sub_drifts_vel_deg2sec{image}(sub_drifts_vel_deg2sec{image}~=0),0:0.4:30,'Normalization','probability','FaceColor',currcolor{1});
%     n_h1=length(sub_drifts_vel_deg2sec{image}(sub_drifts_vel_deg2sec{image}~=0));
%     hold on
%     h2=histogram(mirc_drifts_vel_deg2sec{image}(mirc_drifts_vel_deg2sec{image}~=0),0:0.4:30,'Normalization','probability','FaceColor',currcolor{2});
%     n_h2=length(mirc_drifts_vel_deg2sec{image}(mirc_drifts_vel_deg2sec{image}~=0));
%     plot([sub_mean sub_mean],[0 0.4],'--','Color',currcolor{1})
%     text(1,0.35,['n=' num2str(n_h1)],'Color',currcolor{1},'Fontsize',20)
%     plot([mirc_mean mirc_mean],[0 0.4],'--','Color',currcolor{2})
%     text(1,0.38,['n=' num2str(n_h2)],'Color',currcolor{2},'Fontsize',20)
%     title('Drift Speed','Fontsize',20)
%     axis([0 15 0 0.4])
%     
%     figure(20)
%     subplot(2,2,4)
%     bar(image*2-1,sub_mean,'FaceColor',[0 220 220]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
%     hold on
%     errorbar(image*2-1,sub_mean,sub_ste,'.','Color',currcolor{1},'LineWidth',2);
%     bar(image*2,mirc_mean,'FaceColor',[0 220 220]./255,'EdgeColor',[0 0 0],'FaceAlpha',.5);
%     errorbar(image*2,mirc_mean,mirc_ste,'.','Color',currcolor{2},'LineWidth',2);
%     set(gca, 'XTick', 1:2:25, 'XTickLabel', orderPicsNames,'Fontsize',20);
%     xtickangle(45)
%         ylabel('Speed [deg/sec]','Fontsize',20)
%     title('Drift speed','Fontsize',20)
%     axis([0 27 0 6])
%     
%     
   
end
for pic=1:10
    for image=1:13
        curr_m=mircsIm(image+2).name;
        curr_s=subIm(image+2).name;
        if strcmp(orderPicsNames{1,pic}(1:min(4,size(orderPicsNames{1,pic},2))),curr_m(1:min(4,size(orderPicsNames{1,pic},2))))
            %             subplot(2,2,1)
            axes('pos',[(pic-1)*0.075+.16 .8 .06 .06])
            imshow(['C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\MIRCs\' curr_m])
            axes('pos',[(pic-1)*0.075+.12 .8 .06 .06])
            imshow(['C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\subMIRCs\' curr_s])
            %             set(gcf, 'Position', get(0, 'Screensize'));
            %             saveppt('perImage.ppt')
       break
        end
    end
end
tilefigs
