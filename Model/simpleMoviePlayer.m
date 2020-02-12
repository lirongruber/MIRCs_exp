% load mov+mov_r##.mat
close all

% %for saving .avi :
% v = VideoWriter('new_r.avi');
% open(v);
% %

figure('units','normalized','outerposition',[0 0 1 1])
tic
for i=1:size(filt_movie,2)
    
    for ii=1:size(rel_movie_notCorr{1,i},3)
        %         subplot(1,size(filt_movie,2),i)
        %     figure('units','normalized','outerposition',[0 0 1 1])
        imshow([filt_movie{1,i}(:,:,ii) rel_movie_notCorr{1,i}(:,:,ii)+1])
        hold on
        plot(201,201,'b*','MarkerSize',1)
        plot(601,201,'b*','MarkerSize',1)
        hold off
        
%         % for saving .avi :
%         frame = getframe;
%         writeVideo(v,frame);
%         %
        
        pause(0.01)
        
    end
end
%         % for saving .avi :
% close(v);
%         %

toc