function [set0,set1,set2,set3]=imagesToUse(expType)

set0=dir([pwd '\ImagesForExp\refImages']);

full=dir([pwd '\ImagesForExp\fullImages']);
mircs=dir([pwd '\ImagesForExp\MIRCs']);
sub=dir([pwd '\ImagesForExp\subMIRCs']);
% expType=0; subMIRCS -> MIRCs ->  full images
% expType=10; %  MIRCs ->  full images -> subMIRCS
% expType=100; % full images -> subMIRCS ->  MIRCs
% expType=11; % (with fixation) MIRCs ->  full images -> subMIRCS
% expType=12; % (with stabilization) MIRCs ->  full images -> subMIRCS
if expType==0
    set1=sub;
    set2=mircs;
    set3=full;
end

if expType>=10 && expType<100
    set1=mircs;
    set2=full;
    set3=sub;
end

if expType>=100
    set1=full;
    set2=sub;
    set3=mircs;
end

end