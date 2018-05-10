%images analysis

clear
close all
% expType=0;full images (3 times)
% expType=12; %Local MIRCs
% expType=121; %Local MIRCS fixation
% expType=122; %Local MIRCS stabilized
% expType=123; %Local subMIRCS
%
% currSessions=1; % 2 3 'all'=999
% currExpTypes=0; % 0 12 'all'=999
exp0=[1 2 3]; % [1 2 3] or [0] or [1] - rel session in this exp
exp12=[1 2 3];
exp123=[1 2 3];
exp122=[1 2 3];
Recognition=' Yes'; % ' Yes' ' No' 'Both'

wW=1920;
wH=1080;
nameOfFile=['exp0_' num2str(exp0) '_exp12_' num2str(exp12) '_exp123_' num2str(exp123) '_exp122_' num2str(exp122) 'Recog' Recognition ];
n=strfind(nameOfFile,' ');
nameOfFile(n)=[];

%general parameters:
res=0.01;% 0.01 sec
screen_dis=1;% meter
PIXEL2METER=0.000264583;
doPlot=1; %for sacDiffAmos
do_plot_images=1;
trialTime=3; %sec

orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane'};
for i=1:10
    orderPicsNames{2,i}=i;
end

t=0;
didRecog=zeros(1,1000);
notRecog=zeros(1,1000);
line='\_+';

Exps={0 12 122 123 ; exp0 exp12 exp122 exp123 };
for numOfExpTypes=1:4
    currExp=Exps{1,numOfExpTypes};
    currSession=Exps{2,numOfExpTypes};
    for subjects= {'G ','SL','RV','RB','ML','IS','EH','AR','AK','AH', 'NS'};
        f=fullfile('C:\Users\bnapp\Documents\phd-pre-proposal\analysis\cleanData\MircsData', subjects{1,1});
        files = dir(f);
        for file = files'
            if strcmp(file.name,'.')==0 && strcmp(file.name,'..')==0
                currFile = load(file.name);
                if strcmp(currFile.fileName(1),'G')
                    currFile.fileName=[currFile.fileName(1) ' ' currFile.fileName(2:end)];
                end
                % Session
                if strcmp(currFile.fileName(4),num2str(currSession(1))) || strcmp(currFile.fileName(4),num2str(currSession(2))) || strcmp(currFile.fileName(4),num2str(currSession(3)))
                    %                                 if  currSession==999 || strcmp(currFile.fileName(4),num2str(currSession)) || strcmp(currFile.fileName(3),num2str(currSession))
                    % ExpTYpe
                    if  currFile.expType==currExp
                        % Recognition
                        if strcmp(Recognition,'Both') || strcmp(Recognition,currFile.answer)
                            t=t+1;
                            %here come the main analysis:
                            screenS=[1080,1920];
                            image=currFile.myimgfile;
                            SIZE=size(image);
                            image=[ones(floor((screenS(1)- SIZE(1))/2),screenS(2)).*255 ; ones(SIZE(1),floor((screenS(2)-SIZE(2))/2)).*255  , image , ones(SIZE(1),ceil((screenS(2)-SIZE(2))/2)).*255  ; ones( ceil((screenS(1)- SIZE(1))/2),screenS(2)).*255 ];
                            
                            
                            NamePic=regexp(currFile.PicName,line,'split');
                            NamePic=NamePic{1,1};
                            if strcmp(NamePic,'car')
                                NamePic='cardoor';
                            end
                            if strcmp(NamePic,'glasses')
                                NamePic='eyeglasses';
                            end
                            %                         % SHIFTING THE GAZE BY THE FIXATION PLUS POSSITION
                            %                         diffX=wW/2-currFile.gazeX(151);
                            %                         diffY=wH/2-currFile.gazeY(151);
                            %                         currFile.gazeX=currFile.gazeX+diffX;
                            %                         currFile.gazeY=currFile.gazeY+diffY;
                            %                         %
                            % WITHOUT FIXATION TIME
                            currFile.gazeX=currFile.gazeX(151:end);
                            currFile.gazeY=currFile.gazeY(151:end);
                            %
                            if do_plot_images==1
                                imageRGB=ind2rgb(image,gray(256));
                                figure()
                                hold on
                                h=imshow(imageRGB);
                                x=currFile.gazeX;
                                y=currFile.gazeY;
                                %                             x=currFile.gazeX;
                                %                             y=currFile.gazeY;
                                z = zeros(size(x));
                                col = 1:length(x);  % This is the color.
                                ho=surface([x;x],[y;y],[z;z],[col;col],...
                                    'facecol','no',...
                                    'edgecol','interp',...
                                    'linew',1);
