
function [goodCal,answer]=getAnswer(keyboardNum,textColor,screenNumber,eyetracking,exp_type,PicName,w,wW,wH,eyeused)
% This function ask the subject after each trial
goodCal=1;
answers={' Yes' , ' No'};

[qrect,rect]= ansOnScreen(wW,wH,w,answers);
timePerAns=zeros(1,length(answers));
Screen(w,'DrawText','Did you recognize the object? ',qrect(1),qrect(2));

DrawFormattedText(w, '+','center','center',textColor);
Screen('Flip',w);

if eyetracking==0
    ShowCursor('Hand');
end

%
tic
while ~exist('answer','var')
    WaitSecs(0.1);
    if eyetracking==1
        sample = Eyelink('NewestFloatSample');
        gazeXcurr = sample.gx(eyeused);
        gazeYcurr = sample.gy(eyeused);
        mx= gazeXcurr-fix(1);
        my= gazeYcurr-fix(2);
    else
        if eyetracking==0
            [mx, my]=GetMouse(screenNumber);
        end
    end
    for i=1:max(size(answers))
        if mx>=rect(i,1) && mx<=rect(i,3) && my>=rect(i,2) && my<=rect(i,4)
            timePerAns(i)=timePerAns(i)+1;
        end
        if max(timePerAns)>10
            answer=answers{1,i};
            disp(answer);
            [~,rect]= ansOnScreen(wW,wH,w,answers,i);
            Screen('Flip',w);
            break
        end
        if toc>6
            nameY= KbName('y');
            nameN= KbName('n');
            disp('the answer is: ')
            PsychHID('KbQueueCreate')
            PsychHID('KbQueueStart')
            while  KbCheck(keyboardNum)==0 % waits for key press
            end
            [kbEvent, ~] = PsychHID('KbQueueGetEvent' );
            if   kbEvent.Keycode==nameY
                answer=answers{1,1};
                [~,rect]= ansOnScreen(wW,wH,w,answers,i);
                Screen('Flip',w);
            end
            if   kbEvent.Keycode==nameN
                answer=answers{1,2};
                [~,rect]= ansOnScreen(wW,wH,w,answers,i);
                Screen('Flip',w);
            end
            PsychHID('KbQueueStop')
            PsychHID('KbQueueFlush')
            goodCal=0;
            break
        end
    end
end

% if exp_type==10
%     line='\_+';
%     NamePic=regexp(PicName,line,'split');
%     NamePic=NamePic{1,1};
%     DrawFormattedText(w, NamePic,'center','center',textColor);
%     Screen('Flip', w);
%     pause(2)
% end

if eyetracking==0
    HideCursor;
end
end




