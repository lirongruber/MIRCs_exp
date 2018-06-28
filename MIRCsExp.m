%  Viewing Atoms of vision
CompStartUpMIRCs;

clear
close all
clc
subject='YS';%name of subject % AA defult 
domEye='r'; % r or l

eyetracking =1;% 0 for mouse tracking
% -old- not updated
% expType=0;full images (3 times)
% expType=10; %MIRCs (2 times with feedback) ->  full images
% expType=101; % MIRCS fixation -> MIRCs ->  full images
% expType=102; % MIRCS stabilized -> MIRCs ->  full images
% expType=103; % subMIRCS -> MIRCs ->  full images

expType=0; %subMIRCS -> MIRCs ->  full images
% expType=10; %  MIRCs ->  full images -> subMIRCS
% expType=100; % full images -> subMIRCS ->  MIRCs
% expType=11; % (with fixation) MIRCs ->  full images -> subMIRCS
% expType=12; % (with stabilization) MIRCs ->  full images -> subMIRCS

IMAGE_SIZE_DEG=3;
PIXEL2METER=0.000264583;
IMAGE_LENGTH_PIX=round(tand(IMAGE_SIZE_DEG/2)/PIXEL2METER*2);

NUM_OF_TRIALS=13;% should be 13
TRIAL_LENGTH=3; % should be 3 seconds
FIXATION_LENGTH=2; %should be 2 seconds
TIME_RES=0.001; 
if expType==12
    TIME_RES=0.01;
end

TOTAL_TRIAL_TIME=TRIAL_LENGTH/TIME_RES;
FIXATION_TIME=FIXATION_LENGTH/TIME_RES; 
DATA_SIZE=TOTAL_TRIAL_TIME+FIXATION_TIME;% total time ;

screenNumber = 2;
pixelSize=32;%original 32 for 'openWindow'
textColor=[56 61 150];

