% information and entropy claculation on the movies
function [classfeatures]=featuresExrta(filt_movie,details,plotFlag,figNum)
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
   
    % plot
    figure(figNum)
    subplot(2,size(filt_movie,2),fixation_num)
    hold all
    plot(time(1:L),frameEntropy)
    ylabel('entropy [bit]')
    xlabel('time [ms] ')
    
    
    %Reduces number of lines to avoid redundancy
    temp=reshape(filt_movie{1,fixation_num},[402*402 L]);
    if mod(L,2)~=0
        temp=temp(:,2:end);
        L=L-1;
    end
    rel_movie_act=unique(temp, 'rows');
    
    rel_movie_act_MEAN=mean(rel_movie_act);
    r=zeros(1,size(rel_movie_act,1));
    p=zeros(1,size(rel_movie_act,1));
    if isempty(temp)
        break
    end
    for i=1:size(rel_movie_act,1)
        [r(i),p(i)] = corr(rel_movie_act_MEAN',rel_movie_act(i,:)');
    end
    rel_movie_act_notCorr=rel_movie_act(r<0.5,:);
    activations=rel_movie_act_notCorr;
    activations=activations-rel_movie_act_MEAN;
    
    %plot
    figure(figNum)
    subplot(2,size(filt_movie,2),fixation_num+size(filt_movie,2))
    hold on
    plot(time(1:L),activations)
    plot(time(1:L),mean(activations),'rh')
    plot(time(1:L),rel_movie_act_MEAN,'k')
end