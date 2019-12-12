%images analysis

clear
close all

% expType=0; %subMIRCS -> MIRCs ->  full images
% expType=10; %  MIRCs ->  full images -> subMIRCS
% expType=100; % full images -> subMIRCS ->  MIRCs
% expType=11; % (with fixation) MIRCs ->  full images -> subMIRCS
% expType=12; % (with stabilization) MIRCs ->  full images -> subMIRCS

Recognition='Both'; % ' Yes' ' No' 'Both'
OnlyFirstSession=0;
Sub=0;
Mirc=0;
Full=0;
Ref=1;
onlySession=nan; % to control for order effects [nan 1 2 3 4]%-- 7/22/2019 5:08 PM --%
onlyImage=nan; % to specify certain image [nan 'eagle' 'bike'  'horse'...]

if isnan(onlySession)
    nameOfFile=['OnlyFirst' num2str(OnlyFirstSession) '_Sub' num2str(Sub) 'Mirc' num2str(Mirc) 'Full' num2str(Full) 'Ref' num2str(Ref) '_rec' Recognition]; % '_fixation'];
else
    nameOfFile=['onlySession' num2str(onlySession) '_Sub' num2str(Sub) 'Mirc' num2str(Mirc) 'Full' num2str(Full) 'Ref' num2str(Ref) '_rec' Recognition]; % '_fixation'];
end
if ~isnan(onlyImage)
    nameOfFile=[ onlyImage '_' nameOfFile];
end

orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane','house','mouth','nose'};
if (Ref==1 && isnan(onlySession)) || ( Ref==1 && onlySession==1)
    orderPicsNames={'ref_boat', 'ref_butterfly' , 'ref_camera' , 'ref_chair' , 'ref_cup' , 'ref_elephant','ref_flower','ref_helicopter','ref_lamp','ref_umbrella'};
end
%general parameters:
rate=250;% 250 Hz
screen_dis=1;% meter
PIXEL2METER=0.000264583;
do_plot_images=0;
for i=1:length(orderPicsNames)
    orderPicsNames{2,i}=i;
end

