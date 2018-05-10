
function [answer]=getAnswer(exp_type,w,wW,wH,mouseNum,gray)
% This function ask the subject after each trial 


if exp_type==1
    answers={' Yes' , ' No'};
    [qrect,rect]= ansOnScreen(wW,wH,w,gray,answers);
    
    Screen(w,'DrawText','Did you recognize the object? ',qrect(1),qrect(2));
else
    answers={' Same' , ' Different'};
    [qrect,rect]= ansOnScreen(wW,wH,w,gray,answers);
    Screen(w,'DrawText','Were the Xs on the same curve?',qrect(1),qrect(2));
end
Screen('Flip',w);
ShowCursor('Hand');

while ~exist('answer','var')
    [~,x,y] = GetClicks(w, 0, mouseNum);
    pause(1)
    for i=1:max(size(answers))
        if x>=rect(i,1) && x<=rect(i,3) && y>=rect(i,2) && y<=rect(i,4)
            answer=answers{1,i};
            HideCursor;
        end
    end
end

disp(answer);
end




