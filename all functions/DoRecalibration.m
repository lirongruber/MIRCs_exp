
function[el]=DoRecalibration(el,eyetracking,session_num,SESSION_NUM,keyboardNum,w,backgroundcolor,mouseNum,domEye)
% recalibration exp if user say that calibration  is bad:

if eyetracking && session_num~=SESSION_NUM
    disp('DO YOU WANT TO CONTINUE [Y] OR RECALIBRATE [N] ?  Y/N')
    nameY= KbName('y');
    %         nameN= KbName('n');
    
    PsychHID('KbQueueCreate')
    PsychHID('KbQueueStart')
    while  KbCheck(keyboardNum)==0 % waits for key press
    end
    [kbEvent, ~] = PsychHID('KbQueueGetEvent' );
    if   kbEvent.Keycode==nameY
%         el=[];
    else
        [el]= calibration(w,backgroundcolor,mouseNum,domEye);
        disp('RECALIBRATION...')
    end
    PsychHID('KbQueueStop')
    PsychHID('KbQueueFlush')
else
% el=[];   
end

end