t=0;
didRecog=zeros(1,1000);
notRecog=zeros(1,1000);
%mircs: subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM'}
%submircs: subjects={'EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'}
for subjects={'EM','AK','FS','GG','GH','GS','HL','IN','LS','NA','NG','RB','SE','SG','SS','TT','UK','YB','YM','YS'}
% for subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM'}
    t_perSubject=0;
    files = dir(['C:\Users\lirongr\Documents\MIRCs_exp\data\cleanData\' subjects{1,1}]);
    for file = files'
        if strcmp(file.name,'.')==0 && strcmp(file.name,'..')==0
            currFile = file.name;
            currFile=regexp(currFile,'\_+','split');
            expNum=currFile{4}(1:end-4);
            sessionNum=currFile{2};
            if isnan(onlySession) || strcmp(sessionNum,num2str(onlySession))
                if OnlyFirstSession==0 || (OnlyFirstSession==1 && strcmp(sessionNum,'2')==1)
                    if (Sub==1 && (strcmp(expNum,'0')==1 && strcmp(sessionNum,'2')==1 ...
                            || strcmp(expNum,'10')==1 && strcmp(sessionNum,'4')==1 ...
                            || strcmp(expNum,'100')==1 && strcmp(sessionNum,'3')==1)) ...
                            ...
                            || (Mirc==1 && (strcmp(expNum,'0')==1 && strcmp(sessionNum,'3')==1 ...
                            || strcmp(expNum,'10')==1 && strcmp(sessionNum,'2')==1 ...
                            || strcmp(expNum,'100')==1 && strcmp(sessionNum,'4')==1)) ...
                            ...
                            || (Full==1 && (strcmp(expNum,'0')==1 && strcmp(sessionNum,'4')==1 ...
                            || strcmp(expNum,'10')==1 && strcmp(sessionNum,'3')==1 ...
                            || strcmp(expNum,'100')==1 && strcmp(sessionNum,'2')==1) )...
                            ...
                            || (Ref==1 && strcmp(sessionNum,'1')==1 )
                        
                        currFile = load(file.name);
                        NamePic=regexp(currFile.PicName,'\_+','split');
                        if ~isempty(strfind(NamePic{1,1},'.'))
                            NamePic=regexp(currFile.PicName,'\.+','split');
                        else
                            if ~isempty(strfind(NamePic{1,2},'.'))
                                NamePic=regexp(currFile.PicName,'\.+','split');
                            end
                        end
                        NamePic=NamePic{1,1};
                        % Specific image - no 3 last images
                        if (sum(isnan(onlyImage))==1 || strcmp(onlyImage,NamePic)) && (strcmp('house',NamePic)==0 && strcmp('nose',NamePic)==0 && strcmp('mouth',NamePic)==0 )
                            
                            % Recognition
                            if strcmp(Recognition,'Both') || strcmp(Recognition,currFile.answer)
                                t=t+1;
                                t_perSubject=t_perSubject+1;
                                %here come the main analysis:
                                screenS=[1080,1920];
                                image=currFile.myimgfile;
                                SIZE=size(image);
                                image=[ones(floor((screenS(1)- SIZE(1))/2),screenS(2)).*255 ; ones(SIZE(1),floor((screenS(2)-SIZE(2))/2)).*255  , image , ones(SIZE(1),ceil((screenS(2)-SIZE(2))/2)).*255  ; ones( ceil((screenS(1)- SIZE(1))/2),screenS(2)).*255 ];
                                imdata=image;
                                
                                
                                % WITHOUT FIXATION TIME
                                x=currFile.gazeX(rate*2+1:end);
                                y=currFile.gazeY(rate*2+1:end);
%                                 % ONLY FIXATION TIME
%                                 x=currFile.gazeX(1:rate*2);
%                                 y=currFile.gazeY(1:rate*2);
                                
                                %
                                if do_plot_images==1
                                    imageRGB=ind2rgb(image,gray(256));
                                    figure()
                                    hold on
                                    h=imshow(imageRGB);
                                    z = zeros(size(x));
                                    col = 1:length(x);  % This is the color.
                                    ho=surface([x;x],[y;y],[z;z],[col;col],...
                                        'facecol','no',...
                                        'edgecol','interp',...
                                        'linew',1);
                                    zoomcenter(961,541,6)
                                    plot(screenS(2)/2,screenS(1)/2,'+m','LineWidth',1)
                                    
                                    if ~isnan(x(1))
                                        plot(x(1),y(1),'+r','LineWidth',1)
                                    else
                                        plot(x(find(isnan(x)==0,1)),y(find(isnan(x)==0,1)),'+r','LineWidth',5)
                                    end
                                    %                             set(gca,'position',[0 0 1 1],'units','normalized')
                                    
                                    %                             title(NamePic)
                                    colorbar
                                    saveppt('examples.ppt',[subjects{1} '_' currFile.answer])
                                    close all
                                end
                                
                                %                             [imdata,chan_h_pix,chan_v_pix,chan_h, chan_v,saccade_vec, n] =sacDiffAmosPHD(NamePic,currFile.gazeX,currFile.gazeY,image,doPlot);
                                filterFlag=1;
                                plotFlag=0;
                                [chan_h_pix,chan_v_pix,chan_h_deg, chan_v_deg,saccade_vec, n] =paramsForSaccDetection(plotFlag,imdata,[x ; y],rate,filterFlag);
                                
                                % 1.number of sacc
                                num_of_sacc(t)=length(saccade_vec);
                                % 2. number of saccedes per sec
                                trialTime=3; %sec
                                num_of_sacc_per_sec(t)=num_of_sacc(t)./ trialTime;
                                
                                saccade_vecs{t}=saccade_vec;
                                XY_vecs_pix{t}=[chan_h_pix;chan_v_pix];
                                XY_vecs_deg{t}=[chan_h_deg;chan_v_deg];
                                
                                XY_vec_pix=XY_vecs_pix{t};
                                XY_vec_deg=XY_vecs_deg{t};
                                
                                % 5. saccades and drift
                                [sacc_time_ms,sacc_amp_degrees,sacc_vel_deg2sec,sacc_maxvel_deg2sec]=saccMircs(saccade_vec,XY_vec_deg,rate);
                                [drift_time_ms,drift_dist_degrees,drift_amp_degrees,drift_vel_deg2sec]=driftMircs(saccade_vec,XY_vec_deg,rate);
                                
                                labeled_saccade_vecs{t}=saccade_vec;
                                saccs_time_ms{t}=sacc_time_ms;
                                saccs_amp_degrees{t}=sacc_amp_degrees;
                                saccs_vel_deg2sec{t}=sacc_vel_deg2sec;
                                saccs_maxvel_deg2sec{t}=sacc_maxvel_deg2sec;
                                drifts_time_ms{t}=drift_time_ms;
                                drifts_amp_degrees{t}=drift_amp_degrees;
                                drifts_vel_deg2sec{t}=drift_vel_deg2sec;
                                drifts_dist_degrees{t}=drift_dist_degrees;
                                
%                                 %visit rates
%                                 [full_finalPic,sec1_finalPic,unfull_finalPic,unsec1_finalPic]=visitRatesMircs(XY_vec_pix,imdata);
%                                 for i=1:length(orderPicsNames)
%                                     if strcmp(orderPicsNames{1,i},NamePic)==1
%                                         full_finalPics{i}{t}=full_finalPic;
%                                         sec1_finalPics{i}{t}=sec1_finalPic;
%                                         unfull_finalPics{i}{t}=unfull_finalPic;
%                                         unsec1_finalPics{i}{t}=unsec1_finalPic;
%                                     end
%                                 end
                                
                                % answers
                                if strcmp(currFile.answer,' Yes')
                                    didRecog(t)=didRecog(t)+1;
                                else
                                    notRecog(t)=notRecog(t)+1;
                                end
                                disp(t);
                            end
                        end
                    end
                end
            end
        end
    end
%         %for saving per subject
%         numberOfRelevantTrials=t_perSubject;
%         SavingFile=['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\perSubject\' subjects{1,1} '_'  nameOfFile];
%         save(SavingFile,'numberOfRelevantTrials','labeled_saccade_vecs','XY_vecs_pix','XY_vecs_deg','didRecog','notRecog',...
%             'drifts_vel_deg2sec','drifts_dist_degrees','drifts_amp_degrees','drifts_time_ms',...
%             'saccs_maxvel_deg2sec','saccs_vel_deg2sec','saccs_amp_degrees','saccs_time_ms',...
%             'num_of_sacc_per_sec','num_of_sacc');
end
numberOfRelevantTrials=t;
didRecog=didRecog(1:t);
notRecog=notRecog(1:t);
% for i=1:length(full_finalPics)
%     if ~isempty(full_finalPics{i})
%         full_finalPics{i}=full_finalPics{i}(~cellfun('isempty',full_finalPics{i}));
%         sec1_finalPics{i}=sec1_finalPics{i}(~cellfun('isempty',sec1_finalPics{i}));
%         unfull_finalPics{i}=unfull_finalPics{i}(~cellfun('isempty',unfull_finalPics{i}));
%         unsec1_finalPics{i}=unsec1_finalPics{i}(~cellfun('isempty',unsec1_finalPics{i}));
%     end
% end
%% saving

SavingFile=['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\',nameOfFile];
save(SavingFile,'numberOfRelevantTrials','labeled_saccade_vecs','XY_vecs_pix','XY_vecs_deg','didRecog','notRecog',...
    'drifts_vel_deg2sec','drifts_dist_degrees','drifts_amp_degrees','drifts_time_ms',...
    'saccs_maxvel_deg2sec','saccs_vel_deg2sec','saccs_amp_degrees','saccs_time_ms',...
    'num_of_sacc_per_sec','num_of_sacc');
% save([SavingFile  'full_FP'],'full_finalPics','-v7.3');
% save([SavingFile  'sec_FP'],'sec1_finalPics','-v7.3');
% save([SavingFile  'unfull_FP'],'unfull_finalPics','-v7.3');
% save([SavingFile  'unsec_FP'],'unsec1_finalPics','-v7.3');
tilefigs;