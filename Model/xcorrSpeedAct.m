% xcorr instSpeed and instMeanActivation

% close all
% colors={[2,122,164]./256,[245,218,95]./256,[65,173,73]./256,[244,147,31]./256}; % blue yellow green orange
% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};

colors={[2,122,164]./256,[244,147,31]./256}; % blue yellow green orange
folders={'MIRCs Yes','subMIRCs No'};
% class={ class{1,:} ; class{4,:} };
% class=control_class;

figure()
perNonNan2include=0.9;
for c=1:size(class,1)
    r_perPause={};
    r_act_perPause={};
    r_s_perPause={};
    n=0;
    
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        
        SpeedPerPause=[];
        meanRecAct=[];
        
        if ~isempty(currT) && ~isempty(fieldnames(currT))
            n=n+1;
            for p=1:min(size(currT.Speed,2),8)
                %inst speed per pause
                currSpeed=currT.Speed{1,p};
                SpeedPerPause(p,1:size(currSpeed,2))=currSpeed;
                
                % inst mean activations per pause
                currAct=currT.meanRecActivation{1,p};
                meanRecAct(p,1:size(currAct,2))=currAct;
                
                if size(currAct,2)>14 && size(currSpeed,2)
                    [r,lags] = xcorr(currAct,currSpeed,15,'coeff'); % or unbiased with/without detrend?
                    r=detrend(r);
                    [r_act,lags] = xcorr(currAct,currAct,15,'coeff'); % or unbiased with/without detrend?
                    r_act=r_act(16:end);
                    r_act=detrend(r_act);
                    [r_s,lags] = xcorr(currSpeed,currSpeed,15,'coeff'); % or unbiased with/without detrend?
                    r_s=r_s(16:end);
                    r_s=detrend(r_s);
%                     figure(c)
%                     subplot(2,4,p)
%                     hold on
%                     plot(lags.*10,r)
%                     xlabel('time lag [ms]')
%                     ylabel('xcorr r')
                    r_perPause{1,p}(n,:)=r;
                    r_act_perPause{1,p}(n,:)=r_act;
                    r_s_perPause{1,p}(n,:)=r_s;
                end
            end
        end
    end
%     figure(c*10)
%     for p=1:size(r_perPause,2)
%         rel=r_perPause{1,p};
%         rel(rel==0)=nan;
%         rel=rel(:,sum(isnan(rel))<size(rel,1)*perNonNan2include);
%         rel=rel(~isnan(sum(rel,2)),:);
%         subplot(2,4,p)
%         hold on
%         imagesc(rel)
%         colormap('jet')
%         caxis([-1 1])
%         xticks(0:5:31)
%         xticklabels(-150:50:150)
%         ax = gca;
%         ax.FontSize = 12;
%         %         colorbar
%         xlabel('time lag [ms]')
%         ylabel('xcorr r')
%         yyaxis right
%         plot(nanmean(rel),'k')
%         errorbar(nanmean(rel),nanstd(rel)./sqrt(size(rel,1)),'-k')
%     end
    
    
    rel=[];
    rel_act=[];
    rel_s=[];
    for p=1:size(r_perPause,2)
        rel=[rel ; r_perPause{1,p}];
        rel_act=[rel_act ; r_act_perPause{1,p}];
        rel_s=[rel_s ; r_s_perPause{1,p}];
    end
    rel(rel==0)=nan;
    rel_act(rel_act==0)=nan;
    rel_s(rel_s==0)=nan;
    rel=rel(:,sum(isnan(rel))<size(rel,1)*perNonNan2include);
    rel_act=rel_act(:,sum(isnan(rel_act))<size(rel_act,1)*perNonNan2include);
    rel_s=rel_s(:,sum(isnan(rel_s))<size(rel_s,1)*perNonNan2include);
    rel=rel(~isnan(sum(rel,2)),:);
    rel_act=rel_act(~isnan(sum(rel_act,2)),:);
    rel_s=rel_s(~isnan(sum(rel_s,2)),:);

    subplot(1,4,c*2)
    hold on
    imagesc(rel)
    colormap('jet')
    caxis([-1 1])
    xticks(0:5:31)
    xticklabels(-150:50:150)
    ax = gca;
    ax.FontSize = 12;
    %         colorbar
    xlabel('time lag [ms]')
    ylabel('xcorr r')
    yyaxis right
    plot(nanmean(rel),'k')
    errorbar(nanmean(rel),nanstd(rel)./sqrt(size(rel,1)),'-k')
    
    subplot(2,4,c*2-1)
    hold on
    imagesc(rel_act)
    colormap('jet')
    caxis([-1 1])
    xticks(0:5:16)
    xticklabels(0:50:150)
    ax = gca;
    ax.FontSize = 12;
    %         colorbar
    xlabel('time lag [ms]')
    ylabel('autocorr act')
    yyaxis right
    plot(nanmean(rel_act),'k')
    errorbar(nanmean(rel_act),nanstd(rel_act)./sqrt(size(rel_act,1)),'-k')
    
    subplot(2,4,(c*2-1)+4)
    hold on
    imagesc(rel_s)
    colormap('jet')
    caxis([-1 1])
    xticks(0:5:16)
    xticklabels(0:50:150)
    ax = gca;
    ax.FontSize = 12;
    %         colorbar
    xlabel('time lag [ms]')
    ylabel('autocorr speed')
    yyaxis right
    plot(nanmean(rel_s),'k')
    errorbar(nanmean(rel_s),nanstd(rel_s)./sqrt(size(rel_s,1)),'-k')
    
%     % to save controls
    data_rel{c}=rel;
end
