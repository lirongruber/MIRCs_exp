function [set1,set2,set3]=imagesToUse(expType)

set3=dir([pwd '\ImagesForExp\fullImages']);
set2=[];
set1=[];

% expType=0;full images (3 times)
% expType=10; %MIRCs (2 times with feedback) ->  full images

% expType=101; % MIRCS fixation
% expType=102; % MIRCS stabilized
% expType=103; % subMIRCS

if expType==0
    set2=set3;
    set1=set3;
end

if expType==10 || expType==101 || expType==102
    set2=dir([pwd '\ImagesForExp\MIRCs']);
    set1=set2;
end

if expType==103
    set2=dir([pwd '\ImagesForExp\MIRCs']);
    set1=dir([pwd '\ImagesForExp\subMIRCs']);
end


end