clear
close all

currcolor={'b','m','c','k'};
% currcolor={[120 178 171]./255,[80 156 135]./255,[71 131 108]./255,[45 116 82]./255};
% currcolor={[181,8,4]./255,[234,166,18]./255,[133,134,15]./255,[131,188,195]./255};

methods={'subMirc' 'Mirc'};
% methods={'No' ,'Yes','both' };

orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane','house','mouth','nose'};
mircsIm=dir('C:\Users\bnapp\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\MIRCs');
subIm=dir('C:\Users\bnapp\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\subMIRCs');

% sub mircs
for i=1:length(orderPicsNames)
    sub_paths{1,i}=['C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\' orderPicsNames{1,i} '_OnlyFirst1_Sub1Mirc0Full0Ref0_recBoth.mat'];
end
for i=1:length(orderPicsNames)
    mirc_paths{1,i}=['C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\' orderPicsNames{1,i} '_OnlyFirst1_Sub0Mirc1Full0Ref0_recBoth.mat'];
end

for image=1:13
    sub=load(sub_paths{1,image});
    mirc=load(mirc_paths{1,image});
    %recognition
    figure(image)
    subplot(2,2,1)
    bar(1:2,[mean(sub.didRecog) mean(mirc.didRecog)],'FaceColor',[220 220 220]./255,'EdgeColor',[0 .0 0]);
    hold on
    errorbar(1,mean(sub.didRecog) ,ste(sub.didRecog),'.','Color',currcolor{1},'LineWidth',2);
    errorbar(2,mean(mirc.didRecog),ste(mirc.didRecog),'.','Color',currcolor{2},'LineWidth',2);
    set(gca, 'XTick', 1:2, 'XTickLabel', methods,'Fontsize',12);title('Recognition Rates','Fontsize',20)
    title(orderPicsNames{1,image})
    axis([0 3 0 1])
    
    %numOfSacc
    subplot(2,2,2)
    bar(1:2,[mean(sub.num_of_sacc_per_sec) mean(mirc.num_of_sacc_per_sec)],'FaceColor',[220 220 220]./255,'EdgeColor',[0 0 0]);
    hold on
    errorbar(1,mean(sub.num_of_sacc_per_sec) ,ste(sub.num_of_sacc_per_sec) ,'.','Color',currcolor{1},'LineWidth',2);
    errorbar(2, mean(mirc.num_of_sacc_per_sec),ste(mirc.num_of_sacc_per_sec),'.','Color',currcolor{2},'LineWidth',2);
    set(gca, 'XTick', 1:2, 'XTickLabel', methods,'Fontsize',12);
    title('Number of Saccades (per second)','Fontsize',20)
    
    %driftAmp
    subplot(2,2,3)
    sub_drifts_amp_degrees{image}=[];
    mirc_drifts_amp_degrees{image}=[];
    for ii=1:length(sub.drifts_amp_degrees)
        sub_drifts_amp_degrees{image}=[sub_drifts_amp_degrees{image} sub.drifts_amp_degrees{1,ii}];
    end
    for ii=1:length(mirc.drifts_amp_degrees)
        mirc_drifts_amp_degrees{image}=[mirc_drifts_amp_degrees{image} mirc.drifts_amp_degrees{1,ii}];
    end
    sub_mean=median(sub_drifts_amp_degrees{image}(sub_drifts_amp_degrees{image}~=0));
    mirc_mean=median(mirc_drifts_amp_degrees{image}(mirc_drifts_amp_degrees{image}~=0));
    h1=histogram(sub_drifts_amp_degrees{image}(sub_drifts_amp_degrees{image}~=0),0:0.4:30,'Normalization','probability','FaceColor',currcolor{1});
    n_h1=length(sub_drifts_amp_degrees{image}(sub_drifts_amp_degrees{image}~=0));
    hold on
    h2=histogram(mirc_drifts_amp_degrees{image}(mirc_drifts_amp_degrees{image}~=0),0:0.4:30,'Normalization','probability','FaceColor',currcolor{2});
    n_h2=length(mirc_drifts_amp_degrees{image}(mirc_drifts_amp_degrees{image}~=0));
    plot([sub_mean sub_mean],[0 0.4],'--','Color',currcolor{1})
%     text(1,0.35,['n=' num2str(n_h1)],'Color',currcolor{1},'Fontsize',20)
    plot([mirc_mean mirc_mean],[0 0.4],'--','Color',currcolor{2})
%     text(1,0.38,['n=' num2str(n_h2)],'Color',currcolor{2},'Fontsize',20)
    title('Drift Amplitude','Fontsize',20)
    axis([0 15 0 0.4])
    %driftVel
    subplot(2,2,4)
    sub_drifts_vel_deg2sec{image}=[];
    mirc_drifts_vel_deg2sec{image}=[];
    for ii=1:length(sub.drifts_vel_deg2sec)
        sub_drifts_vel_deg2sec{image}=[sub_drifts_vel_deg2sec{image} sub.drifts_vel_deg2sec{1,ii}];
    end
    for ii=1:length(mirc.drifts_vel_deg2sec)
        mirc_drifts_vel_deg2sec{image}=[mirc_drifts_vel_deg2sec{image} mirc.drifts_vel_deg2sec{1,ii}];
    end
    sub_mean=median(sub_drifts_vel_deg2sec{image}(sub_drifts_vel_deg2sec{image}~=0));
    mirc_mean=median(mirc_drifts_vel_deg2sec{image}(mirc_drifts_vel_deg2sec{image}~=0));
    h1=histogram(sub_drifts_vel_deg2sec{image}(sub_drifts_vel_deg2sec{image}~=0),0:0.4:30,'Normalization','probability','FaceColor',currcolor{1});
    n_h1=length(sub_drifts_vel_deg2sec{image}(sub_drifts_vel_deg2sec{image}~=0));
    hold on
    h2=histogram(mirc_drifts_vel_deg2sec{image}(mirc_drifts_vel_deg2sec{image}~=0),0:0.4:30,'Normalization','probability','FaceColor',currcolor{2});
    n_h2=length(mirc_drifts_vel_deg2sec{image}(mirc_drifts_vel_deg2sec{image}~=0));
    plot([sub_mean sub_mean],[0 0.4],'--','Color',currcolor{1})
    text(1,0.35,['n=' num2str(n_h1)],'Color',currcolor{1},'Fontsize',20)
    plot([mirc_mean mirc_mean],[0 0.4],'--','Color',currcolor{2})
    text(1,0.38,['n=' num2str(n_h2)],'Color',currcolor{2},'Fontsize',20)
    title('Drift Speed','Fontsize',20)
    axis([0 15 0 0.4])
    
    
    for n=3:15
        curr_m=mircsIm(n).name;
        curr_s=subIm(n).name;
        if strcmp(orderPicsNames{1,image},curr_m(1:length(orderPicsNames{1,image})))
            subplot(2,2,1)
            axes('pos',[.2 .8 .1 .1])
            imshow(['C:\Users\bnapp\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\MIRCs\' curr_m])
            axes('pos',[.12 .8 .1 .1])
            imshow(['C:\Users\bnapp\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\subMIRCs\' curr_s])
        set(gcf, 'Position', get(0, 'Screensize'));
        saveppt('perImage.ppt')
        end
    end
end
tilefigs
