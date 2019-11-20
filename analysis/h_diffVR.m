% after creating finalPics:
% close all
% currColormap= stermap();
currColormap= jet;

% f='C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\fullImages\';
% f='C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\MIRCs\';
f='C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\subMIRCs\';
% f='C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp\refImages\';

orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane','house','mouth','nose'};
line='\_+';
% orderPicsNames={'ref_boat', 'ref_butterfly' , 'ref_camera' , 'ref_chair' , 'ref_cup' , 'ref_elephant','ref_flower','ref_helicopter','ref_lamp','ref_umbrella'};
% line='\.+';

for i=1:length(orderPicsNames)
    orderPicsNames{2,i}=i;
end
IMAGE_SIZE_DEG=3;
PIXEL2METER=0.000264583;
IMAGE_LENGTH_PIX=round(tand(IMAGE_SIZE_DEG/2)/PIXEL2METER*2);

wW=1920;
wH=1080;

% yes=load('OnlyFirst1_Sub1Mirc0Full0Ref0_rec Yessec_FP.mat');
% yes=yes.sec1_finalPics;
% no=load('OnlyFirst1_Sub1Mirc0Full0Ref0_rec Nosec_FP.mat');
% no=no.sec1_finalPics;

yes=load('OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yessec_FP.mat');
yes=yes.sec1_finalPics;
no=load('OnlyFirst1_Sub0Mirc1Full0Ref0_rec Nosec_FP.mat');
no=no.sec1_finalPics;

% yes=load('OnlyFirst1_Sub1Mirc0Full0Ref0_rec Yesfull_FP.mat');
% yes=yes.full_finalPics;
% no=load('OnlyFirst1_Sub1Mirc0Full0Ref0_rec Nofull_FP.mat');
% no=no.full_finalPics;

% yes=load('OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yesfull_FP.mat');
% yes=yes.full_finalPics;
% no=load('OnlyFirst1_Sub0Mirc1Full0Ref0_rec Nofull_FP.mat');
% no=no.full_finalPics;

for i=1:min(length(yes),length(no))
    finalYes=zeros(1080,1920);
    finalNo=zeros(1080,1920);
    for j=1:length(yes{1,i})
        if ~isempty(yes{1,i})
        finalYes=finalYes+yes{1,i}{1,j};
        end
    end
    for j=1:length(no{1,i})
        if ~isempty(no{1,i})
        finalNo=finalNo+no{1,i}{1,j};
        end
    end
    m=max(max(finalYes));
    finalYes=finalYes./m;
    m=max(max(finalNo));
    finalNo=finalNo./m;
    VRs{i}=(finalYes-finalNo)./2+0.5;
    files = dir(f);
    for file=files'
        temp=regexp(file.name,line,'split');
        temp=temp(1);
        if strcmp(temp,orderPicsNames{1,i})
            [imdata,map]=imread([f file.name]);
            if strcmp(line,'\.+')
            imdata=ind2gray(imdata,map);
            end
            imdata=imresize(imdata,[IMAGE_LENGTH_PIX IMAGE_LENGTH_PIX]);
            imdata=[ones(floor((wH- IMAGE_LENGTH_PIX)/2),wW).*255 ; ones(IMAGE_LENGTH_PIX,floor((wW-IMAGE_LENGTH_PIX)/2)).*255  , imdata , ones(IMAGE_LENGTH_PIX,ceil((wW-IMAGE_LENGTH_PIX)/2)).*255  ; ones( ceil((wH- IMAGE_LENGTH_PIX)/2),wW).*255 ];
        break
        end
    end
    figure(i)
    imshow(VRs{i},'colormap',currColormap);
    hold on
    imdataRGB=ind2rgb(imdata,gray(256));
    h=imshow(imdataRGB);
    hold off
    A=ones(size(imdata))*0.6;
    set(h,'AlphaData',A);
    zoom ON
    zoomcenter(941,545,4)
    zoom OFF
    hold on
    plot(wW/2,wH/2,'+m','LineWidth',1)
    title(['YES(' num2str(length(yes{1,i})) ')-NO(' num2str(length(no{1,i})) ')'],'Fontsize',20) %'Recognized '
%     colorbar
% saveppt('examples.ppt')
end
% tilefigs;

% %%saving all figures withh their titles as names
% figHandles = get(0,'Children'); % gets the handles to all open figure
% 
% for f = figHandles'
%     axesHandle = get(f,'Children'); % get the axes for each figure
%     titleHandle = get(axesHandle(1),'Title'); % gets the title for the first (or only) axes)
%     text = get(titleHandle,'String'); % gets the text in the title
%     saveas(f, text, 'jpg') % save the figure with the title as the file name
% end