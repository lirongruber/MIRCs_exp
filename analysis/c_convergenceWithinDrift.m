% CONVERGENCE WITHIN TRIAL
clear
close all

% paths={...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_subMIRCGROUP',...
%     'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_MIRCGROUP.mat',...
%     };


methods2={'fullImage' 'mean' 'Mirc' 'mean' 'subMirc' 'mean' 'stabMirc' 'mean'};
currcolor={'b','m','k','k'};

windowAvSize_forMean=3;%1
windowAvSize_forStd=3;%3

subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM','EM','HL','NA','RB','SG','SS','YB','YS','SE','GS'}; %,'SE','GS'
for s=1:length(subjects)
    if exist(['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No_subMIRCGROUP.mat'],'file')
        type=1;
        %         p(type)=p(type)+1;
        name='subMIRCs';
        paths= {...
            ['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No_subMIRCGROUP.mat'],...
%             ['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_subMIRCGROUP.mat'],...
                        ['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth_subMIRCGROUP.mat']
            };
        
        types(s)=type;
        currcolor={'b','k','c'};
    else
        type=2;
        %         p(type)=p(type)+1;
        name='MIRCs';
        paths= {...
            ['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes_MIRCGROUP.mat'],...
%             ['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst0_Sub0Mirc0Full0Ref1_recBoth_MIRCGROUP.mat'],...
                        ['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,s} '_OnlyFirst0_Sub0Mirc0Full1Ref0_recBoth_MIRCGROUP.mat'],...
            };
        types(s)=type;
        currcolor={'m','k','c'};
    end
    %
    
    for group=1:length(paths)
        MeanVel=[];
        MeanVar=[];
        relD=0;
        
        %         MeanCC=[];
        %         Amp=[];
        %         freqAmp=[];
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
            figure(1)
            subplot(2,5,s-10)
        else
            figure(2)
            subplot(2,5,s)
        end
%         subplot(2,5,s)
        errorbar((1:size(MeanVel,2)).*4,nanmean(MeanVel),nanstd(MeanVel)./sqrt(size(MeanVel,1)-sum(isnan(MeanVel))),'color',currcolor{1,group},'LineWidth',3)
        hold on
        plot((1:size(MeanVel,2)).*4,nanmean(MeanVel),'k')
        targetV=nanmean(MeanVel);
        text(160,targetV(160/4)+1,num2str(round(targetV(160/4),2)),'color','b')
        %         legend('subMIRCS','','MIRCs','')
        axis([0 200 0 9])
        xlabel('T within pause [ms]','FontSize', 20)
        ylabel('speed [deg/sec]','FontSize', 20)
        title([subjects{1,s} '  Inst Speed'])
        %                 end
        
    end
end
% tilefigs