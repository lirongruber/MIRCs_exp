close all
% colors={[2,122,164]./256,[245,218,95]./256,[65,173,73]./256,[244,147,31]./256}; % blue yellow green orange
% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};

colors={[2,122,164]./256,[244,147,31]./256}; % blue yellow green orange
folders={'MIRCs Yes','subMIRCs No'};
% class={ class{1,:} ; class{4,:} };
STDforOutL=2; %number of std from mean to include
perNonNan2include=0.9;

numofSubPlot=size(folders,2)+1;
for c=1:size(class,1)
    optNum_dav=nan(size(class,2),30);
    optNum_dav_rev=nan(size(class,2),30);
    optNum_sil=nan(size(class,2),30);
    optNum_sil_rev=nan(size(class,2),30);
    optNum_fpca=nan(size(class,2),30);
    optNum_fpca_rev=nan(size(class,2),30);
    
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            
            optNum_sil(t,1:size(currT.optNumClass_silhouette,2))=currT.optNumClass_silhouette;
            optNum_sil_rev(t,1:size(currT.optNumClass_silhouette,2))=flip(currT.optNumClass_silhouette);
            
            optNum_dav(t,1:size(currT.optNumClass_DaviesBouldin,2))=currT.optNumClass_DaviesBouldin;
            optNum_dav_rev(t,1:size(currT.optNumClass_DaviesBouldin,2))=flip(currT.optNumClass_DaviesBouldin);
            
            optNum_fpca(t,1:size(currT.optNumClass_FPCA,2))=currT.optNumClass_FPCA;
            optNum_fpca_rev(t,1:size(currT.optNumClass_FPCA,2))=flip(currT.optNumClass_FPCA);
        end
        
    end
    
    optNum_sil=optNum_sil(:,sum(isnan(optNum_sil))<size(optNum_sil,1)*perNonNan2include);
    optNum_sil(optNum_sil==0)=nan;
    optNum_sil_rev=optNum_sil_rev(:,sum(isnan(optNum_sil_rev))<size(optNum_sil_rev,1)*perNonNan2include);
    optNum_sil_rev(optNum_sil_rev==0)=nan;
    optNum_dav=optNum_dav(:,sum(isnan(optNum_dav))<size(optNum_dav,1)*perNonNan2include);
    optNum_dav(optNum_dav==0)=nan;
    optNum_dav_rev=optNum_dav_rev(:,sum(isnan(optNum_dav_rev))<size(optNum_dav_rev,1)*perNonNan2include);
    optNum_dav_rev(optNum_dav_rev==0)=nan;
    optNum_fpca=optNum_fpca(:,sum(isnan(optNum_fpca))<size(optNum_fpca,1)*perNonNan2include);
    optNum_fpca(optNum_fpca==0)=nan;
    optNum_fpca_rev=optNum_fpca_rev(:,sum(isnan(optNum_fpca_rev))<size(optNum_fpca_rev,1)*perNonNan2include);
    optNum_fpca_rev(optNum_fpca_rev==0)=nan;
    
    for i=1:min(9,size(optNum_fpca,2))
        figure(1)
        %         figure(i)
        subplot(2,3,1)
        hold on
        errorbar(nanmean(optNum_sil),nanstd(optNum_sil)./sum(~isnan(optNum_sil),1),'color',colors{c})
        %         histogram(optNum_sil(:,i),'FaceColor',colors{c},'normalization','probability')
        %                 xlabel('fixation number from trial start')
        title('silhouette')
        subplot(2,3,2)
        hold on
        errorbar(nanmean(optNum_dav),nanstd(optNum_dav)./sum(~isnan(optNum_dav),1),'color',colors{c})
        %         histogram(optNum_dav(:,i),'FaceColor',colors{c},'normalization','probability')
        xlabel('fixation number from trial start')
        title('DaviesBouldin')
        subplot(2,3,3)
        hold on
        errorbar(nanmean(optNum_fpca),nanstd(optNum_fpca)./sum(~isnan(optNum_fpca),1),'color',colors{c})
        %         histogram(optNum_fpca(:,i),'FaceColor',colors{c},'normalization','probability')
        xlabel('fixation number from trial start')
        ylabel('optimal number of classes')
        title('FPCA')
        text (7,3,'MIRCs','color',colors{1})
        text (7,2.8,'subMIRCs','color',colors{2})
        subplot(2,3,4)
        hold on
        errorbar(nanmean(optNum_sil_rev),nanstd(optNum_sil_rev)./sum(~isnan(optNum_sil_rev),1),'color',colors{c})
        %         histogram(optNum_sil_rev(:,i),'FaceColor',colors{c},'normalization','probability')
        %         xlabel('reversed fixation number from trial end')
        subplot(2,3,5)
        hold on
        errorbar(nanmean(optNum_dav_rev),nanstd(optNum_dav_rev)./sum(~isnan(optNum_dav_rev),1),'color',colors{c})
        %         histogram(optNum_dav_rev(:,i),'FaceColor',colors{c},'normalization','probability')
        %         xlabel('reversed fixation number from trial end')
        subplot(2,3,6)
        hold on
        errorbar(nanmean(optNum_fpca_rev),nanstd(optNum_fpca_rev)./sum(~isnan(optNum_fpca_rev),1),'color',colors{c})
        %         histogram(optNum_fpca_rev(:,i),'FaceColor',colors{c},'normalization','probability')
        %         xlabel('reversed fixation number from trial end')
        
    end
    figure(2)
    subplot(1,3,1)
    hold on
    histogram(optNum_sil,'FaceColor',colors{c},'normalization','probability')
    plot(nanmean(optNum_sil(:)),0.3,'*','color',colors{c})
    subplot(1,3,2)
    hold on
    histogram(optNum_dav,'FaceColor',colors{c},'normalization','probability')
    plot(nanmean(optNum_dav(:)),0.3,'*','color',colors{c})
    subplot(1,3,3)
    hold on
    histogram(optNum_fpca,'FaceColor',colors{c},'normalization','probability')
    plot(nanmean(optNum_fpca(:)),0.3,'*','color',colors{c})
end

tilefigs;