if eyetracking==0
    SavingPath=[pwd '\'];
else
    SavingPath=CompStartUpMIRCs;
end

keyboardNum=GetKeyboardIndices;
mouseNum=GetMouseIndices;
white=WhiteIndex(screenNumber);
black=BlackIndex(screenNumber);
gray=GrayIndex(screenNumber); % returns as default the mean gray value of screen

backgroundcolor = gray;

%sometimes needed for multi-screen mode:
Screen('Preference', 'SkipSyncTests', screenNumber);
Screen('Preference', 'SuppressAllWarnings', screenNumber);
% avoid Psychtoolbox's welcome screen
Screen('Preference', 'VisualDebuglevel', 3); 

[w, windowRect]=Screen('OpenWindow',screenNumber, 0,[],pixelSize,2);
[wW, wH]=WindowSize(w);
if eyetracking==1
    Eyelink('initialize');
    [el]= calibration(w,backgroundcolor,textColor,mouseNum,domEye);
    fix=[0,0];
end
%empty vectors to fill:
pd_cal= zeros(1,DATA_SIZE);
gazeX_cal= zeros(1,DATA_SIZE);
gazeY_cal= zeros(1,DATA_SIZE);

Screen('FillRect', w, backgroundcolor);
Screen('TextSize',w,50);

%%starting exp
HideCursor;
globalClock = GetSecs;

str_expType=num2str(expType);
[set0,set1,set2,set3]=imagesToUse(expType);
sessionNum=0;
for rel_set={set0, set1 , set2 , set3}
    sessionNum=sessionNum+1;
    for i=3:length(rel_set{1,1})
        picsNames{1,i-2}=rel_set{1,1}(i).name;
    end
    [picOrder]=Shuffle(1:min(length(picsNames),NUM_OF_TRIALS));
    picsNames=picsNames(1:min(length(picsNames),NUM_OF_TRIALS));
    [picOrder]=picsNames(picOrder);
    
    curr_NUM_OF_TRIALS=min(length(picsNames),NUM_OF_TRIALS);

    for trial_num=1:curr_NUM_OF_TRIALS
        SavingFile=[SavingPath subject '_' num2str(sessionNum) '_' num2str(trial_num)  '_' num2str(expType) '.mat'];
        numTrial=num2str(trial_num);
        disp ( 'waiting to start trial:   ' )
        disp(numTrial)
        myimgfile= picOrder{1,trial_num}; % rellevant picture
        PicName=myimgfile;
        [myimgfile,map]=imread(myimgfile);
        if sessionNum==1
        myimgfile=ind2gray(myimgfile,map);
        end
        myimgfile=imresize(myimgfile,[IMAGE_LENGTH_PIX IMAGE_LENGTH_PIX]);
        %empty vectors to fill:
        pd=zeros(1,DATA_SIZE); %pupil size
        gazeX=zeros(1,DATA_SIZE);
        gazeY=zeros(1,DATA_SIZE);
        stepTime=zeros(1,DATA_SIZE);
        missedSamples=zeros(1,DATA_SIZE);
        timeCompleted=zeros(1,DATA_SIZE);
        
        %recalibrate and oped edf
        if eyetracking==1
             % EDF reasons for short names (max 6)
            edfFile=[subject num2str(sessionNum) '_' num2str(trial_num)  '.edf'];
            [eyeused]=ELInit(edfFile);
            if trial_num==1
                sizeCal=1;
                [el,pd_cal,gazeX_cal,gazeY_cal,fix]=calibVer(el,edfFile,sizeCal,w,wW,wH,backgroundcolor,mouseNum,keyboardNum,textColor,TIME_RES,eyeused,pd_cal,gazeX_cal,gazeY_cal,fix);
            end
        end
        if sessionNum==4 && trial_num==4
            DrawFormattedText(w, 'Get ready - click mouse to START (only 10 more...) ','center','center',textColor);
        else
            DrawFormattedText(w, 'Get ready - click mouse to START ','center','center',textColor);
        end
        Screen('Flip', w);
        while  KbCheck(mouseNum)==0 % waits for mouse click
        end
        pause(2)
        
        disp ( 'starting trial    ' )
        disp(num2str(trial_num))
        
        i=1;
        i_max=DATA_SIZE;
        Screen('TextSize',w,50);
        DrawFormattedText(w, '+','center','center',textColor);
        Screen('Flip', w);
        
        PicTex=Screen('MakeTexture', w, myimgfile);%                 JPEG to another

        trialClock=GetSecs;
        while  i<=i_max % every trial (shape)
            tic
            currStepTime= GetSecs;
            if eyetracking==1
                sample = Eyelink('NewestFloatSample');
                pd(i) = sample.pa(eyeused);
                gazeXcurr = sample.gx(eyeused);
                gazeYcurr = sample.gy(eyeused);
                mx= gazeXcurr-fix(1);
                my= gazeYcurr-fix(2);
                gazeX(i)=mx; % for the saving!
                gazeY(i)=my; %for the saving!
            else
                if eyetracking==0
                    [mx, my]=GetMouse(screenNumber);
                    gazeX(i) = mx;
                    gazeY(i) = my;
                    eyeused=[];
                    fix=[];
                end
            end
            
            
            if i>=FIXATION_TIME
                if expType==12 
                    Screen('DrawTexture', w, PicTex,[],[round(gazeX(i)-IMAGE_LENGTH_PIX/2),round(gazeY(i)-IMAGE_LENGTH_PIX/2),round(gazeX(i)-IMAGE_LENGTH_PIX/2)+IMAGE_LENGTH_PIX,round(gazeY(i)-IMAGE_LENGTH_PIX/2)+IMAGE_LENGTH_PIX],[]);
                    Screen('Flip', w);
                else
                    if i==FIXATION_TIME && expType~=11 
                        Screen('DrawTexture', w, PicTex,[],[],[]);
                        Screen('Flip', w);
                    end
                end
                if expType==11 && i==FIXATION_TIME 
                    Screen('DrawTexture', w, PicTex,[],[],[]);
                    if sessionNum==1
                    DrawFormattedText(w, '+','center','center',textColor);
                    end
                    Screen('Flip', w);
                end
            end
%             ShowCursor;
            [timeCompleted,missedSamples]=loopSepTime(currStepTime,TIME_RES,timeCompleted,missedSamples,i);
            i=i+1;
            stepTime(i)=toc;
        end
        disp ( 'trial time: ')
        disp(GetSecs-trialClock)
        trialTime=(GetSecs-trialClock);
        
        isCurve=0;
        [goodCal,answer]=getAnswer(keyboardNum,textColor,screenNumber,eyetracking,expType,PicName,w,wW,wH,eyeused);
        
        if trial_num~=curr_NUM_OF_TRIALS
            if goodCal==0
                [el]= calibration(w,backgroundcolor,textColor,mouseNum,domEye);
                fix=[0,0];
                [eyeused]=ELInit(edfFile);
                [el,pd_cal,gazeX_cal,gazeY_cal,fix]=calibVer(el,edfFile,1,w,wW,wH,backgroundcolor,mouseNum,keyboardNum,textColor,TIME_RES,eyeused,pd_cal,gazeX_cal,gazeY_cal,fix);
            end
        end
        
        if eyetracking==1
            [error,status4,status5]=ELFinish(edfFile);
        end
        save(SavingFile,'subject','expType','TIME_RES','pixelSize','pd','gazeX','gazeY','pd_cal','gazeX_cal','gazeY_cal','mx','my','missedSamples','timeCompleted','trialTime','myimgfile','fix','PicName','answer');
        
        %clear for next session
        clear(  'pd','gazeX','gazeY','missedSamples','timeCompleted','trialTime','myimgfile','PicName','answer');
    end
  
end

DrawFormattedText(w, 'THE END...!!!','center','center',textColor);
Screen('Flip',w);
pause(3)
Screen('CloseAll');
if eyetracking==1
    Eyelink('Shutdown');
end
disp('exp ended');
disp('exp lasted:');
disp(GetSecs-globalClock)
ShowCursor;