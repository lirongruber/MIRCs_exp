% close all


colors={[74,77,255]./255,[246,75,75]./255};
folders={'Recognized','Not Recognized'};

% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};
% class={ class{1,:} ; class{4,:} };
% class={ class{1,:} class{3,:} ; class{2,:}  class{4,:} };
% class=one_class;
% class=control_class;

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
            singleFixation=1;
            if singleFixation==1
                relFixation=min(1,size(curr,2)); % which fixation to take
            else
                concat=[];
                relFixation=1:size(curr,2);
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
                        concat=[concat curr{1,fixationNum}]; % only if more then one fixation
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
    n=sum(isnan(functions));
    n=find(n<size(functions,1)/2);
    n_last(c)=n(end);
    functions=functions(:,1:n_last(c));
    forSVM{c}=functions;
end



rel=min(n_last);
X=[forSVM{1}(:,1:rel) ; forSVM{2}(:,1:rel)];
Y=zeros(size(X,1),1);
Y(size(forSVM{1},1)+1:end,1)=1;
XX=X;%(nansum(X,2)~=0,:);
YY=Y;%(nansum(X,2)~=0);

perCorrect=[];
for b=1 %1:10
    totalNlabels=0;
    label={};
    correct=[];
    %     idx=randi([2 size(XX,1)],1,100);
    idx=2:size(XX,1);
    for i=idx
        totalNlabels=totalNlabels+1;
        X_train=XX([1:i-1 i+1:end],:);
        Y_train=YY([1:i-1 i+1:end]);
        x_test=XX(i,:);
        y_test=YY(i);
%         y_test=randi(2)-1;
        % SVM
        SVMModel = fitcsvm(X_train,Y_train,'KernelFunction','rbf','Standardize',true,'ClassNames',{'0','1'});
%         SVMModel = fitcsvm(X_train,Y_train,'OptimizeHyperparameters','all','ClassNames',{'0','1'});
        [label(totalNlabels),score] = predict(SVMModel,x_test);
        suc=strcmp(label{totalNlabels},num2str(y_test));
        correct(totalNlabels)=double(suc);
    end
    perCorrect(b)=sum(correct)/totalNlabels;
end

% XX_K=XX;
% XX_K(isnan(XX_K))=0;
% kmeans_options=kmeans(XX_K,2);

figure
plot(XX(1:size(forSVM{1}(:,1:rel),1),:)')
hold on
plot(nanmean(XX(1:size(forSVM{1}(:,1:rel),1),:)),'k')
figure
plot(XX(size(forSVM{1}(:,1:rel),1)+1:end,:)')
hold on
plot(nanmean(XX(size(forSVM{1}(:,1:rel),1)+1:end,:)),'k')

perCorrect
mean(perCorrect)