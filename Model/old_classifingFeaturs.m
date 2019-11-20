% plotting "class"...
close all
colors={[2,122,164]./256,[245,218,95]./256,[65,173,73]./256,[244,147,31]./256}; % blue yellow green orange
folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};

for c=1:size(class,1)
    numOfinfoRec=nan(size(class,2),30);
    numOfinfoRec_rev=nan(size(class,2),30);
    targetSpeed=nan(size(class,2),30);
    targetSpeed_rev=nan(size(class,2),30);
    insAct_Speed=nan(size(class,2),30);
    insAct_Speed_rev=nan(size(class,2),30);
    varSpeed=nan(size(class,2),30);
    varSpeed_rev=nan(size(class,2),30);
    infoPerRec=nan(size(class,2),30);
    infoPerRec_rev=nan(size(class,2),30);
    ampFixation=nan(size(class,2),30);
    ampFixation_rev=nan(size(class,2),30);
    distFixation=nan(size(class,2),30);
    distFixation_rev=nan(size(class,2),30);
    varInfoPerRec=nan(size(class,2),30);
    varInfoPerRec_rev=nan(size(class,2),30);
    peakXcorr={};
    peakXcorr{30,1}=[];
    peakXcorr_rev={};
    peakXcorr_rev{30,1}=[];
    peakfftXcorr={};
    peakfftXcorr{30,1}=[];
    peakfftXcorr_rev={};
    peakfftXcorr_rev{30,1}=[];
    rs13=[];
    rs13_rev=[];
    rs16=[];
    rs16_rev=[];
    rs17=[];
    rs17_rev=[];
    rs23=[];
    rs23_rev=[];
    rs26=[];
    rs26_rev=[];
    rs27=[];
    rs27_rev=[];
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            figure(1) %number of info receptors
            hold on
            subplot(2,5,c)
            plot(currT.numOfinfoRec,'.','color',colors{c})
            hold on
            axis([0 12 0 30000])
            
            subplot(2,5,c+5)
            plot(flip(currT.numOfinfoRec),'.','color',colors{c})
            hold on
            axis([0 12 0 20000])
            
            numOfinfoRec(t,1:size(currT.numOfinfoRec,2))=currT.numOfinfoRec;
            numOfinfoRec_rev(t,1:size(currT.numOfinfoRec,2))=flip(currT.numOfinfoRec);
            
            figure(2) % mean rec activations
            hold on
            subplot(2,5,c)
            plot(currT.meanInfoPerRec,'.','color',colors{c})
            hold on
            
            subplot(2,5,c+5)
            plot(flip(currT.meanInfoPerRec),'.','color',colors{c})
            hold on
            
            infoPerRec(t,1:size(currT.meanInfoPerRec,2))=currT.meanInfoPerRec;
            infoPerRec_rev(t,1:size(currT.meanInfoPerRec,2))=flip(currT.meanInfoPerRec);
            
            figure(3) %speed
            hold on
            subplot(2,5,c)
            plot(currT.targetSpeed,'.','color',colors{c})
            hold on
            
            subplot(2,5,c+5)
            plot(flip(currT.targetSpeed),'.','color',colors{c})
            hold on
            
            targetSpeed(t,1:size(currT.targetSpeed,2))=currT.targetSpeed;
            targetSpeed_rev(t,1:size(currT.targetSpeed,2))=flip(currT.targetSpeed);
            
            figure(6) % amp
            hold on
            subplot(2,5,c)
            plot(currT.ampFixation,'.','color',colors{c})
            hold on
            
            subplot(2,5,c+5)
            plot(flip(currT.ampFixation),'.','color',colors{c})
            hold on
            
            ampFixation(t,1:size(currT.ampFixation,2))=currT.ampFixation;
            ampFixation_rev(t,1:size(currT.ampFixation,2))=flip(currT.ampFixation);
            
            figure(7) % dist
            hold on
            subplot(2,5,c)
            plot(currT.distFixation,'.','color',colors{c})
            hold on
            
            subplot(2,5,c+5)
            plot(flip(currT.distFixation),'.','color',colors{c})
            hold on
            
            distFixation(t,1:size(currT.distFixation,2))=currT.distFixation;
            distFixation_rev(t,1:size(currT.distFixation,2))=flip(currT.distFixation);
            
            figure(8) %final ins_act
            hold on
            subplot(2,5,c)
            plot(currT.finalInsInfoPerRec./currT.finalInsSpeed,'.','color',colors{c})
            hold on
            
            subplot(2,5,c+5)
            plot(flip(currT.finalInsInfoPerRec)./flip(currT.finalInsSpeed),'.','color',colors{c})
            hold on
            
            insAct_Speed(t,1:size(currT.finalInsInfoPerRec,2))=currT.finalInsInfoPerRec./currT.finalInsSpeed;
            insAct_Speed_rev(t,1:size(currT.finalInsInfoPerRec,2))=flip(currT.finalInsInfoPerRec)./flip(currT.finalInsSpeed);
            
            figure(13) % xcorr speed+number of inforec
            subplot(2,5,c)
            if size(currT.numOfinfoRec,2)>1
                [r,lags] = xcorr(currT.targetSpeed(1:size(currT.numOfinfoRec,2)),currT.numOfinfoRec,'biased');
                rs13(t,1:size(currT.numOfinfoRec,2))=r(lags>=0);
                imagesc(rs13)
                colormap('jet')
                colorbar
            end
            subplot(2,5,c+5)
            if size(currT.numOfinfoRec,2)>1
                [r,lags] = xcorr(flip(currT.targetSpeed(1:size(currT.numOfinfoRec,2))),flip(currT.numOfinfoRec),'biased');
                rs13_rev(t,1:size(currT.numOfinfoRec,2))=r(lags>=0);
                imagesc(rs13_rev)
                colormap('jet')
                colorbar
            end
            
            
            figure(16) % xcorr amp+number of inforec
            subplot(2,5,c)
            if size(currT.numOfinfoRec,2)>1
                [r,lags] = xcorr(currT.ampFixation(1:size(currT.numOfinfoRec,2)),currT.numOfinfoRec,'biased');
                rs16(t,1:size(currT.numOfinfoRec,2))=r(lags>=0);
                imagesc(rs16)
                colormap('jet')
                colorbar
            end
            subplot(2,5,c+5)
            if size(currT.numOfinfoRec,2)>1
                [r,lags] = xcorr(flip(currT.ampFixation(1:size(currT.numOfinfoRec,2))),flip(currT.numOfinfoRec),'biased');
                rs16_rev(t,1:size(currT.numOfinfoRec,2))=r(lags>=0);
                imagesc(rs16_rev)
                colormap('jet')
                colorbar
            end
            
            figure(17) % xcorr dist+number of inforec
            subplot(2,5,c)
            if size(currT.numOfinfoRec,2)>1
                [r,lags] = xcorr(currT.distFixation(1:size(currT.numOfinfoRec,2)),currT.numOfinfoRec,'biased');
                rs17(t,1:size(currT.numOfinfoRec,2))=r(lags>=0);
                imagesc(rs17)
                colormap('jet')
                colorbar
            end
            subplot(2,5,c+5)
            if size(currT.numOfinfoRec,2)>1
                [r,lags] = xcorr(flip(currT.distFixation(1:size(currT.numOfinfoRec,2))),flip(currT.numOfinfoRec),'biased');
                rs17_rev(t,1:size(currT.numOfinfoRec,2))=r(lags>=0);
                imagesc(rs17_rev)
                colormap('jet')
                colorbar
            end
            
            figure(23) % xcorr speed+mean info per rec
            subplot(2,5,c)
            if size(currT.meanInfoPerRec,2)>1
                [r,lags] = xcorr(currT.targetSpeed(1:size(currT.meanInfoPerRec,2)),currT.meanInfoPerRec,'biased');
                rs23(t,1:size(currT.meanInfoPerRec,2))=r(lags>=0);
                imagesc(rs23)
                colormap('jet')
                colorbar
            end
            subplot(2,5,c+5)
            if size(currT.meanInfoPerRec,2)>1
                [r,lags] = xcorr(flip(currT.targetSpeed(1:size(currT.meanInfoPerRec,2))),flip(currT.meanInfoPerRec),'biased');
                rs23_rev(t,1:size(currT.meanInfoPerRec,2))=r(lags>=0);
                imagesc(rs23_rev)
                colormap('jet')
                colorbar
            end
            
            figure(26) % xcorr amp+mean info per rec
            subplot(2,5,c)
            if size(currT.meanInfoPerRec,2)>1
                [r,lags] = xcorr(currT.ampFixation(1:size(currT.meanInfoPerRec,2)),currT.meanInfoPerRec,'biased');
                rs26(t,1:size(currT.meanInfoPerRec,2))=r(lags>=0);
                imagesc(rs26)
                colormap('jet')
                colorbar
            end
            subplot(2,5,c+5)
            if size(currT.meanInfoPerRec,2)>1
                [r,lags] = xcorr(flip(currT.ampFixation(1:size(currT.meanInfoPerRec,2))),flip(currT.meanInfoPerRec),'biased');
                rs26_rev(t,1:size(currT.meanInfoPerRec,2))=r(lags>=0);
                imagesc(rs26_rev)
                colormap('jet')
                colorbar
            end
            
            figure(27) % xcorr dist+mean info per rec
            subplot(2,5,c)
            if size(currT.meanInfoPerRec,2)>1
                [r,lags] = xcorr(currT.distFixation(1:size(currT.meanInfoPerRec,2)),currT.meanInfoPerRec,'biased');
                rs27(t,1:size(currT.meanInfoPerRec,2))=r(lags>=0);
                imagesc(rs27)
                colormap('jet')
                colorbar
            end
            subplot(2,5,c+5)
            if size(currT.meanInfoPerRec,2)>1
                [r,lags] = xcorr(flip(currT.distFixation(1:size(currT.meanInfoPerRec,2))),flip(currT.meanInfoPerRec),'biased');
                rs27_rev(t,1:size(currT.meanInfoPerRec,2))=r(lags>=0);
                imagesc(rs27_rev)
                colormap('jet')
                colorbar
            end
            
            figure(20) % var activations
            hold on
            subplot(2,5,c)
            plot(currT.varInfoPerRec,'.','color',colors{c})
            hold on
            
            subplot(2,5,c+5)
            plot(flip(currT.varInfoPerRec),'.','color',colors{c})
            hold on
            
            varInfoPerRec(t,1:size(currT.varInfoPerRec,2))=currT.varInfoPerRec;
            varInfoPerRec_rev(t,1:size(currT.varInfoPerRec,2))=flip(currT.varInfoPerRec);
            
            figure(30) % var speed
            hold on
            subplot(2,5,c)
            plot(currT.verSpeed,'.','color',colors{c})
            hold on
            
            subplot(2,5,c+5)
            plot(flip(currT.verSpeed),'.','color',colors{c})
            hold on
            
            varSpeed(t,1:size(currT.verSpeed,2))=currT.verSpeed;
            varSpeed_rev(t,1:size(currT.verSpeed,2))=flip(currT.verSpeed);
            
