%collecting trials to folders to create movies


%mircs: subjects={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM'}
%submircs: subjects={'EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'}
% for subjects={'EM','AK','FS','GG','GH','GS','HL','IN','LS','NA','NG','RB','SE','SG','SS','TT','UK','YB','YM','YS'}


from='C:\Users\lirongr\Documents\MIRCs_exp\data\cleanData\';
%submircs
for sub={'EM','GS','HL','NA','RB','SE','SG','SS','YB','YS'}
    rel_folder=[from sub{1,1}];
    rel_files=dir(rel_folder );
    for trial_i=3:length(rel_files)
        t=rel_files(trial_i).name;
        if strcmp(t(4),'3')
            load([rel_folder '\' t]);
            if ~strcmp(PicName(1:5),'house') && ~strcmp(PicName(1:4),'nose') && ~strcmp(PicName(1:5),'mouth') 
                if strcmp(answer,' Yes')
                    [~]=copyfile( [rel_folder '\' t] , 'C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\MIRCs_yes');
                else
                    [~]=copyfile( [rel_folder '\' t] , 'C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\MIRCs_no');
                end
            end
        end
    end
end
% %mircs
for sub={'AK','FS','GG','GH','IN','LS','NG','TT','UK','YM'}
    rel_folder=[from sub{1,1}];
    rel_files=dir(rel_folder );
    for trial_i=3:length(rel_files)
        t=rel_files(trial_i).name;
        if strcmp(t(4),'3')
            load([rel_folder '\' t]);
            if ~strcmp(PicName(1:5),'house') && ~strcmp(PicName(1:4),'nose') && ~strcmp(PicName(1:5),'mouth') 
                if strcmp(answer,' Yes')
                    [~]=copyfile( [rel_folder '\' t] , 'C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\subMIRCs_yes');
                else
                    [~]=copyfile( [rel_folder '\' t] , 'C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\subMIRCs_no');
                end
            end
        end
    end
end