close all
% colors={[2,122,164]./256,[245,218,95]./256,[65,173,73]./256,[244,147,31]./256}; % blue yellow green orange
% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};

colors={[2,122,164]./256,[244,147,31]./256}; % blue yellow green orange
folders={'MIRCs Yes','subMIRCs No'};
% class={ class{1,:} ; class{4,:} };
% class=one_class;
% class=control_class;
STDforOutL=5; %number of std from mean to include
perNonNan2include=0.9;

forSVM={};
for c=1:size(class,1)
%     optNum_dav=nan(size(class,2),30);
%     optNum_dav_rev=nan(size(class,2),30);
%     optNum_sil=nan(size(class,2),30);
%     optNum_sil_rev=nan(size(class,2),30);
    optNum_fpca=nan(size(class,2),30);
    optNum_fpca_rev=nan(size(class,2),30);
   
    
    %Time fixation
    TimeFixation=nan(size(class,2),30);
    TimeFixation_rev=nan(size(class,2),30);
    %Number of activations
    numOfinfoRec=nan(size(class,2),30);
    numOfinfoRec_rev=nan(size(class,2),30);
    
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            
%             optNum_sil(t,1:size(currT.optNumClass_silhouette,2))=currT.optNumClass_silhouette;
%             optNum_sil_rev(t,1:size(currT.optNumClass_silhouette,2))=flip(currT.optNumClass_silhouette);
%             
%             optNum_dav(t,1:size(currT.optNumClass_DaviesBouldin,2))=currT.optNumClass_DaviesBouldin;
%             optNum_dav_rev(t,1:size(currT.optNumClass_DaviesBouldin,2))=flip(currT.optNumClass_DaviesBouldin);
            
            optNum_fpca(t,1:size(currT.optNumClass_FPCA,2))=currT.optNumClass_FPCA;
            optNum_fpca_rev(t,1:size(currT.optNumClass_FPCA,2))=flip(currT.optNumClass_FPCA);
            
            %Time length
            TimeFixation(t,1:size(currT.timeFixation,2))=currT.timeFixation;
            TimeFixation_rev(t,1:size(currT.timeFixation,2))=flip(currT.timeFixation);
            %number of info receptors
            numOfinfoRec(t,1:size(currT.numOfinfoRec,2))=currT.numOfinfoRec;
            numOfinfoRec_rev(t,1:size(currT.numOfinfoRec,2))=flip(currT.numOfinfoRec);
            
        end
        
    end
    
%     optNum_sil=optNum_sil(:,sum(isnan(optNum_sil))<size(optNum_sil,1)*perNonNan2include);
%     optNum_sil(optNum_sil==0)=nan;
%     optNum_sil_rev=optNum_sil_rev(:,sum(isnan(optNum_sil_rev))<size(optNum_sil_rev,1)*perNonNan2include);
%     optNum_sil_rev(optNum_sil_rev==0)=nan;
%     optNum_dav=optNum_dav(:,sum(isnan(optNum_dav))<size(optNum_dav,1)*perNonNan2include);
%     optNum_dav(optNum_dav==0)=nan;
%     optNum_dav_rev=optNum_dav_rev(:,sum(isnan(optNum_dav_rev))<size(optNum_dav_rev,1)*perNonNan2include);
%     optNum_dav_rev(optNum_dav_rev==0)=nan;
    optNum_fpca=optNum_fpca(:,sum(isnan(optNum_fpca))<size(optNum_fpca,1)*perNonNan2include);
    optNum_fpca(optNum_fpca==0)=nan;
    optNum_fpca_rev=optNum_fpca_rev(:,sum(isnan(optNum_fpca_rev))<size(optNum_fpca_rev,1)*perNonNan2include);
    optNum_fpca_rev(optNum_fpca_rev==0)=nan;
    TimeFixation=TimeFixation(:,sum(isnan(TimeFixation))<size(TimeFixation,1)*perNonNan2include);
    TimeFixation(TimeFixation==0)=nan;
    TimeFixation_rev=TimeFixation_rev(:,sum(isnan(TimeFixation_rev))<size(TimeFixation_rev,1)*perNonNan2include);
    TimeFixation_rev(TimeFixation_rev==0)=nan;
    numOfinfoRec=numOfinfoRec(:,sum(isnan(numOfinfoRec))<size(numOfinfoRec,1)*perNonNan2include);
    numOfinfoRec(numOfinfoRec==0)=nan;
    numOfinfoRec_rev=numOfinfoRec_rev(:,sum(isnan(numOfinfoRec_rev))<size(numOfinfoRec_rev,1)*perNonNan2include);
    numOfinfoRec_rev(numOfinfoRec_rev==0)=nan;
    
