% features for classifing recognise vs non-recognise retinal videos:

function [classfeatures]=features(filt_movie,details,plotFlag)
classfeatures=struct;

for fixation_num=1:size(filt_movie,2)
    tic
    
    %Parameters for fft analysis
    Fs=100;
    T=1/Fs;
    L=size(filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2),2);
    time=(0:L-1).*T.*1000;%ms
    f = Fs*(0:(L/2))/L;
    
    %Reduces number of lines to avoid redundancy
    temp=reshape(filt_movie{1,fixation_num},[402*402 L]);
    if mod(L,2)~=0
        temp=temp(:,2:end);
        L=L-1;
    end
    rel_movie_act=unique(temp, 'rows');
    
    rel_movie_act_MEAN=mean(rel_movie_act);
    r=zeros(1,size(rel_movie_act,1));
    p=zeros(1,size(rel_movie_act,1));
    if isempty(temp)
        break
    end
    for i=1:size(rel_movie_act,1)
        [r(i),p(i)] = corr(rel_movie_act_MEAN',rel_movie_act(i,:)');
    end
    rel_movie_act_notCorr=rel_movie_act(r<0.5,:);
    activations=rel_movie_act_notCorr;
    activations=activations-rel_movie_act_MEAN;
%     activations=abs(activations-rel_movie_act_MEAN);

    %speed
    vx=diff(details.XYdeg(1,filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2))).*Fs;
    vy=diff(details.XYdeg(2,filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2))).*Fs;
    v=sqrt(vx.^2+vy.^2);
    if (size(v,2))~=L
        v=[v v(end)];
    end
    % amp and dist and timeLength
    temp=[details.XYdeg(1,filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2));details.XYdeg(2,filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2))]';
    [amp,~,~] = EULength(temp);
    dist=EUDist(temp(1,:),temp(end,:));
    timeLength=time(end);
    
    % savings:
    classfeatures.Speed{fixation_num}=v;
    classfeatures.meanSpeed(fixation_num)=mean(v);
    if size(v,2)>9
        classfeatures.targetSpeed(fixation_num)=mean(v(10:end));
    else
        classfeatures.targetSpeed(fixation_num)=mean(v(end));
    end
    classfeatures.varSpeed(fixation_num)=var(v);
    
    classfeatures.ampFixation(fixation_num)=amp;
    classfeatures.distFixation(fixation_num)=dist;
    classfeatures.timeFixation(fixation_num)=timeLength;
    % init more savings
    classfeatures.numOfinfoRec(fixation_num)=0;
    classfeatures.meanInfoPerRec(fixation_num)=0;
    classfeatures.meanRecActivation{fixation_num}=0;
    classfeatures.varInfoPerRec(fixation_num)=0;
    classfeatures.movvarmeanInfoPerRec{fixation_num}=[];
    classfeatures.actCorrelations{fixation_num}=[];
    
    classfeatures.optNumClass_silhouette(fixation_num)=0;
    classfeatures.optNumClass_DaviesBouldin(fixation_num)=0;
    classfeatures.optNumClass_FPCA(fixation_num)=0;
    classfeatures.PCA_explained(fixation_num)=0;
    classfeatures.FPCA_explained(fixation_num)=0;
    classfeatures.PCA_Cnumber(fixation_num)=0;
    classfeatures.FPCA_functions{fixation_num}=[];
    
    if ~isempty(activations) && size(activations,1)<7000
        %activations
        meanActivation=mean(activations,1);
        infoRec=size(activations,1);
        varRec=sum(var(activations))/size(activations,2);
        %mean movvar act
        
        if plotFlag==1
            figure(1)
            subplot(2,ceil(size(filt_movie,2)/2),fixation_num)
            hold all
            plot(time(1:L),activations)
            %mean
            plot(time(1:L),meanActivation,'rh')
            text(10,2.5,['num of rec: ' num2str(infoRec)],'FontSize',15)
            xlabel('time [ms]')
            ylabel('activations')
            
            %Speed
            figure(2)
            subplot(2,ceil(size(filt_movie,2)/2),fixation_num)
            hold all
            plot(time(1:L),v)
            ylabel('speed [deg/sec]')
            xlabel('time [ms] ')
            axis([0 time(L) 0 12])
        end
        
        classfeatures.numOfinfoRec(fixation_num)=infoRec;
        classfeatures.meanInfoPerRec(fixation_num)=sum(meanActivation);
        classfeatures.meanRecActivation{fixation_num}=meanActivation;
        classfeatures.varInfoPerRec(fixation_num)=varRec;
        classfeatures.movvarmeanInfoPerRec{fixation_num}=movvar(meanActivation,10);
        classfeatures.actCorrelations{fixation_num}=r;
        
        %pca and classtering
%         [~,score,~,~,explained,~] = pca(activations);
%         c80=find(cumsum(explained)>=80,1);
        
