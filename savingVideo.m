% dbstop in savingVideo at 17 if stopFlag

v = VideoWriter('full_bike.avi');
open(v);
tic
for i=1:size(filt_movie,2)
    for ii=1:size(filt_movie{i},3)
        imshow(filt_movie{i}(:,:,ii))
        hold on
        text(201,201,num2str(i),'FontSize',14,'Color','b')
        hold off
        frame = getframe;
        if size(frame.cdata,1)==202
            break
        end
        writeVideo(v,frame);
        pause(0.00001)
        if KbCheck
            stopFlag=true; 
                end 
        stopFlag=0;
    end
end
toc
close(v);

%colored videos
v = VideoWriter('tree_colors_slow.avi');
v.FrameRate=15;
open(v);
tic
for i=1:size(filt_movie,2)
    for ii=1:size(filt_movie{i},4)
        imshow(filt_movie{i}(:,:,:,ii))
        hold on
        text(201,201,num2str(i),'FontSize',14,'Color','b')
        hold off
        frame = getframe;
        if size(frame.cdata,1)==202
            break
        end
        writeVideo(v,frame);
        pause(0.0001)
        if KbCheck
            stopFlag=true; 
                end 
        stopFlag=0;
    end
end
toc
close(v);