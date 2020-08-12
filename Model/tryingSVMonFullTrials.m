% close all
clear


load('classFullTrials.mat')
classFull=class;

slidingWindowSize=50;
slidingJumps=10;
i=1;
row=1;
while i<(376-slidingWindowSize)
    windows(row,:)=[i:(i+slidingWindowSize)];
    row=row+1;
    i=i+slidingJumps;
end

for numberOfWindows=1:size(windows,1)
    currWindow=windows(numberOfWindows,:);
    for repetition=1:2
        class={ classFull{1,:} classFull{3,:} ; classFull{2,:}  classFull{4,:} };
        func_flag=ones(size(class));
        func_flag(1,size(class,2)/2+1:end)=2;
        func_flag(2,size(class,2)/2+1:end)=2;

        clearvars -except classFull class windows slidingWindowSize func_flag numberOfWindows currWindow repetition perCorrect_final perCorrect_l perCorrect_g perCorrect_f perCorrect_MIRCs perCorrect_subMIRCs
        singleFixation=1;
        forSVM={};
        for c=1:size(class,1)
            functions=nan(1,100);
            rel=1;
            for t=1:size(class,2)%trialsToTake(1:163) %
                currT=class(c,t);
                currFlag=func_flag(c,t);
                currT=currT{1,1};
                if isfield(currT, 'meanRecActivation') || isfield(currT, 'perFrameEntropy')%~isempty(currT.meanRecActivation)
                     if size(currT.meanRecActivation{1,1},2)>=currWindow(end)
                         curr=currT.meanRecActivation{1,1}(currWindow);%(1:currWindow(end));%
                    %                     if isfield(currT, 'meanActivationBeforeCorr')
                    %                         curr=currT.meanActivationBeforeCorr(window);
                    % %                         curr=currT.activationPlosMEAN(window);
                    %                     else
                    %                         curr={0};
                    %                     end
                    %                                         curr=currT.perFrameEntropy(window);
%                                         curr=currT.Speed(window);                   
                       
                                %mean activation or speed or Entropy:
                                functions(rel,1:size(curr,2))=curr;
                                end_flags(rel)=currFlag;
                                rel=rel+1;
                        end
                end
            end
            howToCut=2;
            functions(functions==0)=nan;
            n_time=sum(isnan(functions));
            n_time=find(n_time<size(functions,1)/howToCut);
            n_last(c)=n_time(end);
            
            functions=functions(:,1:n_last(c));
            n_sample=sum(isnan(functions),2);
            n_sample=n_sample<size(functions,2)/howToCut;
            functions=functions(n_sample==1,:);
            end_flags=end_flags(n_sample==1);
            
            forSVM{c}=functions;
            flags_forSVM{c}=end_flags;
        end
        
        [forSVM{1},  order1]=Shuffle(forSVM{1},2);
        flags_forSVM{1}=flags_forSVM{1}(order1(:,1));
        [forSVM{2}, order2]=Shuffle(forSVM{2},2);
        flags_forSVM{2}=flags_forSVM{2}(order2(:,1));

        if singleFixation==1
            l=min(size(forSVM{1}(:,7:end),2),size(forSVM{2}(:,7:end),2));% after 50 ms - cutting the begining for class
            trialPerGroup=min(size(forSVM{1},1),size(forSVM{2},1));% making sure same group sizes
            X=[forSVM{1}(1:trialPerGroup,end-l+1:end) ; forSVM{2}(1:trialPerGroup,end-l+1:end)];
            X_flags=[flags_forSVM{1}(1:trialPerGroup) , flags_forSVM{2}(1:trialPerGroup)];
            %             X=[forSVM{1}(1:trialPerGroup,7:6+l) ; forSVM{2}(1:trialPerGroup,7:6+l)];
            
        else
            l=min(size(forSVM{1},2),size(forSVM{2},2));
            trialPerGroup=min(size(forSVM{1},1),size(forSVM{2},1));
            %             X=[forSVM{1}(1:trialPerGroup,end-l+1:end) ; forSVM{2}(1:trialPerGroup,end-l+1:end)];
            X=[forSVM{1}(1:trialPerGroup,7:6+l) ; forSVM{2}(1:trialPerGroup,7:6+l)];
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
        test_flags=[];
        for i=1:idx_1(end)
            totalNlabels=totalNlabels+1;
            leaveOut=setdiff(1:size(XX,1),[idx_1(i) idx_0(i)]);
            X_train=XX(leaveOut,:);
            Y_train=YY(leaveOut);
            x_test=[XX(idx_1(i),:);  XX(idx_0(i),:)];
            test_flags=[test_flags ; X_flags(idx_1(i)); X_flags(idx_0(i))];
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
        %         perCorrect_final(numberOfWindows,repetition)=sum(label_final(:)==y_test(:))/(2*totalNlabels);
        %         perCorrect_f(numberOfWindows,repetition)=sum(label_f(:)==y_test(:))/(2*totalNlabels);
        %         perCorrect_g(numberOfWindows,repetition)=sum(label_g(:)==y_test(:))/(2*totalNlabels);
        perCorrect_l(numberOfWindows,repetition)=sum(label_l(:)==y_test(:))/(2*totalNlabels);
        
        m_labels=label_l(test_flags==1);
        m_test=y_test(test_flags==1);
        perCorrect_MIRCs(numberOfWindows,repetition)=sum(m_labels(:)==m_test(:))/(totalNlabels);
        
        s_labels=label_l(test_flags==2);
        s_test=y_test(test_flags==2);
        perCorrect_subMIRCs(numberOfWindows,repetition)=sum(s_labels(:)==s_test(:))/(totalNlabels);
        
        disp(['Fixation: ' num2str(numberOfWindows) ' repitition: ' num2str(repetition)])
    end
