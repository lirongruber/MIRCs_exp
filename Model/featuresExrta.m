% information and entropy claculation on the movies
function [classfeatures]=featuresExrta(filt_movie,details,plotFlag)
classfeatures=struct;

for fixation_num=1:size(filt_movie,2)
    tic

    Fs=125;
    T=1/Fs;
    L=size(filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2),2);
    time=(0:L-1).*T.*1000;%ms
    
    cuttMovie=filt_movie{1,fixation_num};
    frameEntropy=[];
    for frameNum=1:size(cuttMovie,3)
        frameEntropy(frameNum)=entropy(cuttMovie(:,:,frameNum));
    end
    
    classfeatures.perFrameEntropy{fixation_num}=frameEntropy;
%     figure(1)
%     hold all
%     plot(time(1:L),frameEntropy)
%     ylabel('entropy []')
%     xlabel('time [ms] ')
end