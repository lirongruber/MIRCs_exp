% blink analysis
s=0;
totalB=0;
for subjects={'EM','AK','FS','GG','GH','GS','HL','IN','LS','NA','NG','RB','SG','SE','SS','TT','UK','YB','YM','YS'} %
    s=s+1;
    % for subjects={'EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'}
    blinks_per_sub=[];
    files = dir(['C:\Users\lirongr\Documents\MIRCs_exp\data\cleanData\' subjects{1,1}]);
    for file = files'
        if strcmp(file.name,'.')==0 && strcmp(file.name,'..')==0
            currFile = load(file.name);
            blinks_per_sub=[blinks_per_sub currFile.blink];
        end
    end
    totalB=totalB+size(blinks_per_sub(blinks_per_sub>2),2);
    figure(10)
    subplot(4,5,s)
    histogram(blinks_per_sub)
    title([subjects{1,1} ' mean=' num2str(mean(blinks_per_sub))])
end