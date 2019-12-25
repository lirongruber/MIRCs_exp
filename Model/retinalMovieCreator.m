function [movie,filt_movie]=retinalMovieCreator(im,ALLcurrXY,retinal_locations_Xpix,retinal_locations_Ypix,retinal_RFs_pix,t_filter,movieFlag)

% Raz's suggestion
retinal_RFs_pix=ceil(retinal_RFs_pix);
N=unique(retinal_RFs_pix);
for numMean=N'
    M{numMean}=conv2(im,ones(numMean,numMean)./numMean^2,'same');
end
movie=zeros([size(retinal_locations_Xpix),size(ALLcurrXY,2)]);
sacc_t=[];
for f=1:size(ALLcurrXY,2)
    currXY= ceil(ALLcurrXY(:,f));
    retinal_image=0.5.*ones(size(retinal_locations_Xpix));
    currXLocations=(currXY(1)+retinal_locations_Xpix);
    currYLocations=(currXY(2)+retinal_locations_Ypix);
    if ~isnan(currXY(1)) && max(currXLocations(:))<1980 && max(currYLocations(:))<1020 && min(currXLocations(:))<1 && min(currYLocations(:))<1
        idx = sub2ind(size(im), currYLocations, currXLocations);
        for j = 1:length(N)
            retinal_image = retinal_image + M{N(j)}(idx).*((retinal_RFs_pix)==N(j));
        end
        movie(:,:,f) = retinal_image;
    else
        movie(:,:,f) = retinal_image;
        sacc_t=[sacc_t f];
    end
end

%  SHOWING MOVIE BEFORE TIME FILTER
if movieFlag==1
    figure()
    tic
    for i=1:size(movie,3)
        imshow(movie(:,:,i))
        if sum(ismember(sacc_t,i))
            hold on
            plot(201,201,'b*','MarkerSize',1)
            pause(0.008)
            hold off
        end
        pause(0.0001)
    end
    toc
end
% time filtering
curr=[0 sacc_t size(movie,3)+1];
rel_m=0;
for num_m=1:size(curr,2)-1
    rel_m=rel_m+1;
    filt_movie{1,rel_m}=filter(t_filter,1,movie(:,:,curr(num_m)+1:curr(num_m+1)-1),[],3);
    filt_movie{2,rel_m}=[curr(num_m)+1 curr(num_m+1)-1];
    if size(filt_movie{1,rel_m},3)<4
        rel_m=rel_m-1;
        if num_m==size(curr,2)-1
            filt_movie=filt_movie(:,1:end-1);
            break;
        end
    end
end

% SHOWING MOVIE AFTER TIME FILTER
if movieFlag==1
    %     figure()
    %     figure('units','normalized','outerposition',[0 0 1 1])
    tic
    for i=1:size(filt_movie,2)
        %         subplot(1,size(filt_movie,2),i)
        figure
        pause(0.5)
        for ii=1:size(filt_movie{1,i},3)
            imshow(filt_movie{1,i}(:,:,ii))
            hold on
            plot(201,201,'b*','MarkerSize',1)
            hold off
            pause(0.00001)
            
        end
    end
    toc
end

end