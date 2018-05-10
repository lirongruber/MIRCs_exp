%  Viewing Atoms of vision
CompStartUpMIRCs;

clear
close all
clc
subject='AA';%name of subject % AA defult 
domEye='r'; % r or l

eyetracking =0;% 0 for mouse tracking

% expType=0;full images (3 times)
expType=10; %MIRCs (2 times with feedback) ->  full images
% expType=101; % MIRCS fixation -> MIRCs ->  full images
% expType=102; % MIRCS stabilized -> MIRCs ->  full images
% expType=103; % subMIRCS -> MIRCs ->  full images

IMAGE_SIZE_DEG=3;
PIXEL2METER=0.000264583;
IMAGE_LENGTH_PIX=round(tand(IMAGE_SIZE_DEG/2)/PIXEL2METER*2);

NUM_OF_TRIALS=1;
TRIAL_LENGTH=0.05; %minutes
TIME_RES=0.002; 
if expType==102
    TIME_RES=0.01;
end

TOTAL_TRIAL_TIME=TRIAL_LENGTH*60;%in seconds!
FIXATION_TIME=2/TIME_RES; %in 10msec for imax
DATA_SIZE=TOTAL_TRIAL_TIME/TIME_RES+FIXATION_TIME;% total time in (10)milsec;

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
%%sometimes needed for multi-screen mode:
Screen('Preference', 'SkipSyncTests', screenNumber);
Screen('Preference', 'SuppressAllWarnings', screenNumber);

Screen('Preference', 'VisualDebuglevel', 3); % avoid Psychtoolbox's welcome screen
[w, windowRect]=Screen('OpenWindow',screenNumber, 0,[],pixelSize,2);
[wW, wH]=WindowSize(w);
if eyetracking==1
    Eyelink('initialize');
    [el]= calibration(w,backgroundcolor,textColor,mouseNum,domEye);
    fix=[0,0];
end
%empty vectors to fill:
pd_cal= zeros(1,300000);
gazeX_cal= zeros(1,300000);
gazeY_cal= zeros(1,300000);

Screen('FillRect', w, backgroundcolor);
Screen('TextSize',w,50);

%%starting exp
HideCursor;
globalClock = GetSecs;


str_expType=num2str(expType);
[set1,set2,set3]=imagesToUse(expType);
sessionNum=0;
for rel_set={set1 , set2 , set3}
    sessionNum=sessionNum+1;
    for i=3:12
        picsNames{1,i-2}=rel_set{1,1}(i).name;
    end
    [picOrder]=Shuffle(1:NUM_OF_TRIALS);
    picsNames=picsNames(1:NUM_OF_TRIALS);
    [picOrder]=picsNames(picOrder);
    
    for trial_num=1:NUM_OF_TRIALS
        SavingFile=[SavingPath subject '_' num2str(sessionNum) '_' num2str(trial_num)  '_' num2str(expType) '.mat'];
        numTrial=num2str(trial_num);
        disp ( 'waiting to start trial:   ' )
        disp(numTrial)
        myimgfile= picOrder{1,trial_num}; % rellevant picture
        PicName=myimgfile;
        myimgfile=imread(myimgfile);
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
        
        DrawFormattedText(w, 'Get ready - click mouse to START ','center','center',textColor);
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
                if expType==102 && sessionNum==1
                    Screen('DrawTexture', w, PicTex,[],[round(gazeX(i)-IMAGE_LENGTH_PIX/2),round(gazeY(i)-IMAGE_LENGTH_PIX/2),round(gazeX(i)-IMAGE_LENGTH_PIX/2)+IMAGE_LENGTH_PIX,round(gazeY(i)-IMAGE_LENGTH_PIX/2)+IMAGE_LENGTH_PIX],[]);
                    Screen('Flip', w);
                else
                    if i==FIXATION_TIME && expType~=101
                        Screen('DrawTexture', w, PicTex,[],[],[]);
                        Screen('Flip', w);
                    end
                end
                if expType==101 && i==FIXATION_TIME && sessionNum==1
                    Screen('DrawTexture', w, PicTex,[],[],[]);
                    DrawFormattedText(w, '+','center','center',textColor);
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
        
        if trial_num~=NUM_OF_TRIALS
            if goodCal==0
                [el]= calibration(w,backgroundcolor,textColor,mouseNum,domEye);
                fix=[0,0];
                [eyeused]=ELInit(edfFile);
                [el,pd_cal,gazeX_cal,gazeY_cal,fix]=calibVer(el,edfFile,1,w,wW,wH,backgroundcolor,mouseNum,keyboardNum,textColor,0.01,eyeused,pd_cal,gazeX_cal,gazeY_cal,fix);
            end
        end
        
        if eyetracking==1
            [error,status4,status5]=ELFinish(edfFile);
        end
        save(SavingFile,'subject','expType','pixelSize','pd','gazeX','gazeY','pd_cal','gazeX_cal','gazeY_cal','mx','my','missedSamples','timeCompleted','trialTime','myimgfile','fix','PicName','answer');
        
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