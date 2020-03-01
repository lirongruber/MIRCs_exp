% Training SVMs per frame/s
% close all
clear
colors={[74,77,255]./255,[246,75,75]./255};
folders={'Recognized','Not Recognized'};



movies_path='C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\videos';
folders={'MIRCs_yes','MIRCs_no','subMIRCs_yes','subMIRCs_no'};

class_num=0;
for folder=folders
    class_num=class_num+1;
    movies = dir([movies_path '\' folder{1,1}]);
    mov_nom=0;
    for currMov = movies'
        if ~strcmp(currMov.name,'.') && ~strcmp(currMov.name,'..') && ~strcmp(currMov.name(end-4),'r')
            mov_nom=mov_nom+1;
            load([movies_path '\' folder{1,1} '\' currMov.name]);
            
            functions=nan(402,402);
            rel=1;
            for t=1:size(movie,3)
                currT=movies(:,:,t);
                if sum(currT(:))~=0
                    functions(rel,size(currT(:),2))=currT(:);
                    rel=rel+1;
                end
            end
            
            forSVM{class_num}=functions;
                    
        end
    end
end

clearvars -except class
for FixationNumToUse=1:7
    for repetition=1:2
        clearvars -except class FixationNumToUse repetition perCorrect_final perCorrect_l perCorrect_g perCorrect_f
        singleFixation=1;
        forSVM={};
        for c=1:size(class,1)
            functions=nan(1,100);
            rel=1;
%             trialsToTake=Shuffle(1:size(class,2));
            for t=1:size(class,2)%trialsToTake(1:163) %
                currT=class(c,t);
                currT=currT{1,1};
                if ~isempty(currT)
%                     curr=currT.FPCA_functions;
                    curr=currT.meanRecActivation;
%                     curr=currT.Speed;
                    if singleFixation==1
                        relFixation=min(FixationNumToUse,size(curr,2));%max(1,size(curr,2)-FixationNumToUse+1); %% which fixation to take
                    else
                        concat=[];
                        relFixation=1:min(FixationNumToUse,size(curr,2));%max(1,size(curr,2)-FixationNumToUse+1):size(curr,2); %
                    end
                    for fixationNum=relFixation % which fixation to take - 1:size(curr,2)
                        if ~isempty(curr{1,fixationNum})
                            if singleFixation==1
                                %mean activation:
                                functions(rel,1:size(curr{1,fixationNum},2))=curr{1,fixationNum};
                                %fpca:
%                                 PCAfunctionNum=1; % which PCA# function to take
%                                 functions(rel,1:size(curr{1,fixationNum},1))=curr{1,fixationNum}(:,PCAfunctionNum)';
                                rel=rel+1;
                            else
                                concat=[concat curr{1,fixationNum}(5:end)]; % after 50 ms
                                %concat=[concat curr{1,fixationNum}(:,PCAfunctionNum)'];
                            end
                        end
                    end
                    if singleFixation~=1
                        functions(rel,1:size(concat,2))=concat;
                        rel=rel+1;
                    end
                end
            end
            functions(functions==0)=nan;
            n_time=sum(isnan(functions));
            n_time=find(n_time<size(functions,1)/2);
            n_last(c)=n_time(end);
            
            functions=functions(:,1:n_last(c));
            n_sample=sum(isnan(functions),2);
            n_sample=n_sample<size(functions,2)/2;
            functions=functions(n_sample==1,:);
            
            forSVM{c}=functions;
        end
        
        forSVM{1}=Shuffle(forSVM{1},2);
        forSVM{2}=Shuffle(forSVM{2},2);
        if singleFixation==1
            l=min(size(forSVM{1}(:,5:end),2),size(forSVM{2}(:,5:end),2));% after 50 ms - cutting the begining for class
            trialPerGroup=min(size(forSVM{1},1),size(forSVM{2},1));% making sure same group sizes
            X=[forSVM{1}(1:trialPerGroup,end-l+1:end) ; forSVM{2}(1:trialPerGroup,end-l+1:end)];
        else
            l=min(size(forSVM{1},2),size(forSVM{2},2));
            trialPerGroup=min(size(forSVM{1},1),size(forSVM{2},1));
            X=[forSVM{1}(1:trialPerGroup,end-l+1:end) ; forSVM{2}(1:trialPerGroup,end-l+1:end)];
        end
        
        Y=zeros(size(X,1),1);
        Y(1:size(X,1)/2)=1;
        XX=X;%(nansum(X,2)~=0,:);
        YY=Y;%(nansum(X,2)~=0);
        
        totalNlabels=0;
        label_f=[];
        label_g=[];
        label_l=[];
        y_test=[];
        %     idx=randi([2 size(XX,1)],1,100);
        idx_1=1:size(XX,1)/2;
        idx_0=size(XX,1)/2+1:size(XX,1);
        for i=1:idx_1(end)
            totalNlabels=totalNlabels+1;
            leaveOut=setdiff(1:size(XX,1),[idx_1(i) idx_0(i)]);
            X_train=XX(leaveOut,:);
            Y_train=YY(leaveOut);
            x_test=[XX(idx_1(i),:);  XX(idx_0(i),:)];
            y_test(totalNlabels,:)=[YY(idx_1(i)) YY(idx_0(i))];
%             y_test(totalNlabels,:)=[randi(2)-1 randi(2)-1];
            % SVM
            SVMModel_f = fitcsvm(X_train,Y_train,'KernelFunction','myFourierKernel','Standardize',true);
            SVMModel_g = fitcsvm(X_train,Y_train,'KernelFunction','rbf','Standardize',true);
            SVMModel_l = fitcsvm(X_train,Y_train,'KernelFunction','linear','Standardize',true);
            %         SVMModel = fitcsvm(X_train,Y_train,'OptimizeHyperparameters','all');
            % %     Agreement between few models:majority vote
            [label_f(totalNlabels,:),score_f] = predict(SVMModel_f,x_test);
            [label_g(totalNlabels,:),score_g] = predict(SVMModel_g,x_test);
            [label_l(totalNlabels,:),score_l] = predict(SVMModel_l,x_test);
            
          
        end
        label_final=zeros(size(label_f));
        label_final(label_f+label_g+label_l>=2)=1;
        perCorrect_final(FixationNumToUse,repetition)=sum(label_final(:)==y_test(:))/(2*totalNlabels);
        perCorrect_f(FixationNumToUse,repetition)=sum(label_f(:)==y_test(:))/(2*totalNlabels);
        perCorrect_g(FixationNumToUse,repetition)=sum(label_g(:)==y_test(:))/(2*totalNlabels);
        perCorrect_l(FixationNumToUse,repetition)=sum(label_l(:)==y_test(:))/(2*totalNlabels);
        disp(['Fixation: ' num2str(FixationNumToUse) ' repitition: ' num2str(repetition)])
    end
end

figure(1)
s=0;
titles={'Majority vote', 'Fourier kernel', 'Gaussian kernel', 'Linear kernel'};
for test={perCorrect_final, perCorrect_f, perCorrect_g, perCorrect_l}
    s=s+1;
    subplot(1,4,s)
    errorbar(1:size(test{1},1),mean(test{1}',1),std(test{1}',1))
    hold on
    plot(0:8, 0.5*ones(1,9),'--')
    ylabel('percent correct')
    xlabel('fixation number')
    axis([0 10 0 1])
    title(titles{s})
end

% figure
% plot(XX(1:size(forSVM{1}(:,1:rel),1),:)')
% hold on
% plot(nanmean(XX(1:size(forSVM{1}(:,1:rel),1),:)),'k')
% figure
% plot(XX(size(forSVM{1}(:,1:rel),1)+1:end,:)')
% hold on
% plot(nanmean(XX(size(forSVM{1}(:,1:rel),1)+1:end,:)),'k')



