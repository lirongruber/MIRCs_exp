% retinal movies meta-analysis - saves "class" for later analysis
% clear

movies_path='C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\videos';
folders={'MIRCs_yes','MIRCs_no','subMIRCs_yes','subMIRCs_no'};
folders={'fullImages'};

figNum=10;
% folders={'MIRCs_yes'};

class={};
class_num=0;
for folder=folders
    class_num=class_num+1;
    movies = dir([movies_path '\' folder{1,1}]);
    mov_nom=0;
    for currMov = movies'
        if ~strcmp(currMov.name,'.') && ~strcmp(currMov.name,'..') && ~strcmp(currMov.name(end-4),'r')
            mov_nom=mov_nom+1;
            load([movies_path '\' folder{1,1} '\' currMov.name]);
            plotFlag=0;
            
            [classfeatures]=features_temp(filt_movie,details,plotFlag);
            %with different corr threshold
%             [classfeatures]=features_option2(filt_movie,details,plotFlag);
            %Entropy
%            figNum=figNum+1;
%           [classfeatures]=featuresExrta(filt_movie,details,plotFlag,figNum);

            class{class_num,mov_nom}=classfeatures;
        end
    end
end
save('C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\classFullImages','class')
% save('C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\classPlosMEAN','class')
% save('C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\class_option2','class')