%         kmeans_options=[];
%         if size(score,2)>2
%             for i=1:min(15,size(activations,1))
%                 kmeans_options(:,i)=kmeans(score(:,1:c80),i);
%             end
%             eva1 = evalclusters(score(:,1:c80),kmeans_options, 'silhouette'); %The silhouette value for each point is a measure of how similar that point is to points in its own cluster, when compared to points in other clusters.
%             eva2 = evalclusters(score(:,1:c80),kmeans_options, 'DaviesBouldin'); %The Davies-Bouldin criterion is based on a ratio of within-cluster and between-cluster distances.
            [no_opt,phi,FVE]=tryingFPCA(rel_movie_act,plotFlag);%plotFlag);
            
%             classfeatures.optNumClass_silhouette(fixation_num)=eva1.OptimalK;
%             classfeatures.optNumClass_DaviesBouldin(fixation_num)=eva2.OptimalK;
            classfeatures.optNumClass_FPCA(fixation_num)=no_opt;
%             classfeatures.PCA_explained(fixation_num)=sum(explained(1:c80));
            classfeatures.FPCA_explained(fixation_num)=FVE;
%             classfeatures.PCA_Cnumber(fixation_num)=c80;
            classfeatures.FPCA_functions{fixation_num}=phi;
%         end
        
        if plotFlag==1
            a1=kmeans_options(:,eva1.OptimalK);
            a2=kmeans_options(:,eva2.OptimalK);
            colors = [ 255,138,134 ; 255,255,162 ; 57,218,150 ; 200,235,255 ; 198,167,211 ; 234,175,102 ; 29,137,13 ; 193,55,173 ; 114,0,86 ; 40,206,68 ]./255;
            figure(100)
            if eva1.OptimalK<11
                subplot(2,2,1)
                % plot(score(:,1),score(:,2),'.')
                plot3(score(:,1),score(:,2),score(:,3),'.')
                % scatter(score(:,1),score(:,2),[],colors(a,:))
                scatter3(score(:,1),score(:,2),score(:,3),[],colors(a1,:))
                title(['number of classes=' num2str(eva1.OptimalK) ' PCA80=' num2str(c80)])
                subplot(2,2,2)
                for i=1:size(activations,1)
                    plot(activations(i,:),'color',colors(a1(i),:))
                    hold on
                end
            end
            if eva2.OptimalK<11
                subplot(2,2,3)
                % plot(score(:,1),score(:,2),'.')
                plot3(score(:,1),score(:,2),score(:,3),'.')
                % scatter(score(:,1),score(:,2),[],colors(a,:))
                scatter3(score(:,1),score(:,2),score(:,3),[],colors(a2,:))
                title(['number of classes=' num2str(eva2.OptimalK)])
                subplot(2,2,4)
                for i=1:size(activations,1)
                    plot(activations(i,:),'color',colors(a2(i),:))
                    hold on
                end
            end
        end
        
        
        %         %Autocorr and FFT of activations +xcorrs speed and activations
        %         r_auto_all=zeros(1,L);
        %         P1_act_final=zeros(1,L/2);
        %         for t=1:size(activations,1)
        %             [r_auto,lags_auto] = xcorr(activations(t,:),'coeff');
        %             r_auto_all(t,:)=r_auto(lags_auto>=0);
        %
        %             fft_act=fft(activations(t,:));
        %             P2_act = abs(fft_act/L);
        %             P1_act = P2_act(1:(L/2)+1);
        %             P1_act(2:end) = 2*P1_act(2:end);
        %             P1_act=P1_act(2:end);
        %             P1_act_final(t,:)=P1_act;
        %
        %         end
        
        
        %         if plotFlag==1
        %             figure(4)
        %             subplot(2,ceil(size(filt_movie,2)/2),fixation_num)
        %             hold all
        %             imagesc(r_auto_all,[-1 1])
        %             set(gca,'XTick',0:10:1000)
        %             set(gca,'XTickLabel',0:100:10000)
        %             xlabel('time [ms]')
        %             ylabel('activations - autocorr')
        %             set(gca,'YTickLabel',[])
        %
        %             figure(5)
        %             subplot(2,ceil(size(filt_movie,2)/2),fixation_num)
        %             hold all
        %             imagesc(P1_act_final,[-1 1])
        %             set(gca,'XTick',0:5:size(P1_act_final,2))
        %             set(gca,'XTickLabel',round(f(1:5:size(f,2))))
        %             colormap('jet')
        %             ylabel('activations - fft power')
        %             xlabel('freq [Hz]')
        %             set(gca,'YTickLabel',[])
        %
        %             M2=mean(P1_act_final,1);
        %             E2=ste(P1_act_final,1);
        %             xlim([0 size(M2,2)])
        %             %             yyaxis right
        %             %             plot(1:size(f,2)-1,P1_v)
        %             %             ylabel('speed - fft power')
        %             %             errorbar(M2.*mean(P1_v)/mean(M2),E2.*P1_v(1)/M2(1),'-k')
        %
        %
        %
        %
        %
        %         end
        
        
    end
    toc
end
% tilefigs;


end