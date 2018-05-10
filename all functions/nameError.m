
function nameError(fileName,defult_name,session_num,keyboardNum)
% this function makes sure you didnt give the expirament a name which
% already exists! (unless it is the defult name)

if strcmp(fileName,defult_name)==0
    if exist([fileName '_'  num2str(session_num)  '.mat'],'file')
        comp=whichComp;% COMPUTER at home KNOWS small b!!
        if strcmp(comp,'C:\Users\lirongruber\Documents\weizmann\MASTER_PROJECT\data\')% COMPUTER at home KNOWS small b!!
            nameY= kbname('y');
            %             nameN= kbname('n');
            
        else
            nameY= KbName('y');
            %             nameN= KbName('n');
        end
        
        disp('THIS FILE ALLREADY EXIST!!! DO YOU WANT TO CONTINUE?  Y/N')
        
        PsychHID('KbQueueCreate')
        PsychHID('KbQueueStart')
        while  KbCheck(keyboardNum)==0 % waits for key press
        end
        [kbEvent, ~] = PsychHID('KbQueueGetEvent' );
        if   kbEvent.Keycode==nameY
        else
            Screen('CloseAll');
            error('CHANGE FILE NAME AND START AGAIN')
        end
        PsychHID('KbQueueStop')
        PsychHID('KbQueueFlush')
    end
end

end