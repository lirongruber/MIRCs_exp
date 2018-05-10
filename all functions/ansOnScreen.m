function [qrect,rect]= ansOnScreen(wW,wH,w,answers,Answer)
% this function prepar the screen state for choosing an answer
%(must be called from "getAnswer")

qrect=[round(wW/5) round(wH*2/15)];

rect(1,:)=[round(wW/5) round(wH*7/15) round(wW/3) round(wH*8/15)];

rect(2,:)=[round(wW/1.25) round(wH*7/15) round(wW*0.9) round(wH*8/15)];
if nargin>4
    Screen('TextSize', w ,40);
    DrawFormattedText(w, answers{1,Answer},rect(Answer,1),rect(Answer,2),[70 148 73]);
else
    for i=1:max(size(answers))
        Screen('TextStyle', w,1);
        Screen('TextSize', w ,30);
        Screen(w,'DrawText',answers{1,i},rect(i,1),rect(i,2));
    end
    
end
end