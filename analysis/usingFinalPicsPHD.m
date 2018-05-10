% after creating finalPics:
close all
currColormap= stermap();
close all
f='C:\Users\bnapp\Documents\phd-pre-proposal-data\ImagesForExp\fullImages\';
% f='C:\Users\bnapp\Documents\phd-pre-proposal-data\ImagesForExp\MIRCs\';
% f='C:\Users\bnapp\Documents\phd-pre-proposal-data\ImagesForExp\subMIRCs\';

% currColormap= jet;

orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane'};
for i=1:10
    orderPicsNames{2,i}=i;
end
IMAGE_SIZE_DEG=3;
PIXEL2METER=0.000264583;
IMAGE_LENGTH_PIX=round(tand(IMAGE_SIZE_DEG/2)/PIXEL2METER*2);
line='\_+';
wW=1920;
wH=1080;
for i=1:length(finalPics)
    final=zeros(size(finalPics{1,1}{1,1}));
    for j=1:length(finalPics{1,i})
        final=final+finalPics{1,i}{1,j};
    end
    m=max(max(final));
    final=final./m;
    VRs{i}=final;
    files = dir(f);
    for file=files';
        temp=regexp(file.name,line,'split');
        temp=temp(1);
        if strcmp(temp,orderPicsNames{1,i})
            imdata=imread([f file.name]);
            imdata=imresize(imdata,[IMAGE_LENGTH_PIX IMAGE_LENGTH_PIX]);
            imdata=[ones(floor((wH- IMAGE_LENGTH_PIX)/2),wW).*255 ; ones(IMAGE_LENGTH_PIX,floor((wW-IMAGE_LENGTH_PIX)/2)).*255  , imdata , ones(IMAGE_LENGTH_PIX,ceil((wW-IMAGE_LENGTH_PIX)/2)).*255  ; ones( ceil((wH- IMAGE_LENGTH_PIX)/2),wW).*255 ];
        break
        end
    end
    figure()
    imshow(VRs{1,i});
    colormap(currColormap);
    hold on
    imdataRGB=ind2rgb(imdata,gray(256));
    h=imshow(imdataRGB);
    hold off
    A=ones(size(imdata));
%     A(VRs{1,i}~=0)=0.5;
    A(VRs{1,i}>0.1)=0.4;
    set(h,'AlphaData',A);
    zoom ON
    zoomcenter(941,545,4)
    zoom OFF
    hold on
    plot(wW/2,wH/2,'+m','LineWidth',1)
        title([ 'full ' orderPicsNames{1,i} ],'Fontsize',36) %'Recognized '
        set(gca,'position',[0 0 1 1],'units','normalized')

%     colorbar
end
tilefigs;



%%saving all figures withh their titles as names
figHandles = get(0,'Children'); % gets the handles to all open figure

for f = figHandles'
    axesHandle = get(f,'Children'); % get the axes for each figure
    titleHandle = get(axesHandle(1),'Title'); % gets the title for the first (or only) axes)
    text = get(titleHandle,'String'); % gets the text in the title
    saveas(f, text, 'jpg') % save the figure with the title as the file name
end