%             figure(4) % xcorr peaks
%             for f=1:size(currT.xcorrSA_max,2)
%                 f_rev=size(currT.xcorrSA_max,2)-f+1;
%                 subplot(2,5,c)
%                 plot(currT.xcorrSA_max{1,f},f*ones(size(currT.xcorrSA_max{1,f})),'.','color',colors{c})
%                 peakXcorr{f}=[peakXcorr{f} currT.xcorrSA_max{1,f}];
%                 hold on
%                 ylabel('fixation number from trial start')
%                 xlabel('time lags from fixation onset [ms]')
%                 subplot(2,5,c+5)
%                 plot(currT.xcorrSA_max{1,f},f_rev*ones(size(currT.xcorrSA_max{1,f})),'.','color',colors{c})
%                 peakXcorr_rev{f_rev}=[peakXcorr_rev{f_rev} currT.xcorrSA_max{1,f}];
%                 hold on
%                 ylabel('reversed fixation number from trial end')
%                 xlabel('time lags from fixation onset [ms]')
%             end
%             title('Xcorr Activation-Speed peaks')
%             
%             figure(5) % fft xcorr peaks
%             for f=1:size(currT.xcorrSAfft_max,2)
%                 f_rev=size(currT.xcorrSAfft_max,2)-f+1;
%                 subplot(2,5,c)
%                 plot(currT.xcorrSAfft_max{1,f},f*ones(size(currT.xcorrSAfft_max{1,f})),'.','color',colors{c})
%                 peakfftXcorr{f}=[peakfftXcorr{f} currT.xcorrSAfft_max{1,f}];
%                 hold on
%                 ylabel('fixation number from trial start')
%                 xlabel('freq lags from fixation onset [Hz]')
%                 subplot(2,5,c+5)
%                 plot(currT.xcorrSAfft_max{1,f},f_rev*ones(size(currT.xcorrSAfft_max{1,f})),'.','color',colors{c})
%                 peakfftXcorr_rev{f_rev}=[peakfftXcorr_rev{f_rev} currT.xcorrSAfft_max{1,f}];
%                 hold on
%                 ylabel('reversed fixation number from trial end')
%                 xlabel('freq lags from fixation onset [Hz]')
%             end
%             title('Xcorr fft(Activation-Speed) peaks')
            
        end
        
    end
    %1
    numOfinfoRec=numOfinfoRec(:,sum(isnan(numOfinfoRec))<size(numOfinfoRec,1)-9);
    numOfinfoRec_rev=numOfinfoRec_rev(:,sum(isnan(numOfinfoRec_rev))<size(numOfinfoRec_rev,1)-9);
    %2
    infoPerRec=infoPerRec(:,sum(isnan(infoPerRec))<size(infoPerRec,1)-9);
    infoPerRec_rev=infoPerRec_rev(:,sum(isnan(infoPerRec_rev))<size(infoPerRec_rev,1)-9);
    %3
    targetSpeed=targetSpeed(:,sum(isnan(targetSpeed))<size(targetSpeed,1)-9);
    targetSpeed_rev=targetSpeed_rev(:,sum(isnan(targetSpeed_rev))<size(targetSpeed_rev,1)-9);
    %8
    insAct_Speed=insAct_Speed(:,sum(isnan(insAct_Speed))<size(insAct_Speed,1)-9);
    insAct_Speed_rev=insAct_Speed_rev(:,sum(isnan(insAct_Speed_rev))<size(insAct_Speed_rev,1)-9);
    %20
    varInfoPerRec=varInfoPerRec(:,sum(isnan(varInfoPerRec))<size(varInfoPerRec,1)-9);
    varInfoPerRec_rev=varInfoPerRec_rev(:,sum(isnan(varInfoPerRec_rev))<size(varInfoPerRec_rev,1)-9);
    %30
    varSpeed=varSpeed(:,sum(isnan(varSpeed))<size(varSpeed,1)-9);
    varSpeed_rev=varSpeed_rev(:,sum(isnan(varSpeed_rev))<size(varSpeed_rev,1)-9);
    %6
    ampFixation=ampFixation(:,sum(isnan(ampFixation))<size(ampFixation,1)-9);
    ampFixation_rev=ampFixation_rev(:,sum(isnan(ampFixation_rev))<size(ampFixation_rev,1)-9);
    %7
    distFixation=distFixation(:,sum(isnan(distFixation))<size(distFixation,1)-9);
    distFixation_rev=distFixation_rev(:,sum(isnan(distFixation_rev))<size(distFixation_rev,1)-9);
