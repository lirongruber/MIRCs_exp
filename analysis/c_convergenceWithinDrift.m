% CONVERGENCE WITHIN TRIAL
clear
close all

paths={...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat',...
    };
% paths={...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\NG_OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\YS_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat',...
%     };
% paths={...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc1Full0Ref0_rec Yes.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc1Full0Ref0_rec No.mat',...
%     };

methods={'fullImage' 'Mirc' 'subMirc' 'stabMirc'};
methods2={'fullImage' 'mean' 'Mirc' 'mean' 'subMirc' 'mean' 'stabMirc' 'mean'};
currcolor={'b','c'};

windowAvSize_forMean=3;%1
windowAvSize_forStd=3;%3

for group=1:length(paths)
    MeanVel=[];
    MeanVar=[];
    MeanCC=[];
    Amp=[];
    freqAmp=[];
    load(paths{group});
    relD=0;
    for t =1:size(labeled_saccade_vecs,2)
        currSaccVec=labeled_saccade_vecs{1,t};
        XY_vec_deg=XY_vecs_deg{1,t};
        for i=0:size(currSaccVec,2)
            temp=[];
            if isempty(find(currSaccVec,1))
                temp=XY_vec_deg';
            else
                if i==0
                    temp=(XY_vec_deg(:,(1:currSaccVec(1,1)))');
                else if i<size(currSaccVec,2)
                        temp=(XY_vec_deg(:,((currSaccVec(1,i)+currSaccVec(2,i)):currSaccVec(1,i+1)))');
                    else
                        temp=(XY_vec_deg(:,((currSaccVec(1,i)+currSaccVec(2,i)):end))');
                    end
                end
            end
            
            
            
            if length(temp)>25 && size(currSaccVec,2)>2 && sum(sum(isnan(temp)))==0
                currAmp=[];
                local_curvature=[];
                for j=2:length(temp)
                    currAmp(j-1) = sqrt((temp(j,1)-temp(j-1,1))^2+(temp(j,2)-temp(j-1,2))^2);
                end
%                 
                if max(currAmp)<0.12
                    relD=relD+1;
                    %for any given drift
                    M=movmean(currAmp./4*1000,windowAvSize_forMean);
                    V=movvar(currAmp./4*1000,windowAvSize_forStd);
                    
                    MeanVel(relD,1:length(M))=M;
                    MeanVar(relD,1:length(M))=V;

                end
            end
            MeanVel(MeanVel==0)=nan;
            MeanVar(MeanVar==0)=nan;
            
        end
    end
    figure(1)
    errorbar((1:size(MeanVel,2)).*4,nanmean(MeanVel),nanstd(MeanVel)./sqrt(size(MeanVel,1)-sum(isnan(MeanVel))),'color',currcolor{1,group},'LineWidth',3)
    hold on
    plot((1:size(MeanVel,2)).*4,nanmean(MeanVel),'k')
    legend('MIRCS','','subMIRCs','')
    axis([0 400 2 7.5])
    xlabel('Time within fixation pause [ms]','FontSize', 20)
    ylabel('speed [deg/sec]','FontSize', 20)
    title('Inst Speed')
    
end
tilefigs