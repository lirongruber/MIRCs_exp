function [movie,filt_movie]=retinalMovieCreator_3D(im3D,ALLcurrXY,retinal_locations_Xpix,retinal_locations_Ypix,retinal_RFs_pix,t_filter,movieFlag)

% Raz's suggestion
retinal_RFs_pix=ceil(retinal_RFs_pix);
N=unique(retinal_RFs_pix);
c=0;
movie=zeros([size(retinal_locations_Xpix),3,size(ALLcurrXY,2)]);
for im={im3D(:,:,1) im3D(:,:,2) im3D(:,:,3) }
    im=im{1,1};
    c=c+1;
    for numMean=N'
        M{numMean}=conv2(im,ones(numMean,numMean)./numMean^2,'same');
    end
    sacc_t=[];
    for f=1:size(ALLcurrXY,2)
        currXY= ceil(ALLcurrXY(:,f));
        retinal_image=0.5.*ones(size(retinal_locations_Xpix));
        currXLocations=(currXY(1)+retinal_locations_Xpix);
        currYLocations=(currXY(2)+retinal_locations_Ypix);
        if ~isnan(currXY(1)) && max(currXLocations(:))<1980 && max(currYLocations(:))<1020 && min(currXLocations(:))>1 && min(currYLocations(:))>1
            idx = sub2ind(size(im), currYLocations, currXLocations);
            for j = 1:length(N)
                retinal_image = retinal_image + M{N(j)}(idx).*((retinal_RFs_pix)==N(j));
            end
            movie(:,:,c,f) = retinal_image;
        else
            movie(:,:,c,f) = retinal_image;
            sacc_t=[sacc_t f];
        end
    end
end

%  SHOWING MOVIE BEFORE TIME FILTER
if movieFlag==1
    figure()
    tic
    for i=1:size(movie,4)
        imshow(movie(:,:,:,i))
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
for c=1:3
    curr=[0 sacc_t size(movie,4)+1];
    rel_m=0;
    curr_movie=movie(:,:,c,:);
    curr_movie=reshape(curr_movie,[402 402 size(movie,4)]);
    for num_m=1:size(curr,2)-1
        if size(curr(num_m)+1:curr(num_m+1)-1,2)>3
            rel_m=rel_m+1;
            filt_movie{1,rel_m}(:,:,c,:)=filter(t_filter,1,curr_movie(:,:,curr(num_m)+1:curr(num_m+1)-1),[],3);
            filt_movie{2,rel_m}=[curr(num_m)+1 curr(num_m+1)-1];
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
%         figure
%         pause(0.5)
        for ii=1:size(filt_movie{1,i},4)
            imshow(filt_movie{1,i}(:,:,:,ii))
            hold on
            plot(201,201,'b*','MarkerSize',1)
            hold off
            pause(0.00001)
            
        end
    end
    toc
end

end