%     
%     figure(1)
%     subplot(2,3,c)
%     hold on
%     plot(optNum_sil','.','color','k')
%     M=nanmean(optNum_sil(:));
%     S=nanstd(optNum_sil(:))*STDforOutL;
%     optNum_sil(~((optNum_sil<= M+S)&(optNum_sil>= M-S)))=nan;
%     plot(optNum_sil','color',colors{c})
%     plot(nanmean(optNum_sil),'color',colors{c})
%     xlabel('fixation number from trial start')
%     subplot(2,3,3)
%     hold on
%     errorbar(nanmean(optNum_sil),nanstd(optNum_sil)./sum(~isnan(optNum_sil),1),'color',colors{c})
%     title('silhouette')
%     
%     
%     subplot(2,3,c+3)
%     hold on
%     plot(optNum_sil_rev','.','color','k')
%     M=nanmean(optNum_sil_rev(:));
%     S=nanstd(optNum_sil_rev(:))*STDforOutL;
%     optNum_sil_rev(~((optNum_sil_rev<= M+S)&(optNum_sil_rev>= M-S)))=nan;
%     plot(optNum_sil_rev','color',colors{c})
%     plot(nanmean(optNum_sil_rev),'color',colors{c})
%     xlabel('reversed fixation number from trial end')
%     subplot(2,3,6)
%     hold on
%     errorbar(nanmean(optNum_sil_rev),nanstd(optNum_sil_rev)./sum(~isnan(optNum_sil_rev),1),'color',colors{c})
%     
%     figure(2)
%     subplot(2,3,c)
%     hold on
%     plot(optNum_dav','.','color','k')
%     M=nanmean(optNum_dav(:));
%     S=nanstd(optNum_dav(:))*STDforOutL;
%     optNum_dav(~((optNum_dav<= M+S)&(optNum_dav>= M-S)))=nan;
%     plot(optNum_dav','color',colors{c})
%     plot(nanmean(optNum_dav),'color',colors{c})
%     xlabel('fixation number from trial start')
%     subplot(2,3,3)
%     hold on
%     errorbar(nanmean(optNum_dav),nanstd(optNum_dav)./sum(~isnan(optNum_dav),1),'color',colors{c})
%     title('DaviesBouldin')
%     
%     subplot(2,3,c+3)
%     hold on
%     plot(optNum_dav_rev','.','color','k')
%     M=nanmean(optNum_dav_rev(:));
%     S=nanstd(optNum_dav_rev(:))*STDforOutL;
%     optNum_dav_rev(~((optNum_dav_rev<= M+S)&(optNum_dav_rev>= M-S)))=nan;
%     plot(optNum_dav_rev','color',colors{c})
%     plot(nanmean(optNum_dav_rev),'color',colors{c})
%     xlabel('reversed fixation number from trial end')
%     subplot(2,3,6)
%     hold on
%     errorbar(nanmean(optNum_dav_rev),nanstd(optNum_dav_rev)./sum(~isnan(optNum_dav_rev),1),'color',colors{c})
    
    figure(3)
    subplot(2,4,c)
    hold all
    plot(optNum_fpca','.','color','k')
    M=nanmean(optNum_fpca(:));
    S=nanstd(optNum_fpca(:))*STDforOutL;
    optNum_fpca(~((optNum_fpca<= M+S)&(optNum_fpca>= M-S)))=nan;
    plot(optNum_fpca','.','color',colors{c})
    plot(optNum_fpca')%,'color',colors{c})
    plot(nanmean(optNum_fpca),'color',colors{c})
    xlabel('fixation number from trial start')
    subplot(2,4,3)
    hold on
    errorbar(nanmean(optNum_fpca),nanstd(optNum_fpca)./sum(~isnan(optNum_fpca),1),'color',colors{c})
    title('FPCA')
    forSVM{c}=optNum_fpca;
    
    subplot(2,4,c+4)
    hold on
    plot(optNum_fpca_rev','.','color','k')
    M=nanmean(optNum_fpca_rev(:));
    S=nanstd(optNum_fpca_rev(:))*STDforOutL;
    optNum_fpca_rev(~((optNum_fpca_rev<= M+S)&(optNum_fpca_rev>= M-S)))=nan;
    plot(optNum_fpca_rev','color',colors{c})
    plot(nanmean(optNum_fpca_rev),'color',colors{c})
    xlabel('reversed fixation number from trial end')
    subplot(2,4,7)
    hold on
    errorbar(nanmean(optNum_fpca_rev),nanstd(optNum_fpca_rev)./sum(~isnan(optNum_fpca_rev),1),'color',colors{c})
    
    subplot(2,4,4)
    hold on
    histogram(optNum_fpca,'FaceColor',colors{c},'normalization','probability')
    plot([nanmean(optNum_fpca(:)) nanmean(optNum_fpca(:))],[0,0.4],'color',colors{c})
    title('FPCA')
    xlabel('optNum of classes')
    
    figure(4)
%     subplot(1,3,1)
%     hold on
%     histogram(optNum_sil,'FaceColor',colors{c},'normalization','probability')
%     plot([nanmean(optNum_sil(:)) nanmean(optNum_sil(:))],[0,0.4],'color',colors{c})
%     title('silhouette')
%     xlabel('optNum of classes')
%     subplot(1,3,2)
%     hold on
%     histogram(optNum_dav,'FaceColor',colors{c},'normalization','probability')
%     plot([nanmean(optNum_dav(:)) nanmean(optNum_dav(:))],[0,0.4],'color',colors{c})
%     title('DaviesBouldin')
%     xlabel('optNum of classes')
    subplot(1,3,3)
    hold on
    histogram(optNum_fpca,'FaceColor',colors{c},'normalization','probability')
    plot([nanmean(optNum_fpca(:)) nanmean(optNum_fpca(:))],[0,0.4],'color',colors{c})
    title('FPCA')
    xlabel('optNum of classes')
    
    figure(5)
    subplot(1,2,1)
    hold on
    M=nanmean(TimeFixation(:));
    S=nanstd(TimeFixation(:))*STDforOutL;
    TimeFixation(~((TimeFixation<= M+S)&(TimeFixation>= M-S)))=nan;
    histogram (TimeFixation,'FaceColor',colors{c},'BinEdges',0:100:3000,'normalization','probability')
    plot([nanmean(TimeFixation(:)) nanmean(TimeFixation(:))],[0,0.2],'color',colors{c})
    title('Fixation Duration')
    
    subplot(1,2,2)
    hold on
    M=nanmean(numOfinfoRec_rev(:));
    S=nanstd(numOfinfoRec_rev(:))*STDforOutL;
    numOfinfoRec_rev(~((numOfinfoRec_rev<= M+S)&(numOfinfoRec_rev>= M-S)))=nan;
    histogram (numOfinfoRec,'FaceColor',colors{c},'BinEdges',0:100:2000,'normalization','probability')
    plot([nanmedian(numOfinfoRec(:)) nanmedian(numOfinfoRec(:))],[0,0.2],'color',colors{c})
    title('Number of receptors')
    
end

tilefigs;