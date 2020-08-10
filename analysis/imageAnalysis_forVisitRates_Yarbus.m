clear
close all

% expType=0; %subMIRCS -> MIRCs ->  full images
% expType=10; %  MIRCs ->  full images -> subMIRCS
% expType=100; % full images -> subMIRCS ->  MIRCs
% expType=11; % (with fixation) MIRCs ->  full images -> subMIRCS
% expType=12; % (with stabilization) MIRCs ->  full images -> subMIRCS

Recognition=' Yes'; % ' Yes' ' No' 'Both'
OnlyFirstSession=0;
Sub=0;
Mirc=1;
Full=0;
Ref=0;
onlySession=nan; % to control for order effects [nan 1 2 3 4]%-- 7/22/2019 5:08 PM --%

nameOfFile=['OnlyFirst' num2str(OnlyFirstSession) '_Sub' num2str(Sub) 'Mirc' num2str(Mirc) 'Full' num2str(Full) 'Ref' num2str(Ref) '_rec' Recognition];

orderPicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane','house','mouth','nose'};

%general parameters:
rate=250;% 250 Hz
screen_dis=1;% meter
PIXEL2METER=0.000264583;
for i=1:size(orderPicsNames,2)
    orderPicsNames{2,i}=i;
end

t=0;
for subjects={'EM','AK','FS','GG','GH','GS','HL','IN','LS','NA','NG','RB','SG','SE','SS','TT','UK','YB','YM','YS'} %
    % for subjects={'EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'}
    t_perSubject=0;
    files = dir(['C:\Users\lirongr\Documents\MIRCs_exp\data\cleanData\' subjects{1,1}]);
    for file = files'
        if strcmp(file.name,'.')==0 && strcmp(file.name,'..')==0
            currFile = file.name;
            currFile=regexp(currFile,'\_+','split');
            expNum=currFile{4}(1:end-4);
            sessionNum=currFile{2};
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
                if  (strcmp('house',NamePic)==0 && strcmp('nose',NamePic)==0 && strcmp('mouth',NamePic)==0 )
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
                        
                        filterFlag=1;
                        plotFlag=0;
                        [chan_h_pix,chan_v_pix,chan_h_deg, chan_v_deg,saccade_vec, n] =paramsForSaccDetection(plotFlag,imdata,[x ; y],rate,filterFlag);
                        if size(saccade_vec,2)>3
                            fourthFixationStart=saccade_vec(1,3);
                            XY_vec_pix=[chan_h_pix;chan_v_pix];
                            XY_vec_deg=[chan_h_deg;chan_v_deg];
                            
                            %visit rates
                            [full_finalPic,tillFixation4_finalPic,fromFixation4_finalPic]=visitRatesMircs_Yarbus(XY_vec_pix,imdata,fourthFixationStart);
                            for i=1:size(orderPicsNames,2)
                                if strcmp(orderPicsNames{1,i},NamePic)==1
                                    full_finalPics{i}{t}=full_finalPic;
                                    tillFixation4_finalPics{i}{t}=tillFixation4_finalPic;
                                    fromFixation4_finalPics{i}{t}=fromFixation4_finalPic;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

for i=1:size(full_finalPics,2)
    if ~isempty(full_finalPics{i})
        full_finalPics{i}=full_finalPics{i}(~cellfun('isempty',full_finalPics{i}));
        tillFixation4_finalPics{i}=tillFixation4_finalPics{i}(~cellfun('isempty',tillFixation4_finalPics{i}));
        fromFixation4_finalPics{i}=fromFixation4_finalPics{i}(~cellfun('isempty',fromFixation4_finalPics{i}));
    end
end

%% saving

SavingFile=['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\visitRatesData\',nameOfFile];
save([SavingFile  '_full_FP'],'full_finalPics','-v7.3');
save([SavingFile  '_till4_FP'],'tillFixation4_finalPics','-v7.3');
save([SavingFile  '_from4_FP'],'fromFixation4_finalPics','-v7.3');

