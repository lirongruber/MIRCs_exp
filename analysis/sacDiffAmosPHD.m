% call Amos function with my DATA:
function [imdata,chan_h_pix,chan_v_pix,chan_h, chan_v,saccade_vec, n] =sacDiffAmosPHD(NamePic,gazeX,gazeY,imdata,doPlot)
PIXEL2METER=0.000264583;


chan_h_pix=gazeX;
chan_v_pix=gazeY;
% translating to degrees
mid=size(imdata)./2;
chan_h=(chan_h_pix-mid(2));
chan_v=(chan_v_pix-mid(1));
chan_h=atand(chan_h.*PIXEL2METER);
chan_v=atand(chan_v.*PIXEL2METER);

% Parameters for Fried's function for identifying saccaddes
amp_min = 0.0; % minimal amplitude in degrees
amp_max = 0.0; % maximal amplitude in degrees
eyetrack_menu_parameters.saccademinamp = 0.3; % 8 deg
eyetrack_menu_parameters.saccademaxamp = 30; % 30 deg
eyetrack_menu_parameters.minimumvelocity = 8; %4  deg/sec
eyetrack_menu_parameters.averagevelocity = 6; % 8 deg/sec
eyetrack_menu_parameters.peakvelocity = 16; %8  deg/sec
eyetrack_menu_parameters.intrussionrange = 300; % 300 msec
eyetrack_menu_parameters.mergeovershoot = 1; % 1 - mergeovershoot
eyetrack_menu_parameters.mergeintrussions = 0; % 1 - mergeintrussions

rate=100; % Sample-Rate in Hz of the eye-Tracker : 0.01 msec, Hz=100;

[saccade_vec, n] = eyetrack_find_saccadesRevAmos( chan_h, chan_v, rate, eyetrack_menu_parameters, amp_min, amp_max);
saccade_vec=[[0;0;0] saccade_vec];
% Htmp = HeyeM(IndxTrials1Cond1Part{i,j,:},TstatBgn:TstatEnd)';
% HtmpNoNaN(:,o) = Htmp(:,o);
% [saccade_vec, n] = eyetrack_find_saccadesRevAmos( HtmpNoNaN(:,o), zeros(size(Htmp(:,o))), SmplRate, eyetrack_menu_parameters, amp_min, amp_max);

%ploting:
if doPlot==1
    figure()%(sessionNum(i))
    numOfSacc=find(saccade_vec(1,:));
    numOfSacc=numOfSacc(end);
    imshow(imdata)
    hold on
            for i=1:numOfSacc
                plot (chan_h_pix(saccade_vec(1,i):saccade_vec(2,i)+saccade_vec(1,i)),chan_v_pix(saccade_vec(1,i):saccade_vec(2,i)+saccade_vec(1,i)),'c','LineWidth',1.5)
            end
    
    for i=1:numOfSacc-1
        plot (chan_h_pix(saccade_vec(2,i)+saccade_vec(1,i):saccade_vec(1,i+1)),chan_v_pix(saccade_vec(2,i)+saccade_vec(1,i):saccade_vec(1,i+1)),'b','LineWidth',1.5)
    end
    plot (chan_h_pix(saccade_vec(2,numOfSacc)+saccade_vec(1,numOfSacc):end),chan_v_pix(saccade_vec(2,numOfSacc)+saccade_vec(1,numOfSacc):end),'b','LineWidth',1.5)
                            zoom(20)
title([NamePic '-saccades&drift'])
%     figure(2)
%     plot(chan_h)
%     hold on
%     figure(3)
%     plot(chan_v)
%     hold on
%     for i=1:numOfSacc
%         figure(2)
%         temp1=zeros(size(chan_h));
%         temp1(saccade_vec(1,i):saccade_vec(2,i)+saccade_vec(1,i))=chan_h(saccade_vec(1,i):saccade_vec(2,i)+saccade_vec(1,i));
%         temp1(temp1==0)=nan;
%         plot(temp1,'r');
%         figure(3)
%         temp2=zeros(size(chan_v));
%         temp2(saccade_vec(1,i):saccade_vec(2,i)+saccade_vec(1,i))=chan_v(saccade_vec(1,i):saccade_vec(2,i)+saccade_vec(1,i));
%         temp2(temp2==0)=nan;
%         plot(temp2,'r');
%     end
    
end
end