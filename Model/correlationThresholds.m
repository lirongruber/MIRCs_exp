% Correlations threshold analysis + sacc number correlations with act/info
% rec

% class={ class{1,:} class{3,:} ; class{2,:}  class{4,:} };

titles={'MIRCs yes','MIRCs no','subMIRCs yes','subMIRCs no'};
titles={'Recognized','Not Recognized'};
close all
for c=1:size(class,1)
    allPerClass=[];
    num=0;
    numOfsaccades=[];
    firstMeanRecAct=[];
    firstMeanRecNum=[];
    histValues={};
    MEAN_histValues={};
    all_MEAN_histValues=[];
    histValues_rev={};
    MEAN_histValues_rev={};
    all_MEAN_histValues_rev=[];
    
    for t=1:size(class,2)
        disp(t)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
%             figure(1)
%             subplot(2,2,c)
%             title(titles{c});
%             hold on
%             for i=1:size(currT.movvarmeanInfoPerRec,2)
%                 num=num+1;
%                 plot(currT.movvarmeanInfoPerRec{1,i})
%                 allPerClass(num,1:size(currT.movvarmeanInfoPerRec{1,i},2))=currT.movvarmeanInfoPerRec{1,i};
%             end
%             figure(10)
%             subplot(2,2,c)
%             hold on
%             plot(currT.meanInfoPerRec(1),size(currT.meanInfoPerRec,2),'.')
%             xlabel('first fixation mean rec activation')
%             ylabel('number of saccades')
%             numOfsaccades(t)=size(currT.meanInfoPerRec,2);
%             firstMeanRecAct(t)=currT.meanInfoPerRec(1);
            
            figure(100)
            subplot(2,2,c)
            title(titles{c})
            hold on
            plot(currT.numOfinfoRec(1),size(currT.numOfinfoRec,2),'.')
            xlabel('first fixation number of info receptors')
            ylabel('number of saccades')
            numOfsaccades(t)=size(currT.meanInfoPerRec,2);
            firstMeanRecNum(t)=currT.numOfinfoRec(1);
            
            
            for s=1:min(8,size(currT.actCorrelations,2))
                figure(1+c)
                subplot(2,4,s)
%                 hold on
                h=histogram(currT.actCorrelations{s},'Normalization','cdf','BinEdges',0:0.02:1);
                histValues{s}(t,:)=h.Values;
%                 axis([0 1 0 1])
%                 figure((1+c)*10)
%                 subplot(2,6,s)
%                 hold on
%                 h=histogram(currT.actCorrelations{size(currT.actCorrelations,2)+1-s},'Normalization','cdf','BinEdges',0:0.02:1);
%                 histValues_rev{s}(t,:)=h.Values;
%                 axis([0 1 0 1])
            end
        end
    end
%     figure(1+c)
%     title(titles{c})
%     xlabel('hist of act correlation per fixation')
    for i=1:size(histValues,2)
        for ii=1:size(histValues{i},1)
            if sum(histValues{i}(ii,:)==0)
                histValues{i}(ii,:)=nan;
            end
        end
    end
    for ii=1:size(histValues,2)
        MEAN_histValues{ii}=nanmean(histValues{ii});
%         subplot(2,6,ii)
%         plot(0.02:0.02:1,MEAN_histValues{ii},'k','LineWidth',3)
        all_MEAN_histValues(ii,:)=MEAN_histValues{ii};
    end
    
%     figure((1+c)*10)
%     title([titles{c} '  rev'])
%     xlabel('hist of act correlation per rev-fixation')
%     for i=1:size(histValues_rev,2)
%         for ii=1:size(histValues_rev{i},1)
%             if sum(histValues_rev{i}(ii,:)==0)
%                 histValues_rev{i}(ii,:)=nan;
%             end
%         end
%     end
%     for ii=1:size(histValues_rev,2)
%         MEAN_histValues_rev{ii}=nanmean(histValues_rev{ii});
%         subplot(2,6,ii)
%         plot(0.02:0.02:1,MEAN_histValues_rev{ii},'k','LineWidth',3)
%         all_MEAN_histValues_rev(ii,:)=MEAN_histValues_rev{ii};
%     end
%     
    figure(200)
    subplot(1,4,c)
    hold on
    for i=1:10:size(0.02:0.02:1,2)
        perTh=all_MEAN_histValues(:,i);
        plot(perTh)
        xlabel('fixation number')
        ylabel('sumCum per Th')
    end
    legend(num2str([0.02:0.02*10:1]'))
    title(titles{c})
%     
%     figure(201)
%     subplot(1,4,c)
%     hold on
%     for i=1:10:size(0.02:0.02:1,2)
%         perTh=all_MEAN_histValues_rev(:,i);
%         plot(perTh)
%         xlabel('rev-fixation number')
%         ylabel('sumCum per Th')
%     end
%     legend(num2str([0.02:0.02*10:1]'))
%     title(titles{c})
    
%     figure(1)
%     subplot(2,2,c)
%     title(titles{c})
%     allPerClass(allPerClass==0)=nan;
%     plot(nanmean(allPerClass),'k')
%     xlabel('time')
%     ylabel('moving var of mean receptors activation')
%     
%     figure(10)
%     subplot(2,2,c)
%     hold on
%     rel_firstMeanRecAct=firstMeanRecAct;
%     rel_numOfsaccades=numOfsaccades;
%     rel_firstMeanRecAct=rel_firstMeanRecAct(rel_firstMeanRecAct~=0);
%     rel_numOfsaccades=rel_numOfsaccades(rel_firstMeanRecAct~=0);
%     rel_firstMeanRecAct=rel_firstMeanRecAct(rel_firstMeanRecAct<150);
%     rel_numOfsaccades=rel_numOfsaccades(rel_firstMeanRecAct<150);
%     
%     [tempC,pv]=corr(rel_firstMeanRecAct',rel_numOfsaccades');
%     title([titles{c} '  c=' num2str(tempC) '  p=' num2str(pv)])
%     p=polyfit(rel_firstMeanRecAct',rel_numOfsaccades',1);
%     f = polyval(p,rel_firstMeanRecAct');
%     plot(rel_firstMeanRecAct',f,'--k')
%     
%     figure(100)
%     subplot(2,2,c)
%     hold on
%     [tempC,pv]=corr(firstMeanRecNum',numOfsaccades');
%     title([titles{c} '  c=' num2str(tempC) '  p=' num2str(pv)])
%     p=polyfit(firstMeanRecNum',numOfsaccades',1);
%     f = polyval(p,firstMeanRecNum');
%     plot(firstMeanRecNum',f,'--k')
correlationsTh{c}=all_MEAN_histValues;
end
tilefigs;


