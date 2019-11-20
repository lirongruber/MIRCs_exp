% retinal movies meta-analysis - saves "control_class" for later analysis
clear

movies_path='C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\control_videos5';
folders={'MIRCs_yes','subMIRCs_no'};

control_class={};
class_num=0;
for folder=folders
    class_num=class_num+1;
     movies = dir([movies_path '\' folder{1,1}]);
     mov_nom=0;
    for currMov = movies'
        if ~strcmp(currMov.name,'.') && ~strcmp(currMov.name,'..')
            mov_nom=mov_nom+1;
            load([movies_path '\' folder{1,1} '\' currMov.name]);
            plotFlag=0;
            [classfeatures]=features(filt_movie,details,plotFlag);
            control_class{class_num,mov_nom}=classfeatures;
        end
    end
end
save('C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\control_class5','control_class')