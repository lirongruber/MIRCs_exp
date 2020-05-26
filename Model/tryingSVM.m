% close all
clear

colors={[74,77,255]./255,[246,75,75]./255};
folders={'Recognized','Not Recognized'};

% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};
% class=control_class;

% load('control_class3.mat')
% classFull=control_class;

load('classEntropy.mat')
classFull=class;

% load('class.mat')
% classFull=class;

for FixationNumToUse=1:7
    for repetition=1:2
%         s1=Shuffle(1:144); s2=Shuffle(1:56); s3=Shuffle(1:107); s4=Shuffle(1:93);
%         class={ classFull{1,s1(1:56)} classFull{3,s3(1:56)} ; classFull{2,s2(1:56)}  classFull{4,s4(1:56)} };
        class={ classFull{1,:} classFull{3,:} ; classFull{2,:}  classFull{4,:} };
        clearvars -except classFull class FixationNumToUse repetition perCorrect_final perCorrect_l perCorrect_g perCorrect_f
        singleFixation=1;
        forSVM={};
        for c=1:size(class,1)
            functions=nan(1,100);
            rel=1;
%             trialsToTake=Shuffle(1:size(class,2));
            for t=1:size(class,2)%trialsToTake(1:163) %
                currT=class(c,t);
                currT=currT{1,1};
                if isfield(currT, 'meanRecActivation') || isfield(currT, 'perFrameEntropy')%~isempty(currT.meanRecActivation)
                    %                     curr=currT.FPCA_functions;
                    %                     curr=currT.meanRecActivation;
                    curr=currT.perFrameEntropy;
                    %                     curr=currT.Speed;
                    if singleFixation==1
                        relFixation=min(FixationNumToUse,size(curr,2));%%max(1,size(curr,2)-FixationNumToUse+1); %% which fixation to take
                    else
                        concat=[];
                        relFixation=1:min(FixationNumToUse,size(curr,2));%max(1,size(curr,2)-FixationNumToUse+1):size(curr,2); %
                    end
                    for fixationNum=relFixation % which fixation to take - 1:size(curr,2)
                        if ~isempty(curr{1,fixationNum})
                            if singleFixation==1
                                %mean activation or speed:
                                functions(rel,1:size(curr{1,fixationNum},2))=curr{1,fixationNum};
                                %Entropy
                                functions(rel,1:size(curr{1,fixationNum},2)-7)=curr{1,fixationNum}(8:end);
%                                 figure; plot(curr{1,fixationNum});
%                                 close all
                                %fpca:
                                %                                 PCAfunctionNum=1; % which PCA# function to take
                                %                                 PCArel=curr{1,fixationNum};
                                %                                 functions(rel,1:size(curr{1,fixationNum},1))=PCArel(:,min(PCAfunctionNum,size(PCArel,2)))';
                                %                                 functions(rel,1:size(curr{1,fixationNum},1))=mean(PCArel,2)';
%                                 functions(rel,1:size(curr{1,fixationNum},1))=sum(PCArel,2)';

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
%             l=min(size(forSVM{1}(:,1:end),2),size(forSVM{2}(:,1:end),2));% after 50 ms - cutting the begining for class
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
%             SVMModel_f = fitcsvm(X_train,Y_train,'KernelFunction','myFourierKernel','Standardize',true);
%             SVMModel_g = fitcsvm(X_train,Y_train,'KernelFunction','rbf','Standardize',true);
            SVMModel_l = fitcsvm(X_train,Y_train,'KernelFunction','linear','Standardize',true);
% %             %         SVMModel = fitcsvm(X_train,Y_train,'OptimizeHyperparameters','all');
            % %     Agreement between few models:majority vote
%             [label_f(totalNlabels,:),score_f] = predict(SVMModel_f,x_test);
%             [label_g(totalNlabels,:),score_g] = predict(SVMModel_g,x_test);
            [label_l(totalNlabels,:),score_l] = predict(SVMModel_l,x_test);
            
          
        end
%         label_final=zeros(size(label_f));
%         label_final(label_f+label_g+label_l>=2)=1;
%         perCorrect_final(FixationNumToUse,repetition)=sum(label_final(:)==y_test(:))/(2*totalNlabels);
%         perCorrect_f(FixationNumToUse,repetition)=sum(label_f(:)==y_test(:))/(2*totalNlabels);
%         perCorrect_g(FixationNumToUse,repetition)=sum(label_g(:)==y_test(:))/(2*totalNlabels);
        perCorrect_l(FixationNumToUse,repetition)=sum(label_l(:)==y_test(:))/(2*totalNlabels);
        disp(['Fixation: ' num2str(FixationNumToUse) ' repitition: ' num2str(repetition)])
    end
end

figure(2)
s=0;
titles={'Linear kernel'};%{'Majority vote', 'Fourier kernel', 'Gaussian kernel', 'Linear kernel'};
for test={perCorrect_l} %{perCorrect_final, perCorrect_f, perCorrect_g, perCorrect_l}
    s=s+1;
    subplot(1,4,s)
    errorbar(1:size(test{1},1),mean(test{1}',1),std(test{1}',1))
    hold on
    plot(0:8, 0.5*ones(1,9),'--')
    ylabel('percent correct')
    xlabel('fixation number')
    axis([0 10 0.2 0.8])
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



