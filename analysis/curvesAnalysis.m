% curves analysis

clear
close all

curvesType=' Different';% ' Different'  ' Same' all
expType='S'; % S  all
distXs='all'; %1 2 3 4 all

%general parameters:
res=0.01;% 0.01 sec
screen_dis=1;% meter
PIXEL2METER=0.000264583;
doPlot=0; %for sacDiffAmos
do_plot_images=0;

times=zeros(18,4);
temp1=0; temp2=0; temp3=0; temp4=0;
image=[];

for subjects= {'NW', 'AS', 'LS'}; %AS LS NW
    f=fullfile('C:\Users\bnapp\Documents\phd-pre-proposal\analysis\cleanData\', subjects{1,1});
    files = dir(f);
    for file = files'
        if strcmp(file.name,'.')==0 && strcmp(file.name,'..')==0
            currFile = load(file.name);
            % curves Type
            if  strcmp(curvesType,'all')==1 || strcmp(currFile.answer,curvesType)
                % exp Type
                if  strcmp(expType,'all')==1 || strcmp(currFile.fileName(5),expType)
                    % dist Xs
                    if  strcmp(distXs,'all')==1 || strcmp(currFile.PicName(end-4),distXs)
                        
                        %here come the main analysis:
                        screenS=[1080,1920];
                        image=rgb2gray(currFile.myimgfile);
                        SIZE=size(image);
                        image=[ones(floor((screenS(1)- SIZE(1))/2),screenS(2)).*255 ; ones(SIZE(1),floor((screenS(2)-SIZE(2))/2)).*255  , image , ones(SIZE(1),ceil((screenS(2)-SIZE(2))/2)).*255  ; ones( ceil((screenS(1)- SIZE(1))/2),screenS(2)).*255 ];
                        
                        if do_plot_images==1
                            figure()
                            imshow(image)
                            hold on
                            plot(currFile.gazeX,currFile.gazeY)
                            plot(1920/2,1080/2,'.r', 'markersize', 20)
                            zoom(2)
                            title([curvesType '  dist - ' currFile.PicName(end-4)])
                        end
                        
                        % times
                        if str2double(currFile.PicName(end-4))==1
                            temp1=temp1+1;
                            times(temp1,1)=length(currFile.gazeX);
                        end
                        if str2double(currFile.PicName(end-4))==2
                            temp2=temp2+1;
                            times(temp2,2)=length(currFile.gazeX);
                        end
                        if str2double(currFile.PicName(end-4))==3
                            temp3=temp3+1;
                            times(temp3,3)=length(currFile.gazeX);
                        end
                        if str2double(currFile.PicName(end-4))==4
                            temp4=temp4+1;
                            times(temp4,4)=length(currFile.gazeX);
                        end
                        
                    end
                end
            end
        end
    end
end

% times
times=times(1:temp1,:).*10.-1500; %move to msec and minus the fixation time
figure(100)
hold all
plot(1*ones(temp1,1),times(:,1),'.')
plot(2*ones(temp1,1),times(:,2),'.')
plot(3*ones(temp1,1),times(:,3),'.')
plot(4*ones(temp1,1),times(:,4),'.')
plot(1:4, mean(times))
errorbar(1:4, mean(times),std(times)/sqrt(temp1));
title(['Response Time' curvesType ' ' expType])
xlabel('Dist')
ylabel('RT [ms]')
axis([0 5 0 3000])


%%saving all figures withh their titles as names
figHandles = get(0,'Children'); % gets the handles to all open figure

for f = figHandles'
    axesHandle = get(f,'Children'); % get the axes for each figure
    titleHandle = get(axesHandle(1),'Title'); % gets the title for the first (or only) axes)
    text = get(titleHandle,'String'); % gets the text in the title
    saveas(f, text, 'jpg') % save the figure with the title as the file name
end