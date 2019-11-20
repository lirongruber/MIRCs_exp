% load mov##.mat
close all

tic
count=0;
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:size(filt_movie,2)
    subplot(1,size(filt_movie,2),i)
%     figure(i)
    for ii=1:size(filt_movie{1,i},3)
        count=count+1;
        imshow(filt_movie{1,i}(:,:,ii))
        hold on
        plot(201,201,'b*','MarkerSize',1)
        hold off
        pause(0.00001)
        
    end
end
toc      