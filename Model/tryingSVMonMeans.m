% close all
clear

folders={'Recognized','Not Recognized'};


load('class.mat')
classFull=class;
for options=1:2
    for repetition=1:5
        %         s1=Shuffle(1:144); s2=Shuffle(1:56); s3=Shuffle(1:107); s4=Shuffle(1:93);
        %         class={ classFull{1,s1(1:56)} classFull{3,s3(1:56)} ; classFull{2,s2(1:56)}  classFull{4,s4(1:56)} };
        class={ classFull{1,:} classFull{3,:} ; classFull{2,:}  classFull{4,:} };
        clearvars -except classFull class repetition perCorrect_final perCorrect_l options 
        forSVM={};
        for c=1:size(class,1)
            functions=nan(1,100);
            rel=1;
            %             trialsToTake=Shuffle(1:size(class,2));
            for t=1:size(class,2)%trialsToTake(1:163) %
                currT=class(c,t);
                currT=currT{1,1};
                if isfield(currT, 'meanRecActivation')
                    if options==1
                        curr=currT.targetSpeed;
                        inPlot=1;
                    else if options==2
                            curr=currT.meanInfoPerRec;
                            inPlot=2;
                        end
                    end
                    if ~isempty(curr)
                        functions(rel,1:size(curr,2))=curr;
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
            
            forSVM{c}=functions;
        end
        
        forSVM{1}=Shuffle(forSVM{1},2);
        forSVM{2}=Shuffle(forSVM{2},2);
        
        l=min(size(forSVM{1},2),size(forSVM{2},2));
        trialPerGroup=min(size(forSVM{1},1),size(forSVM{2},1));% making sure same group sizes
        X=[forSVM{1}(1:trialPerGroup,end-l+1:end) ; forSVM{2}(1:trialPerGroup,end-l+1:end)];
        
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
            
            SVMModel_l = fitcsvm(X_train,Y_train,'KernelFunction','linear','Standardize',true);
            
            [label_l(totalNlabels,:),score_l] = predict(SVMModel_l,x_test);
        end
        perCorrect_l(options,repetition)=sum(label_l(:)==y_test(:))/(2*totalNlabels);
        disp([' repitition: ' num2str(repetition)])
    end
end

colors={[178,32,40]./255,[32,178,170]./255};
figure(1)
axes('Position',[.6 .18 .26 .23])
errorbar(1,mean(perCorrect_l(1,:)),std(perCorrect_l(1,:)),'color',colors{1},'LineWidth',2)
hold on
errorbar(2,mean(perCorrect_l(2,:)),std(perCorrect_l(2,:)),'color',colors{2},'LineWidth',2)
xticks([1 2])
xticklabels({'Speed' ,'Activation'})
xtickangle(20)
yticks([0.4 0.5 0.6])
title('Mean values per fixation')
plot(0:3, 0.5*ones(1,4),'k--')
ylabel('percent correct')
axis([0 3 0.4 0.6])
box off







