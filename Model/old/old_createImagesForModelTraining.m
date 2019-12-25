% Creating motor-sensory dynamical "image" of a trial for model training
% clear
% close all

ms=50;% 0 is counting pixel pixel
timeInTrial=3000;

wW=1920;
wH=1080;
screenS=[wH,wW];
paths={...
    'C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\MIRCs_yes';
    'C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\MIRCs_no';
    'C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\subMIRCs_yes';
    'C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\subMIRCs_no';
    };
paths=paths';

folders={...
    'MIRCs_yes';
    'MIRCs_no';
    'subMIRCs_yes';
    'subMIRCs_no';
    };
for cond=1:4
    currpath=paths{cond};
    movNum=0;
    files = dir(currpath);
    files=files(3:end);
    for file = files'
        load(file.name);
        SIZE=size(myimgfile);
        image=[ones(floor((screenS(1)- SIZE(1))/2),screenS(2)).*255 ; ones(SIZE(1),floor((screenS(2)-SIZE(2))/2)).*255  , myimgfile , ones(SIZE(1),ceil((screenS(2)-SIZE(2))/2)).*255  ; ones( ceil((screenS(1)- SIZE(1))/2),screenS(2)).*255 ];
        
        finalTrial=zeros(ms,ms,timeInTrial);
        for i=1:1:timeInTrial
            currx= gazeX(i+2000);
            curry= gazeY(i+2000);
            myrect=[currx-(ms/2)+1 curry-(ms/2)+1 currx+(ms/2) curry+(ms/2)];
            
            y1=max(1,round(myrect(2))); y1=min(y1,wH);
            y2=max(1,round(myrect(4))); y2=min(y2,wH);
            x3=max(1,round(myrect(1))); x3=min(x3,wW);
            x4=max(1,round(myrect(3))); x4=min(x4,wW);
            
            finalTrial(:,:,i)=image(y1:y2,x3:x4);
%             disp(num2str(i))
        end
        movNum=movNum+1;
        disp(movNum)
        twoDtrial=reshape(finalTrial,[ms^2,timeInTrial]);
        save(['C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\videos\' folders{cond} '\mov' num2str(movNum) ], 'finalTrial')
        
        %% movie
        % count=0;
        % nameOfMovie=['100X100'  '.avi']
        % for i=1:10:length(finalTrial)
        %     count=count+1;
        %     imshow(finalTrial(:,:,count)./255)
        %     F(count)=getframe;
        %     disp(num2str(count))
        %     pause(0.1)
        % end
        %
        %     myVideo = VideoWriter(nameOfMovie);
        %     myVideo.Quality = 100;
        %     myVideo.FrameRate = 100;
        %     open(myVideo);
        %     writeVideo(myVideo, F);
        %     close(myVideo);
        %%
%         figure(1)
%         subplot(1,2,1)
%         hold on
%         imageRGB=ind2rgb(image,gray(256));
%         imshow(imageRGB)
%         x=gazeX(2001:end);
%         y=gazeY(2001:end);
%         z = zeros(size(x));
%         col = 1:length(x);  % This is the color.
%         ho=surface([x;x],[y;y],[z;z],[col;col],...
%             'facecol','no',...
%             'edgecol','interp',...
%             'linew',1);
%         rectangle('Position',[gazeX(2001)-ms/2 gazeY(2001)-ms/2 ms ms])
%         colorbar
%         axis([800, 1100,350,650])
%         
%         subplot(1,2,2)
%         imshow(twoDtrial./255)
%         xlabel('Time [ms]')
%         ylabel('retinal receptor')
        
    end
end