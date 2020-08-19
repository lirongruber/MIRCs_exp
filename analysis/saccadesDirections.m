% SACCADES DIRECTIONS - CONVERGENCE WITHIN TRIAL
clear
close all

path='C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\';
paths={
    [path ...
    'OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat']
    [path ...
    'OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat']
    [path ...
    'OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth.mat']
    };

paths=paths';
currcolor={[246,75,75]./255,[74,77,255]./255,'k'};

for group=1:length(paths)
    load(paths{group});
    meansPerRank{1,group}=nan(1,26);
    for i=1:length(labeled_saccade_vecs)
        curr=labeled_saccade_vecs{1,i};
        start=XY_vecs_deg{1,i}(:,curr(1,:));
        stop=XY_vecs_deg{1,i}(:,curr(1,:)+curr(2,:));
        directions=atan( (stop(2,:)-start(2,:))./(stop(1,:)-start(1,:)) );
        for a=1:size(directions,2)
            if (stop(1,a)-start(1,a)) <0
                directions(a)=directions(a)+pi;
            end
            if  directions(a)<0
                directions(a)= directions(a)+2*pi;
            end
        end
        meansPerRank{1,group}=[meansPerRank{1,group} ; [directions nan(1,26-size(directions,2))] ];
    end
end

for group=1:length(paths)
    figure(1)
    for f=1:8
        subplot(3,8,f+(group-1)*8)
        [p]=polarhistogram(meansPerRank{1,group}(:,f),'FaceColor',currcolor{group},'BinEdges',[0:pi/8:2*pi],'Normalization','probability');
%         polarhistogram(nanmean((meansPerRank{1,group}(:,f))),'FaceColor',currcolor{group},'BinEdges',[0:pi/8:2*pi])
        [mx,ix]=max(p.Values);
        polarhistogram(p.BinEdges(ix),'FaceColor',currcolor{group},'BinEdges',[0:pi/8:2*pi])

        title(['fixation' num2str(f)])
    end
end

for group=1:length(paths)
    figure(2)
    for f=1:8
        subplot(3,8,f+(group-1)*8)
        histogram(rad2deg(meansPerRank{1,group}(:,f)),'FaceColor',currcolor{group},'BinEdges',[0:20:360],'Normalization','probability')
        hold on
        plot([rad2deg(nanmean((meansPerRank{1,group}(:,f)))) rad2deg(nanmean((meansPerRank{1,group}(:,f))))], [0 0.2] )
        title(['fixation' num2str(f)])
    end
end