%                                 colorbar
                                zoomcenter(941,545,6)
                                plot(wW/2,wH/2,'+m','LineWidth',1)
                                plot(x(1),y(1),'+r','LineWidth',1)
                                plot(x(150),y(150),'+r','LineWidth',1)
                                set(gca,'position',[0 0 1 1],'units','normalized')

                                
                                %                             plot(currFile.gazeX,currFile.gazeY,'color',colormap)
                                %                             plot(1920/2,1080/2,'.r', 'markersize', 20)
                                %                         zoom(20)
                                title(NamePic)
                            end
                            
                            [imdata,chan_h_pix,chan_v_pix,chan_h, chan_v,saccade_vec, n] =sacDiffAmosPHD(NamePic,currFile.gazeX,currFile.gazeY,image,doPlot);
                            
                            if ~isempty(find(saccade_vec,1))
                                [row ,col]=find(saccade_vec);
                                last=col(end);
                                saccade_vec=saccade_vec(:,1:last);
                                % 1.number of sacc
                                num_of_sacc(t)=length(saccade_vec)-1;
                                % 2. number of saccedes per sec
                                num_of_sacc_per_sec(t)=num_of_sacc(t)./ trialTime;
                                
                                saccade_vecs{t}=saccade_vec;
                                XY_vecs_pix{t}=[chan_h_pix;chan_v_pix];
                                XY_vecs_deg{t}=[chan_h;chan_v];
                                
                                XY_vec_pix=XY_vecs_pix{t};
                                XY_vec_deg=XY_vecs_deg{t};
                                
                                % 5. saccades and drift
                                [saccade_vec,sacc_time_ms,sacc_amp_degrees,sacc_vel_deg2sec,sacc_maxvel_deg2sec]=saccProp(saccade_vec,XY_vec_pix,XY_vec_deg,imdata,res);
                                [saccade_vec,drift_time_ms,drift_dist_degrees,drift_amp_degrees,drift_vel_deg2sec]=driftsPHD(saccade_vec,XY_vec_deg,XY_vec_pix,res,imdata);
                                
                                labeled_saccade_vecs{t}=saccade_vec;
                                saccs_time_ms{t}=sacc_time_ms;
                                saccs_amp_degrees{t}=sacc_amp_degrees;
                                saccs_vel_deg2sec{t}=sacc_vel_deg2sec;
                                saccs_maxvel_deg2sec{t}=sacc_maxvel_deg2sec;
                                drifts_time_ms{t}=drift_time_ms;
                                drifts_amp_degrees{t}=drift_amp_degrees;
                                drifts_vel_deg2sec{t}=drift_vel_deg2sec;
                                drifts_dist_degrees{t}=drift_dist_degrees;
                                
                                %visit rates
                                [finalPic]=visitRatesPHD(XY_vec_pix,imdata);
                                for i=1:length(orderPicsNames)
                                    if strcmp(orderPicsNames{1,i},NamePic)==1
                                        finalPics{i}{t}=finalPic;
                                    end
                                end
                            else
                                XY_vecs_pix{t}=[chan_h_pix;chan_v_pix];
                                XY_vecs_deg{t}=[chan_h;chan_v];
                                XY_vec_pix=XY_vecs_pix{t};
                                XY_vec_deg=XY_vecs_deg{t};
                                [saccade_vec,drift_time_ms,drift_dist_degrees,drift_amp_degrees,drift_vel_deg2sec]=driftsPHD(saccade_vec,XY_vec_deg,XY_vec_pix,res,imdata);
                                [row ,col]=find(saccade_vec);
                                last=col(end);
                                saccade_vec=saccade_vec(:,1:last);
                                labeled_saccade_vecs{t}=saccade_vec;
                                drifts_time_ms{t}=drift_time_ms;
                                drifts_amp_degrees{t}=drift_amp_degrees;
                                drifts_vel_deg2sec{t}=drift_vel_deg2sec;
                                drifts_dist_degrees{t}=drift_dist_degrees;
                                %visit rates
                                [finalPic]=visitRatesPHD(XY_vec_pix,imdata);
                                for i=1:length(orderPicsNames)
                                    if strcmp(orderPicsNames{1,i},NamePic)==1
                                        finalPics{i}{t}=finalPic;
                                    else if strcmp(NamePic,'car')==1
                                            finalPics{i}{t}=finalPic;
                                        else if strcmp(NamePic,'glasses')==1
                                                finalPics{i}{t}=finalPic;
                                            end
                                        end
                                    end
                                end
                            end
                            
                            % answers
                            if strcmp(currFile.answer,' Yes')
                                didRecog(t)=didRecog(t)+1;
                            else
                                notRecog(t)=notRecog(t)+1;
                            end
                            t
                        end
                    end
                end
            end
        end
    end
end
numberOfRelevantTrials=t;
didRecog=didRecog(1:t);
notRecog=notRecog(1:t);
for i=1:length(finalPics)
    if ~isempty(finalPics{i})
        finalPics{i}=finalPics{i}(~cellfun('isempty',finalPics{i}));
    end
end
%% saving

SavingFile=['C:\Users\bnapp\Documents\phd-pre-proposal\analysis\processedData\',nameOfFile];
save(SavingFile,'numberOfRelevantTrials','labeled_saccade_vecs','XY_vecs_pix','XY_vecs_deg','didRecog','notRecog',...
    'drifts_vel_deg2sec','drifts_dist_degrees','drifts_amp_degrees','drifts_time_ms',...
    'saccs_maxvel_deg2sec','saccs_vel_deg2sec','saccs_amp_degrees','saccs_time_ms',...
    'num_of_sacc_per_sec','num_of_sacc');
SavingFile=['C:\Users\bnapp\Documents\phd-pre-proposal\analysis\processedData\FP\',nameOfFile];
save([SavingFile  'FP'],'finalPics','-v7.3');
tilefigs;