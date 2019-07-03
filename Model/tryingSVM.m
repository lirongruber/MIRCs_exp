
X=[forSVM{1}(:,1:8) ; forSVM{2}(:,1:8)];
Y=zeros(size(X,1),1);
Y(size(forSVM{1},1)+1:end,1)=1;
XX=X(nansum(X,2)~=0,:);
YY=Y(nansum(X,2)~=0);

n=0;
label={};
correct=[];
for i=1:1:150
    n=n+1;
    X_train=XX([1:i-1 i+1:end],:);
    Y_train=YY([1:i-1 i+1:end]);
    x_test=XX(i,:);
    y_label=YY(i);
    SVMModel = fitcsvm(X_train,Y_train,'KernelFunction','rbf','Standardize',true,'ClassNames',{'0','1'});
    [label(n),score] = predict(SVMModel,x_test);
    suc=strcmp(label{n},num2str(y_label));
    correct(n)=double(suc);
end
sum(correct)/n