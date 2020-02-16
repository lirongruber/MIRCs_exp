% close all

clearvars -except class

colors={[74,77,255]./255,[246,75,75]./255};
folders={'Recognized','Not Recognized'};

% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};
% class={ class{1,:} ; class{4,:} };
% class={ class{1,:} class{3,:} ; class{2,:}  class{4,:} };
% class=control_class;
% class=one_class;

forSVM={};
for c=1:size(class,1)
    functions=nan(1,100);
    rel=1;
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            %curr=currT.FPCA_functions;
            curr=currT.meanRecActivation;
            singleFixation=0;
            if singleFixation==1
                relFixation=min(4,size(curr,2));%min(1,size(curr,2)); % which fixation to take
            else
                concat=[];
                relFixation=1:min(4,size(curr,2));
            end
            for fixationNum=relFixation % which fixation to take - 1:size(curr,2)
                if ~isempty(curr{1,fixationNum})
                    if singleFixation==1
                        %mean activation:
                        functions(rel,1:size(curr{1,fixationNum},2))=curr{1,fixationNum};
                        rel=rel+1;
                        %fpca:
                        %PCAfunctionNum=1; % which PCA# function to take
                        %functions(rel,1:size(curr{1,fixationNum},1))=curr{1,fixationNum}(:,PCAfunctionNum)';
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


% forSVM{1}=Shuffle(forSVM{1},2);
% forSVM{2}=Shuffle(forSVM{2},2);
if singleFixation==1
    l=min(size(forSVM{1}(:,5:end),2),size(forSVM{1}(:,5:end),2));% after 50 ms - cutting the begining for class
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

perCorrect=[];

    totalNlabels=0;
    label_f={};
    label_g={};
    label_l={};
    label_final={};
    correct=[];
    %     idx=randi([2 size(XX,1)],1,100);
    idx=2:size(XX,1);
    for i=idx
        totalNlabels=totalNlabels+1;
        X_train=XX([1:i-1 i+1:end],:);
        Y_train=YY([1:i-1 i+1:end]);
        x_test=XX(i,:);
        y_test(totalNlabels)=YY(i);
%         y_test=randi(2)-1;
        % SVM
        SVMModel_f = fitcsvm(X_train,Y_train,'KernelFunction','myFourierKernel','Standardize',true,'ClassNames',{'0','1'});
        SVMModel_g = fitcsvm(X_train,Y_train,'KernelFunction','rbf','Standardize',true,'ClassNames',{'0','1'});
        SVMModel_l = fitcsvm(X_train,Y_train,'KernelFunction','linear','Standardize',true,'ClassNames',{'0','1'});
%         SVMModel = fitcsvm(X_train,Y_train,'OptimizeHyperparameters','all','ClassNames',{'0','1'});
% %     Agreement between few models:majoraty vote
        [label_f(totalNlabels),score] = predict(SVMModel_f,x_test);
        [label_g(totalNlabels),score] = predict(SVMModel_g,x_test);
        [label_l(totalNlabels),score] = predict(SVMModel_l,x_test);
        
        if strcmp(label_f{totalNlabels},label_g{totalNlabels})
            label_final{totalNlabels}=label_f{totalNlabels};
        else if strcmp(label_g{totalNlabels},label_l{totalNlabels})
            label_final{totalNlabels}=label_g{totalNlabels};
            else if strcmp(label_l{totalNlabels},label_f{totalNlabels})
               label_final{totalNlabels}=label_l{totalNlabels}; 
                end
            end
        end
    end
    
    testFor=label_final;
    new=[];
    for i=1:size(testFor,2)
        new=[new str2num(testFor{i})];
    end
    correct=double(new==y_test);
    perCorrect=sum(correct)/totalNlabels
    
    % figure
% plot(XX(1:size(forSVM{1}(:,1:rel),1),:)')
% hold on
% plot(nanmean(XX(1:size(forSVM{1}(:,1:rel),1),:)),'k')
% figure
% plot(XX(size(forSVM{1}(:,1:rel),1)+1:end,:)')
% hold on
% plot(nanmean(XX(size(forSVM{1}(:,1:rel),1)+1:end,:)),'k')



