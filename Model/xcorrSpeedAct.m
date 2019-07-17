% xcorr instSpeed and instMeanActivation

close all
% colors={[2,122,164]./256,[245,218,95]./256,[65,173,73]./256,[244,147,31]./256}; % blue yellow green orange
% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};

colors={[2,122,164]./256,[244,147,31]./256}; % blue yellow green orange
folders={'MIRCs Yes','subMIRCs No'};
% class={ class{1,:} ; class{4,:} };

perNonNan2include=0.9;
for c=1:size(class,1)
    r_perPause={};
    n=0;
    
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        r_perTrial=[];
        
        SpeedPerPause=[];
        meanRecAct=[];
        
        if ~isempty(currT)
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
                    figure(c)
                    subplot(2,4,p)
                    hold on
                    plot(lags.*10,r)
                    xlabel('time lag [ms]')
                    ylabel('xcorr r')
                    r_perTrial(p,:)=r;
                    r_perPause{1,p}(n,:)=r;
                end
            end
        end
    end
    figure(c*10)
    for p=1:size(r_perPause,2)
        rel=r_perPause{1,p};
        rel(rel==0)=nan;
        rel=rel(:,sum(isnan(rel))<size(rel,1)*perNonNan2include);
        rel=rel(~isnan(sum(rel,2)),:);
        subplot(2,4,p)
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
    end
end
