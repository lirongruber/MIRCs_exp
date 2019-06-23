
clear
close all
paramNames = {'luminance - mean(im)','global contrast - std(im)','local contrast - mean(localStd)','gradient - mean(diff(im)))','gradient X/1000','gradient Y/1000'};
groupTitle={'MIRCs', 'subMIRCs'};
% paramNames2 ={'lower freq','high freq'};

mircsIm=dir('C:\Users\bnapp\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\MIRCs');
subIm=dir('C:\Users\bnapp\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\subMIRCs');
for group=1:2
    for i=1:size(mircsIm,1)-2
        if group==1
            im_i=imread([mircsIm(i+2).folder '\' mircsIm(i+2).name]);
            subplot_i=1:3;
        else
            im_i=imread([subIm(i+2).folder '\' subIm(i+2).name]);
            subplot_i=4:6;
        end
        im_gray =im_i;
        %
        luminance(group,i) = mean(im_gray(:));
        %     luminance(im_i) = sum(gray(:).^2);
        %
        rms_contrast(group,i) = std(double(im_gray(:)));
        loc_contrast= stdfilt(im_gray,ones(5));
        mean_loc_contrast(group,i) = mean(loc_contrast(:));
        %     mean_loc_contrast(i) = sum(loc_contrast(:).^2);
        
        %
        [Gmag,Gdir] = imgradient(im_gray);
        [Gx,Gy] = imgradientxy(im_gray);
        grad_mag(group,i) = mean(Gmag(:).^2);
        grad_magX(group,i) = mean(Gx(:).^2);
        grad_magY(group,i) = mean(Gy(:).^2);
        
        %
        %     s=size(im_gray,1);
        %     xVals = ceil(s/2):s;
        %     yVals = 2:floor(s/2);
        %     s=min(size(xVals,2),size(yVals,2));
        %
        %     spat = abs(fftshift(fft2(im_gray)));
        %     [maxVal,maxIdx] = max(spat(:));
        %     spat(spat==maxVal) = 0;
        %
        %     lower_freq = spat(yVals(end-min(s-1,5)):yVals(end),xVals(1):xVals(min(s-1,5)+1));
        %     all_freq = spat(yVals,xVals);
        %     low_freq_sum(group,i) = sum(lower_freq(:));
        %     high_freq_sum(group,i) = sum(all_freq(:))-low_freq_sum(group,i) ;
        %     freq_ratio(group,i) = high_freq_sum(group,i)/low_freq_sum(group,i);
    end
    
    paramMatrix{group} = [luminance(group,:) ; rms_contrast(group,:);  mean_loc_contrast(group,:)  ;  ...
        grad_mag(group,:)./1000  ; grad_magX(group,:)./1000  ; grad_magY(group,:)./1000];
    %     paramMatrix2{group} = [ grad_mag(group,:)  ; grad_magX(group,:)  ; grad_magY(group,:) ];
    %     paramMatrix3{group} = [ low_freq_sum(group,:)  ; high_freq_sum(group,:) ];
    
    figure(1)
    subplot(3,1,group)
    bar(paramMatrix{group})
    set(gca, 'XTick', 1:6, 'XTickLabel', paramNames,'Fontsize',12);
    axis([0 7 0 250 ])
    title(groupTitle{group})
    if group==1
        legend(mircsIm(3:15).name)
    else
        legend(subIm(3:15).name)
    end
    
    
    %     bar(paramMatrix2{group})
    %     set(gca, 'XTick', 1:2, 'XTickLabel', paramNames2,'Fontsize',12);
    %     axis([0 3 0 2*10^5])
end

diff_paramMatrix=(paramMatrix{1}-paramMatrix{2})./((paramMatrix{1}+paramMatrix{2})/2);
% diff_paramMatrix2=(paramMatrix2{1}-paramMatrix2{2})./((paramMatrix2{1}+paramMatrix2{2})/2);
subplot(3,1,3)
bar(diff_paramMatrix);
set(gca, 'XTick', 1:6, 'XTickLabel', paramNames,'Fontsize',12);
axis([0 7 -1 1 ])
title('DIFF = (p1-p2)/((p1+p2)/2)')
% bar(diff_paramMatrix2);
% set(gca, 'XTick', 1:3, 'XTickLabel', paramNames2,'Fontsize',12);
% axis([0 3 -1.7 1.7])