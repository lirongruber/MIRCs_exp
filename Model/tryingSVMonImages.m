% simple SVN on the 20 images....
clear
close all
movies_path='C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo\ImagesForExp';
folders={'MIRCs','subMIRCs'};
PicsNames={'eagle', 'bike' , 'horse' , 'fly' , 'cardoor' , 'suit','eyeglasses','ship','eye','plane'};


folderNum=0;
X={};

for folder=folders
    folderNum=folderNum+1;
    picNum=0;
    for currPic = PicsNames
        picNum=picNum+1;
        images = dir([movies_path '\' folder{1,1}]);
        for currImg=images'
            imageName=regexp(currImg.name,'_','split');
            imageName_forCMP=imageName{1};
            if strcmp(imageName_forCMP,currPic)
                [myimgfile,map]=imread(currImg.name);
                myimgfile=imresize(myimgfile,[198 198]);
%                 figure; imshow(myimgfile)
                functions(picNum,:)=myimgfile(:)';
            end
        end
    end
    X{folderNum}=functions;
end
%%

        Y=zeros(2*size(X{1},1),1);
        Y(1:size(X{1},1))=1;
        XX=double([X{1} ; X{2}]);%(nansum(X,2)~=0,:);
        YY=double(Y);%(nansum(X,2)~=0);
        
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
%             y_test(totalNlabels,:)=[YY(idx_1(i)) YY(idx_0(i))];
                        y_test(totalNlabels,:)=[randi(2)-1 randi(2)-1];
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
        perCorrect_final(1,1)=sum(label_final(:)==y_test(:))/(2*totalNlabels);
        perCorrect_f(1,1)=sum(label_f(:)==y_test(:))/(2*totalNlabels);
        perCorrect_g(1,1)=sum(label_g(:)==y_test(:))/(2*totalNlabels);
        perCorrect_l(1,1)=sum(label_l(:)==y_test(:))/(2*totalNlabels);
        
        
        disp(['Majority vote: ' num2str(perCorrect_final)])
        disp(['Fourier kernel: ' num2str(perCorrect_f)])
        disp(['Gaussian kernel: ' num2str(perCorrect_g)])
        disp(['Linear kernel: ' num2str(perCorrect_l)])
        tilefigs;