%     %4
%     for f=1:size(peakXcorr,1)
%         if size(peakXcorr{f},2)<10
%             peakXcorr{f}=nan;
%         end
%         if size(peakXcorr_rev{f},2)<10
%             peakXcorr_rev{f}=nan;
%         end
%     end
%     %5
%     for f=1:size(peakfftXcorr,1)
%         if size(peakfftXcorr{f},2)<10
%             peakfftXcorr{f}=nan;
%         end
%         if size(peakfftXcorr_rev{f},2)<10
%             peakfftXcorr_rev{f}=nan;
%         end
%     end
%     
    figure(1)
    subplot(2,5,c)
    plot(nanmean(numOfinfoRec),'color',colors{c})
    
    subplot(2,5,c+5)
    plot(nanmean(numOfinfoRec_rev),'color',colors{c})
    
    subplot(2,5,5)
    errorbar(nanmean(numOfinfoRec),nanstd(numOfinfoRec)./sum(~isnan(numOfinfoRec),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Number of informative receptors')
    if c==4
        legend(folders)
    end
    
    subplot(2,5,10)
    errorbar(nanmean(numOfinfoRec_rev),nanstd(numOfinfoRec_rev)./sum(~isnan(numOfinfoRec_rev),1),'color',colors{c})
    hold on
    plot(13,nanmean(numOfinfoRec(:)),'*','color',colors{c})
    plot(13,nanmean(numOfinfoRec_rev(:)),'*','color',colors{c})
    xlabel('reversed fixation number from trial end')
    
    figure(2)
    subplot(2,5,c)
    plot(nanmean(infoPerRec),'color',colors{c})
    
    subplot(2,5,c+5)
    plot(nanmean(infoPerRec_rev),'color',colors{c})
    
    subplot(2,5,5)
    errorbar(nanmean(infoPerRec),nanstd(infoPerRec)./sum(~isnan(infoPerRec),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Mean receptors activation')
    if c==4
        legend(folders)
    end
    
    subplot(2,5,10)
    errorbar(nanmean(infoPerRec_rev),nanstd(infoPerRec_rev)./sum(~isnan(infoPerRec_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    figure(3)
    subplot(2,5,c)
    plot(nanmean(targetSpeed),'color',colors{c})
    
    subplot(2,5,c+5)
    plot(nanmean(targetSpeed_rev),'color',colors{c})
    
    subplot(2,5,5)
    errorbar(nanmean(targetSpeed),nanstd(targetSpeed)./sum(~isnan(targetSpeed),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Target eye-Speed')
    if c==4
        legend(folders)
    end
    
    subplot(2,5,10)
    errorbar(nanmean(targetSpeed_rev),nanstd(targetSpeed_rev)./sum(~isnan(targetSpeed_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    figure(6)
    subplot(2,5,c)
    plot(nanmean(ampFixation),'color',colors{c})
    
    subplot(2,5,c+5)
    plot(nanmean(ampFixation_rev),'color',colors{c})
    
    subplot(2,5,5)
    errorbar(nanmean(ampFixation),nanstd(ampFixation)./sum(~isnan(ampFixation),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Fixation Amplitude')
    if c==4
        legend(folders)
    end
    
    subplot(2,5,10)
    errorbar(nanmean(ampFixation_rev),nanstd(ampFixation_rev)./sum(~isnan(ampFixation_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    figure(7)
    subplot(2,5,c)
    plot(nanmean(distFixation),'color',colors{c})
    
    subplot(2,5,c+5)
    plot(nanmean(distFixation_rev),'color',colors{c})
    
    subplot(2,5,5)
    errorbar(nanmean(distFixation),nanstd(distFixation)./sum(~isnan(distFixation),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Fixation Distance')
    if c==4
        legend(folders)
    end
    
    subplot(2,5,10)
    errorbar(nanmean(distFixation_rev),nanstd(distFixation_rev)./sum(~isnan(distFixation_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    figure(8)
    subplot(2,5,c)
    plot(nanmean(insAct_Speed),'color',colors{c})
    
    subplot(2,5,c+5)
    plot(nanmean(insAct_Speed_rev),'color',colors{c})
    
    subplot(2,5,5)
    errorbar(nanmean(insAct_Speed),nanstd(insAct_Speed)./sum(~isnan(insAct_Speed),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('final insAct/Speed')
    if c==4
        legend(folders)
    end
    
    subplot(2,5,10)
    errorbar(nanmean(insAct_Speed_rev),nanstd(insAct_Speed_rev)./sum(~isnan(insAct_Speed_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    
    figure(13)
    subplot(2,5,5)
    hold on
    rs13(rs13==0)=nan;
    errorbar(nanmean(rs13),nanstd(rs13)./sum(~isnan(rs13),1),'color',colors{c})
    xlabel('fixation lag from trial start')
    title('Xcorr recNum-speed')
    if c==4
        legend(folders)
    end
    subplot(2,5,10)
    hold on
    rs13_rev(rs13_rev==0)=nan;
    errorbar(nanmean(rs13_rev),nanstd(rs13_rev)./sum(~isnan(rs13_rev),1),'color',colors{c})
    xlabel('fixation lag from trial start')
    xlabel('reversed fixation number from trial end')
    title('Xcorr recNum-speed rev')
    
    figure(16)
    subplot(2,5,5)
    hold on
    rs16(rs16==0)=nan;
    errorbar(nanmean(rs16),nanstd(rs16)./sum(~isnan(rs16),1),'color',colors{c})
    xlabel('fixation lag from trial start')
    title('Xcorr recNum-amp')
    if c==4
        legend(folders)
    end
    subplot(2,5,10)
    hold on
    rs16_rev(rs16_rev==0)=nan;
    errorbar(nanmean(rs16_rev),nanstd(rs16_rev)./sum(~isnan(rs16_rev),1),'color',colors{c})
    xlabel('reversed fixation lag from trial end')
    title('Xcorr recNum-amp rev')
    
    figure(17)
    subplot(2,5,5)
    hold on
    rs17(rs17==0)=nan;
    errorbar(nanmean(rs17),nanstd(rs17)./sum(~isnan(rs17),1),'color',colors{c})
    xlabel('fixation lag from trial start')
    title('Xcorr recNum-dist')
    if c==4
        legend(folders)
    end
    subplot(2,5,10)
    hold on
    rs17_rev(rs17_rev==0)=nan;
    errorbar(nanmean(rs17_rev),nanstd(rs17_rev)./sum(~isnan(rs17_rev),1),'color',colors{c})
    xlabel('reversed fixation lag from trial end')
    title('Xcorr recNum-dist rev')
    
    figure(23)
    subplot(2,5,5)
    hold on
    rs23(rs23==0)=nan;
    errorbar(nanmean(rs23),nanstd(rs23)./sum(~isnan(rs23),1),'color',colors{c})
    xlabel('fixation lag from trial start')
    title('Xcorr act-speed')
    if c==4
        legend(folders)
    end
    subplot(2,5,10)
    hold on
    rs23_rev(rs23_rev==0)=nan;
    errorbar(nanmean(rs23_rev),nanstd(rs23_rev)./sum(~isnan(rs23_rev),1),'color',colors{c})
    xlabel('reversed fixation lag from trial end')
    title('Xcorr act-speed rev')
    
    figure(26)
    subplot(2,5,5)
    hold on
    rs26(rs26==0)=nan;
    errorbar(nanmean(rs26),nanstd(rs26)./sum(~isnan(rs26),1),'color',colors{c})
    xlabel('fixation lag from trial start')
    title('Xcorr act-amp')
    if c==4
        legend(folders)
    end
    subplot(2,5,10)
    hold on
    rs26_rev(rs26_rev==0)=nan;
    errorbar(nanmean(rs26_rev),nanstd(rs26_rev)./sum(~isnan(rs26_rev),1),'color',colors{c})
    xlabel('reversed fixation lag from trial end')
    title('Xcorr act-amp rev')
    
    figure(27)
    subplot(2,5,5)
    hold on
    rs27(rs27==0)=nan;
    errorbar(nanmean(rs27),nanstd(rs27)./sum(~isnan(rs27),1),'color',colors{c})
    xlabel('fixation lag from trial start')
    title('Xcorr act-dist')
    if c==4
        legend(folders)
    end
    subplot(2,5,10)
    hold on
    rs27_rev(rs27_rev==0)=nan;
    errorbar(nanmean(rs27_rev),nanstd(rs27_rev)./sum(~isnan(rs27_rev),1),'color',colors{c})
    xlabel('reversed fixation lag from trial end')
    title('Xcorr act-dist rev')
    
    figure(20)
    subplot(2,5,c)
    plot(nanmean(varInfoPerRec),'color',colors{c})
    
    subplot(2,5,c+5)
    plot(nanmean(varInfoPerRec_rev),'color',colors{c})
    
    subplot(2,5,5)
    errorbar(nanmean(varInfoPerRec),nanstd(varInfoPerRec)./sum(~isnan(varInfoPerRec),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Variance receptors activation')
    if c==4
        legend(folders)
    end
    
    subplot(2,5,10)
    errorbar(nanmean(varInfoPerRec_rev),nanstd(varInfoPerRec_rev)./sum(~isnan(varInfoPerRec_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    figure(30)
    subplot(2,5,c)
    plot(nanmean(varSpeed),'color',colors{c})
    
    subplot(2,5,c+5)
    plot(nanmean(varSpeed_rev),'color',colors{c})
    
    subplot(2,5,5)
    errorbar(nanmean(varSpeed),nanstd(varSpeed)./sum(~isnan(varSpeed),1),'color',colors{c})
    hold on
    xlabel('fixation number from trial start')
    title('Variance : eye-Speed')
    if c==4
        legend(folders)
    end
    
    subplot(2,5,10)
    errorbar(nanmean(varSpeed_rev),nanstd(varSpeed_rev)./sum(~isnan(varSpeed_rev),1),'color',colors{c})
    hold on
    xlabel('reversed fixation number from trial end')
    
    for f=1:size(peakXcorr,1)
        if ~isnan(peakXcorr{f})
            figure(40)
            subplot(4,3,f)
            histogram(peakXcorr{f},'FaceColor',colors{c},'FaceAlpha',0.5,'BinEdges',0:50:3000,'Normalization','probability')
            hold on
            if f==1
                xlabel('peak lags of Speed-Activation xcorr [ms]')
                title('From trial begining')
            end
            ylabel(['fixation ' num2str(f) ])
            
        end
        if ~isnan(peakXcorr_rev{f})
            figure(41)
            subplot(4,3,f)
            histogram(peakXcorr_rev{f},'FaceColor',colors{c},'FaceAlpha',0.5,'BinEdges',0:50:3000,'Normalization','probability')
            hold on
            if f==1
                xlabel('peak lags of Speed-Activation xcorr [ms]')
                title('Back from trial end')
            end
            ylabel(['fixation ' num2str(f) ])
        end
    end
    
    for f=1:size(peakfftXcorr,1)
        if ~isnan(peakfftXcorr{f})
            figure(50)
            subplot(4,3,f)
            histogram(peakfftXcorr{f},'FaceColor',colors{c},'FaceAlpha',0.5,'BinEdges',0:5:150,'Normalization','probability')
            hold on
            if f==1
                xlabel('peak lags of Speed-Activation fft xcorr [Hz]')
            end
            ylabel(['fixation ' num2str(f) ])
            title('From trial begining')
        end
        if ~isnan(peakfftXcorr_rev{f})
            figure(51)
            subplot(4,3,f)
            histogram(peakfftXcorr_rev{f},'FaceColor',colors{c},'FaceAlpha',0.5,'BinEdges',0:5:150,'Normalization','probability')
            hold on
            if f==1
                xlabel('peak lags of Speed-Activation fft xcorr [Hz]')
            end
            ylabel(['fixation ' num2str(f) ])
            title('Back from trial end')
        end
    end
    
end




