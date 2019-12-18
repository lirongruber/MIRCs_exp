% close all
% colors={[2,122,164]./256,[245,218,95]./256,[65,173,73]./256,[244,147,31]./256}; % blue yellow green orange
% folders={'MIRCs Yes','MIRCs No','subMIRCs Yes','subMIRCs No'};

colors={[2,122,164]./256,[244,147,31]./256}; % blue yellow green orange
folders={'MIRCs Yes','subMIRCs No'};
% class={ class{1,:} ; class{4,:} };
% class=one_class;
% class=control_class;
STDforOutL=2; %number of std from mean to include
perNonNan2include=0.9;

forSVM={};
numofSubPlot=size(folders,2)+1;
for c=1:size(class,1)
    functions=nan(1,100);
    rel=1;
    for t=1:size(class,2)
        currT=class(c,t);
        currT=currT{1,1};
        if ~isempty(currT)
            curr=currT.FPCA_functions;
            concat=[];
            for row=1 %1:size(curr,2)
%                                 functions(rel:rel+size(curr{1,row},2)-1,1:size(curr{1,row},1))=curr{1,row}';
%                                 rel=rel+size(curr{1,row},2);
                
%                                 functions(rel,1:size(curr{1,row}(:),1))=curr{1,row}(:)';
%                                 rel=rel+1;
                
                if ~isempty(curr{1,row})
                    functions(rel,1:size(curr{1,row},1))=curr{1,row}(:,1)';
                    rel=rel+1;
                end
                
%                                 concat=[concat curr{1,row}(:)'];
            end
%                         functions(rel,1:size(concat,2))=concat;
%                         rel=rel+1;
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

% K-MEANS
XX_kmeans=XX;
XX_kmeans(isnan(XX_kmeans))=0;
kmeans_idx = kmeans(XX_kmeans,2);

perCorrect=[];
for b=1 %1:10
    n=0;
    label={};
    correct=[];
%     idx=randi([2 size(XX,1)],1,100);
    idx=2:size(XX,1);
    for i=idx
        n=n+1;
        X_train=XX([1:i-1 i+1:end],:);
        Y_train=YY([1:i-1 i+1:end]);
        x_test=XX(i,:);
        y_label=YY(i);
        % SVM
        SVMModel = fitcsvm(X_train,Y_train,'KernelFunction','rbf','Standardize',true,'ClassNames',{'0','1'});
        [label(n),score] = predict(SVMModel,x_test);
        suc=strcmp(label{n},num2str(y_label));
        correct(n)=double(suc);
    end
    perCorrect(b)=sum(correct)/n;
end

XX_K=XX;
XX_K(isnan(XX_K))=0;
kmeans_options=kmeans(XX_K,2);

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