% Training SVMs per frame/s
% close all
clear
colors={[74,77,255]./255,[246,75,75]./255};
folders={'Recognized','Not Recognized'};



movies_path='C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\videos';
folders={'MIRCs_yes','MIRCs_no','subMIRCs_yes','subMIRCs_no'};

for FixationNumToUse=1:7
    for repetition=1:2
        clearvars -except movies_path folders FixationNumToUse repetition perCorrect_final perCorrect_l perCorrect_g perCorrect_f
        forSVM={};
        folder_num=0;
        for folder=folders
            folder_num=folder_num+1;
            movies = dir([movies_path '\' folder{1,1}]);
            rel=1;
            functions=nan(1,1);
            for currMov = movies'
                if ~strcmp(currMov.name,'.') && ~strcmp(currMov.name,'..') && ~strcmp(currMov.name(end-4),'r')
                    load([movies_path '\' folder{1,1} '\' currMov.name], 'filt_movie');
                    relFixation=min(FixationNumToUse,size(filt_movie,2));
%                     %fixation start frame
%                     currT=filt_movie{1,relFixation}(:,:,2);
%                     %fixation mean frame
%                     currT=mean(filt_movie{1,relFixation}(:,:,:),3);
%                     %fixation end frame
                    currT=filt_movie{1,relFixation}(:,:,end-1);
                    
                    functions(rel,1:size(currT(currT~=0)',2))=currT(currT~=0)';
                    rel=rel+1;
                    disp(['trial =' num2str(rel)])
                end
            end
            forSVM{folder_num}=functions;
        end
        forSVM={ [forSVM{1,1} ; forSVM{1,3}] , [forSVM{1,2} ; forSVM{1,4} ]};
        forSVM{1}=Shuffle(forSVM{1},2);
        forSVM{2}=Shuffle(forSVM{2},2);
        
        l=min(size(forSVM{1}(:,1:end),2),size(forSVM{2}(:,1:end),2));
        trialPerGroup=min(size(forSVM{1},1),size(forSVM{2},1));% making sure same group sizes
        X=[forSVM{1}(1:trialPerGroup,end-l+1:end) ; forSVM{2}(1:trialPerGroup,end-l+1:end)];
        
        Y=zeros(size(X,1),1);
        Y(1:size(X,1)/2)=1;
        XX=X;%(nansum(X,2)~=0,:);
        YY=Y;%(nansum(X,2)~=0);
        
        totalNlabels=0;
%         label_f=[];
%         label_g=[];
        label_l=[];
        y_test=[];
        %     idx=randi([2 size(XX,1)],1,100);
        idx_1=1:size(XX,1)/2;
        idx_0=size(XX,1)/2+1:size(XX,1);
        for i=1:idx_1(end)
            disp(num2str(i))
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
            %         SVMModel = fitcsvm(X_train,Y_train,'OptimizeHyperparameters','all');
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

figure(3)
s=0;
titles={'Linear kernel'};%{'Majority vote', 'Fourier kernel', 'Gaussian kernel', 'Linear kernel'};
for test={ perCorrect_l} %{perCorrect_final, perCorrect_f, perCorrect_g, perCorrect_l}
    s=s+1;
    subplot(1,4,s)
    errorbar(1:size(test{1},1),mean(test{1}',1),std(test{1}',1))
    hold on
    plot(0:8, 0.5*ones(1,9),'--')
    ylabel('percent correct')
    xlabel('fixation number')
    axis([0 10 0.35 0.8])
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



