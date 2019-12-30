%% receptors locations and receptive fields sizes (degrees) +time filter
% distance between receptors in fovea (pytkov,sompolinsky 2007+roorda 2002)
% distance between receptors at 4deg eccentricity (roorda 2002)
% time filter from Sompolinsky Meiser Plos 2007

IMAGE_SIZE_DEG=3;
PIXEL2METER=0.000264583;
screenS=[1020,1980];

IMAGE_LENGTH_PIX=round(tand(IMAGE_SIZE_DEG/2)/PIXEL2METER*2);
PixelsInDeg=IMAGE_LENGTH_PIX/IMAGE_SIZE_DEG;

% time parameters
T1=5;
T2=15;
n=3;
R=0.8;

distRecInDeg_Fov=0.5/60; % distance between receptors in fovea (pytkov,sompolinsky 2007+roorda 2002)
distRecInDeg_4deg=1.6/60; % distance between receptors at 4deg eccentricity (roorda 2002)
% assuming linear increase...
slope=(distRecInDeg_4deg-distRecInDeg_Fov)/(4-0);
final_dist=3; % to have a "six degrees retina"
for diff_x=0.1:-0.001:0
    x=0:diff_x:3;
    y=distRecInDeg_Fov+slope.*x;
    if abs(3-sum(y))< final_dist
        final_dist=abs(3-sum(y));
        final_dif=diff_x;
        final_y=y;
    end
end
% locations
retinal_vec= [-flip(cumsum(final_y)) cumsum(final_y)] ;
[retinal_Xlocations,retinal_Ylocations] = meshgrid(retinal_vec);
%receptive fields - assuming increase linearly inverse to the distance - can change
retinal_vec=[-flip(final_y) final_y];
[XX,YY] = meshgrid(retinal_vec);
retinal_RFs = sqrt(XX.^2+YY.^2);


retinal_locations_Xpix=ceil(PixelsInDeg.*retinal_Xlocations);
retinal_locations_Ypix=ceil(PixelsInDeg.*retinal_Ylocations);
retinal_RFs_pix=ceil(PixelsInDeg.*retinal_RFs);

% time filter from Sompolinsky Meiser Plos 2007
t=0:1:100;
t_filter=(t.^n/T1^(n+1)).*exp(-t./T1)-R.*(t.^n/T2^(n+1)).*exp(-t./T2);
t_filter=t_filter./max(t_filter);
% h_r=(t.^n/T2^(n+1)).*exp(-t./T2)-R.*(t.^n/T1^(n+1)).*exp(-t./T1);
% h_r=h_r./sum(h_r);

%figure()
%plot(t-100,flip(t_filter))
%hold all
% % plot(t,flip(h_r))
% plot([-100 0],[0 0])
 %xlabel('time [ms]')
paths={...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\MIRCs_yes';
    'C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\MIRCs_no';
    'C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\subMIRCs_yes';
    'C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\subMIRCs_no';
    };
paths=paths';

folders={...
    'MIRCs_yes';
    'MIRCs_no';
    'subMIRCs_yes';
    'subMIRCs_no';
    };
for cond=4%1:4
    currpath=paths{cond};
    movNum=0;
    files = dir(currpath);
    files=files(3:end);
    for file = files'
        load(file.name);
        rel_im=imresize(myimgfile,[IMAGE_LENGTH_PIX IMAGE_LENGTH_PIX]);
        im=256.*ones(screenS);
        im(screenS(1)/2-IMAGE_LENGTH_PIX/2:screenS(1)/2+IMAGE_LENGTH_PIX/2-1,screenS(2)/2-IMAGE_LENGTH_PIX/2:screenS(2)/2+IMAGE_LENGTH_PIX/2-1)=...
            rel_im;
        im=im./256;
        % %         % 100 Hz filter
        % %          tempX_filtered = sgolayfilt(gazeX,1,11);
        % %          tempY_filtered = sgolayfilt(gazeY,1,11);
        % sacc removel
        rate=250;% 250 Hz
        filterFlag=1; % !!!
        plotFlag=0;
        [chan_h_pix,chan_v_pix,chan_h_deg, chan_v_deg,saccade_vec, n] =paramsForSaccDetection(plotFlag,im,[gazeX ; gazeY],rate,filterFlag);
        tempX_filtered= chan_h_pix;
        tempY_filtered=chan_v_pix;
        for i=1:size(saccade_vec,2)
            tempX_filtered(saccade_vec(1,i):saccade_vec(1,i)+saccade_vec(2,i)-1)=nan;
            tempY_filtered(saccade_vec(1,i):saccade_vec(1,i)+saccade_vec(2,i)-1)=nan;
        end
        chan_h_deg(isnan(tempX_filtered))=nan;
        chan_v_deg(isnan(tempY_filtered))=nan;
        
        final_rate=125;
        ALLcurrXY_deg=[chan_h_deg(500:rate/final_rate:end) ; chan_v_deg(500:rate/final_rate:end)];
        ALLcurrXY=[ tempX_filtered(500:rate/final_rate:end) ; tempY_filtered(500:rate/final_rate:end) ];
        DS_t_filter=t_filter(1:1000/rate:end);
        DS_t_filter=DS_t_filter(1:rate/final_rate:end);
        DS_t_filter=DS_t_filter./max(DS_t_filter);
        movieFlag=0;
        [movie,filt_movie]=retinalMovieCreator(im,ALLcurrXY,retinal_locations_Xpix,retinal_locations_Ypix,retinal_RFs_pix,DS_t_filter,movieFlag);
        
        movNum=movNum+1;
        disp(movNum)
        details.XY=ALLcurrXY;
        details.XYdeg=ALLcurrXY_deg;
        details.category=folders{cond};
        details.imageName=PicName;
        save(['C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\videos\' folders{cond} '\mov' num2str(movNum) ], 'movie','filt_movie','details');
        
    end
end