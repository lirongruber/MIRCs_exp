dbstop in savingVideo at 17 if stopFlag

v = VideoWriter('dd.avi');
open(v);
tic
for i=1:size(filt_movie,2)
    for ii=1:size(filt_movie{i},3)
        imshow(filt_movie{i}(:,:,ii))
        hold on
        text(201,201,num2str(i),'FontSize',14,'Color','b')
        hold off
        frame = getframe;
        writeVideo(v,frame);
        pause(0.00001)
        if KbCheck
            stopFlag=true; 
                end 
        stopFlag=0;
    end
end
toc

% text(10,150,'RAZ SHARON-RONEN HAMELECH','FontSize',20,'Color','b')
% frame = getframe;
% for i=1:100
%     writeVideo(v,frame);
% end
close(v);