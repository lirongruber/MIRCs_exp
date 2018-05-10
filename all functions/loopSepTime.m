
function [timeCompleted,missedSamples]=loopSepTime(currStepTime,TIME_RES,timeCompleted,missedSamples,i)
% this function makes sure every loop takes the exact time it should take

    if    (GetSecs -currStepTime )< TIME_RES
        timeCompleted(i)=TIME_RES-(GetSecs -currStepTime);
        WaitSecs(TIME_RES-(GetSecs -currStepTime)); %if every loop will be less than 0.01sec
    else if (GetSecs -currStepTime )> TIME_RES
            missedSamples(i)=(GetSecs -currStepTime)-TIME_RES;
        end
    end
end