% Pupil Size analysis

clear
close all

Recognition=' No'; % ' Yes' ' No' 'Both'
OnlyFirstSession=0;
Sub=1;
Mirc=1;
Full=0;
Ref=0;
onlySession=nan; % to control for order effects [nan 1 2 3 4]%-- 7/22/2019 5:08 PM --%
onlyImage=nan; % to specify certain image [nan 'eagle' 'bike'  'horse'...]
blinksParameter=0; %number of maximum blinks per trial

if isnan(onlySession)
    nameOfFile=['Pupil_OnlyFirst' num2str(OnlyFirstSession) '_Sub' num2str(Sub) 'Mirc' num2str(Mirc) 'Full' num2str(Full) 'Ref' num2str(Ref) '_rec' Recognition]; % '_fixation'];
else
    nameOfFile=['Pupil_onlySession' num2str(onlySession) '_Sub' num2str(Sub) 'Mirc' num2str(Mirc) 'Full' num2str(Full) 'Ref' num2str(Ref) '_rec' Recognition]; % '_fixation'];
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
for i=1:size(orderPicsNames,2)
    orderPicsNames{2,i}=i;
end

t=0;
didRecog=zeros(1,1000);
notRecog=zeros(1,1000);
%mircs: subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM'}
% nameOfFile=[nameOfFile '_MIRCGROUP'];
% submircs: subjects={'EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'}
% nameOfFile=[nameOfFile '_subMIRCGROUP'];
if blinksParameter~=0
    nameOfFile=[nameOfFile '_lessBlinks'];
end
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
                            % blinks
                            if  blinksParameter==0 || currFile.blink <=blinksParameter
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
                                    pupil=currFile.pd(2001:end);
                                    
                                    %clean pupil from blinks and correct to
                                    %250HZ
                                    pupil=pupil(1:4:size(pupil,2));
                                    pupil(pupil==0)=nan;
                                    i=1;
                                    removeWindow=floor(150/4); %150ms in 250 Hz
                                    while i<length(pupil)-1
                                        i=i+1;
                                        if (isnan(pupil(i)) &&  ~isnan(pupil(i-1)))
                                            pupil(max(1,i-removeWindow):i)=nan;
                                        end
                                        if (isnan(pupil(i)) &&  ~isnan(pupil(i+1)))
                                            pupil(i:min(i+removeWindow,length(pupil)))=nan;
                                            i=i+removeWindow;
                                        end
                                    end
                                    
                                    
                                    filterFlag=1;
                                    plotFlag=0;
                                    [chan_h_pix,chan_v_pix,chan_h_deg, chan_v_deg,saccade_vec, n] =paramsForSaccDetection(plotFlag,imdata,[x ; y],rate,filterFlag);
                                    
                                    
                                    saccade_vecs{t}=saccade_vec;
                                    XY_vecs_pix{t}=[chan_h_pix;chan_v_pix];
                                    XY_vecs_deg{t}=[chan_h_deg;chan_v_deg];
                                    pupil_vecs{t}=pupil;
                                   
                                    
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

SavingFile=['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\',nameOfFile];
save(SavingFile,'saccade_vecs','XY_vecs_pix','XY_vecs_deg','pupil_vecs');

%%

clear
pupil_paths= {['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\Pupil_OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat']...
['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\Pupil_OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat']...
['C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\Pupil_OnlyFirst0_Sub0Mirc0Full1Ref0_rec Yes.mat']
};

for group=1:3
    load(pupil_paths{group})
    pupil={};
    for t=1:size(saccade_vecs,2)
        currSaccVec=saccade_vecs{1,t};
        currPupil=pupil_vecs{1,t};
        start=1;
        if size(currSaccVec,2)>1
        for s=1:size(currSaccVec,2)
            drift_time=[start currSaccVec(1,s)];
            rel=currPupil((drift_time(1)):(drift_time(2)));
            pupil{t,s}=rel;
            start=currSaccVec(1,s)+currSaccVec(2,s)+1;
        end
            rel=currPupil(start:end);
            pupil{t,s+1}=rel;
        end
    end
    
    figure(1)
    for f=1:size(pupil,1)
        for d=1:7
            subplot(2,4,d)
            plot(pupil{f,d})
            hold on
        end
    end
end
        
        