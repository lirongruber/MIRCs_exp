% CONVERGENCE WITHIN TRIAL
clear
% close all

paths={...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full1Ref1_recBoth.mat',...
    };
type=1;
s=11;

methods2={'fullImage' 'mean' 'Mirc' 'mean' 'subMirc' 'mean' 'stabMirc' 'mean'};
currcolor={'b','m','k','k'};

windowAvSize_forMean=3;%1
windowAvSize_forStd=3;%3

% subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM','EM','HL','NA','RB','SG','SS','YB','YS','SE','GS'}; %,'SE','GS'
% for s=1:length(subjects)
%     if exist(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No_subMIRCGROUP.mat'],'file')
%         type=1;
%         types(s)=type;
% %         currcolor={'b','k','c'};
%     else
%         type=2;
%         types(s)=type;
% %         currcolor={'m','k','c'};
%     end
%     %
%     paths= {...
%             ['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat'],...
%             ['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat']
%             };
%         currcolor={'b','m'};
    
    for group=1:length(paths)
        MeanVel=[];
        MeanVar=[];
        relD=0;
        
        %         MeanCC=[];
        %         Amp=[];
        %         freqAmp=[];
        if exist(paths{group})
        load(paths{group});
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
        %                 if group==max(1:length(group))
        if type==1
            figure(3)
%             subplot(2,5,s-10)
        else
            figure(4)
            subplot(2,5,s)
        end
%         subplot(2,5,s)
        errorbar((1:size(MeanVel,2)).*4,nanmean(MeanVel),nanstd(MeanVel)./sqrt(size(MeanVel,1)-sum(isnan(MeanVel))),'color',currcolor{1,group},'LineWidth',3)
        hold on
        plot((1:size(MeanVel,2)).*4,nanmean(MeanVel),'k')
        targetV=nanmean(MeanVel);
        targetV=mean(targetV(100/4:200/4));
        text(100,targetV+2,num2str(round(targetV,2)),'color',currcolor{1,group},'FontSize', 20)
        %         legend('subMIRCS','','MIRCs','')
        axis([0 200 0 9])
        xlabel('T within pause [ms]','FontSize', 20)
        ylabel('speed [deg/sec]','FontSize', 20)
%         title([subjects{1,s} '  Inst Speed'])
        %                 end
        all{group}=nanmean(MeanVel);
        end
         
    end
    [s,t]=kstest2(all{1}(15:50),all{2}(15:50));
    if s==1
        text(60,2.5,'* KS','Fontsize',22)
    end
    [s,t]=kstest2(all{2}(15:50),all{3}(15:50));
    
% end
% tilefigs