end

figure(1)
s=0;
colors={[32,178,170]./255,[178,32,40]./255};
titles={'Linear kernel'};%{'Majority vote', 'Fourier kernel', 'Gaussian kernel', 'Linear kernel'};
titles={'SVM classification'};

for test={perCorrect_l} %{perCorrect_final, perCorrect_f, perCorrect_g, perCorrect_l}
    s=s+1;
    %     subplot(1,4,s)
    errorbar(windows(:,1)',mean(test{1}',1),std(test{1}',1),'color',colors{1},'LineWidth',2)
    hold on
    plot(0:375, 0.5*ones(1,376),'k--')
    ylabel('percent correct')
    xlabel('starting time')
    axis([0 375 0.2 0.8])
    title(titles{s})
end
legend(['window=' num2str(slidingWindowSize*8) ' ms'])
box off


% figure(2)
% s=0;
% colors={[32,178,170]./255,[178,32,40]./255};
% titles={'SVM classification'};%{'Majority vote', 'Fourier kernel', 'Gaussian kernel', 'Linear kernel'};
% leg={'MIRCs','', 'subMIRCs'};
% 
% for test={perCorrect_MIRCs,perCorrect_subMIRCs} %{perCorrect_final, perCorrect_f, perCorrect_g, perCorrect_l}
%     s=s+1;
%     %     subplot(1,4,s)
%     errorbar(1:size(test{1},1),mean(test{1}',1),std(test{1}',1),'color',colors{s},'LineWidth',2)
%     hold on
%     plot(0:40, 0.5*ones(1,41),'k--')
%     ylabel('percent correct')
%     xlabel('fixation number')
%     axis([0 40 0.2 0.8])
%     title(titles{1})
% end
% legend(leg)
% box off

% figure
% plot(XX(1:size(forSVM{1}(:,1:rel),1),:)')
% hold on
% plot(nanmean(XX(1:size(forSVM{1}(:,1:rel),1),:)),'k')
% figure
% plot(XX(size(forSVM{1}(:,1:rel),1)+1:end,:)')
% hold on
% plot(nanmean(XX(size(forSVM{1}(:,1:rel),1)+1:end,:)),'k')



