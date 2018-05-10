
function [error,status4,status5]=ELFinish(edfFile)
% closing eyelink
        Eyelink('Stoprecording');
        pause(1)
        error = Eyelink('CheckRecording');
        pause(1)
        status4 = Eyelink('CloseFile');
        pause(1)
        status5=Eyelink('ReceiveFile');
        %savings
        if status5<0
            fprintf('problem: ReceiveFile status: %d\n', status5);
            save(edfFile);
        end
        
end