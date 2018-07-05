%images analysis

clear
close all

% expType=0; %subMIRCS -> MIRCs ->  full images
% expType=10; %  MIRCs ->  full images -> subMIRCS
% expType=100; % full images -> subMIRCS ->  MIRCs
% expType=11; % (with fixation) MIRCs ->  full images -> subMIRCS
% expType=12; % (with stabilization) MIRCs ->  full images -> subMIRCS

Recognition='Both'; % ' Yes' ' No' 'Both'
OnlyFirstSession=1;
Sub=1;
Mirc=0;
Full=0;
Ref=0;

nameOfFile=['OnlyFirstSession' num2str(OnlyFirstSession) '_Sub' num2str(Sub) 'Mirc' num2str(Mirc) 'Full' num2str(Full) '_Ref' num2str(Ref)];
orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane','house','mouth','nose'};

if Ref==1
orderPicsNames={'ref_boat', 'ref_butterfly' , 'ref_camera' , 'ref_chair' , 'ref_cup' , 'ref_elephant','ref_flower','ref_helicopter','ref_lamp','ref_umbrella'};
end    
%general parameters:
rate=1000;% 1000 Hz
screen_dis=1;% meter
PIXEL2METER=0.000264583;
do_plot_images=0;
for i=1:length(orderPicsNames)
    orderPicsNames{2,i}=i;
end

t=0;
didRecog=zeros(1,1000);
notRecog=zeros(1,1000);
for subjects= {'EM','GS','NA','RB','SE','SG','HL','YS','YB'}
    files = dir(['C:\Users\bnapp\Documents\MIRCs_exp\data\cleanData\' subjects{1,1}]);
    for file = files'
        if strcmp(file.name,'.')==0 && strcmp(file.name,'..')==0
            currFile = file.name;
            currFile=regexp(currFile,'\_+','split');
            expNum=currFile{4}(1:end-4);
            sessionNum=currFile{2};
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
                    
                    % Recognition
                    if strcmp(Recognition,'Both') || strcmp(Recognition,currFile.answer)
                        t=t+1;
                        %here come the main analysis:
                        screenS=[1080,1920];
                        image=currFile.myimgfile;
                        SIZE=size(image);
                        image=[ones(floor((screenS(1)- SIZE(1))/2),screenS(2)).*255 ; ones(SIZE(1),floor((screenS(2)-SIZE(2))/2)).*255  , image , ones(SIZE(1),ceil((screenS(2)-SIZE(2))/2)).*255  ; ones( ceil((screenS(1)- SIZE(1))/2),screenS(2)).*255 ];
                        imdata=image;
                        
                        NamePic=regexp(currFile.PicName,'\_+','split');
                        if Ref==1
                         NamePic=regexp(currFile.PicName,'\.+','split');
                        end
                        NamePic=NamePic{1,1};
                        
                        % WITHOUT FIXATION TIME
                        x=currFile.gazeX(2001:end);
                        y=currFile.gazeY(2001:end);
                        %
                        if do_plot_images==1
                            imageRGB=ind2rgb(image,gray(256));
                            figure(10)
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
                        
                        %visit rates
                        [finalPic]=visitRatesPHD(XY_vec_pix,imdata);
                        for i=1:length(orderPicsNames)
                            if strcmp(orderPicsNames{1,i},NamePic)==1
                                finalPics{i}{t}=finalPic;
                            end
                        end
                        
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
numberOfRelevantTrials=t;
didRecog=didRecog(1:t);
notRecog=notRecog(1:t);
for i=1:length(finalPics)
    if ~isempty(finalPics{i})
        finalPics{i}=finalPics{i}(~cellfun('isempty',finalPics{i}));
    end
end
%% saving

SavingFile=['C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\',nameOfFile];
% save(SavingFile,'numberOfRelevantTrials','labeled_saccade_vecs','XY_vecs_pix','XY_vecs_deg','didRecog','notRecog',...
%     'drifts_vel_deg2sec','drifts_dist_degrees','drifts_amp_degrees','drifts_time_ms',...
%     'saccs_maxvel_deg2sec','saccs_vel_deg2sec','saccs_amp_degrees','saccs_time_ms',...
%     'num_of_sacc_per_sec','num_of_sacc');
% SavingFile=['C:\Users\bnapp\Documents\phd-pre-proposal\analysis\processedData\FP\',nameOfFile];
save([SavingFile  'FP'],'finalPics','-v7.3');
tilefigs;