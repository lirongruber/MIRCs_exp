% features for classifing recognise vs non-recognise retinal videos:

function [classfeatures]=features(filt_movie,details,plotFlag)
classfeatures=struct;
%         numOfinfoRec=[];
%         varOfinfoRec=[];
%         meanSpeed=[];
%         targetSpeed=[];
%         verSpeed=[];
%         xcorrSA_max={};
%         xcorrSAfft_max={};
        
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
    %speed
    vx=diff(details.XYdeg(1,filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2))).*Fs;
    vy=diff(details.XYdeg(2,filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2))).*Fs;
    v=sqrt(vx.^2+vy.^2);
    if (size(v,2))~=L
        v=[v v(end)];
    end
    % amp and dist
    temp=[details.XYdeg(1,filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2));details.XYdeg(2,filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2))]';
    [amp,~,~] = EULength(temp);
    dist=EUDist(temp(1,:),temp(end,:));
    
    %FFT of speed
    fft_v=fft(v);
    P2_v = abs(fft_v/L);
    P1_v = P2_v(:,1:(L/2)+1);
    P1_v(:,2:end) = 2*P1_v(:,2:end);
    P1_v=P1_v(:,2:end);
    
    if ~isempty(activations)
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
            plot(time(1:L),v.*100)
            ylabel('speed [deg/sec]')
            xlabel('time [ms] ')
            axis([0 time(L) 0 12])
        end
        
% % %         %Autocorr and FFT of activations +xcorrs speed and activations
% % %         r_auto_all=zeros(1,L);
% % %         r_SA_all=zeros(1,L);
% % %         P1_act_final=zeros(1,L/2);
% % %         r_ffts_all=zeros(1,L/2);
% % %         
% % %         for t=1:size(activations,1)
% % %             [r_auto,lags_auto] = xcorr(activations(t,:),'coeff');
% % %             r_auto_all(t,:)=r_auto(lags_auto>=0);
% % %             
% % %             [r_SA,lags_SA] = xcorr(v,activations(t,:),'coeff');
% % %             r_SA_all(t,:)=r_SA(lags_SA>=0);
% % %             
% % %             fft_act=fft(activations(t,:));
% % %             P2_act = abs(fft_act/L);
% % %             P1_act = P2_act(1:(L/2)+1);
% % %             P1_act(2:end) = 2*P1_act(2:end);
% % %             P1_act=P1_act(2:end);
% % %             P1_act_final(t,:)=P1_act;
% % %             
% % %             [r_ffts,lags_ffts] = xcorr(P1_v,P1_act,'coeff');
% % %             r_ffts_all(t,:)=r_ffts(lags_ffts>=0);
% % %         end
% % %         M_SA=mean(r_SA_all,1);
% % %         E_SA=ste(r_SA_all,1);
% % %         diffM_SA=find(diff(M_SA)>0);
% % %         if ~isempty(diffM_SA)
% % %             maxP_SA=find(diff(diffM_SA)>1);
% % %             if ~isempty(maxP_SA)
% % %                 maxT_SA=[diffM_SA(maxP_SA)+1 diffM_SA(end)+1];
% % %             else
% % %                 maxT_SA=diffM_SA(end)+1;
% % %             end
% % %         else
% % %             maxT_SA=[];
% % %         end
% % %         maxT_SA=time(maxT_SA);
% % %         
% % %         M2=mean(P1_act_final,1);
% % %         E2=ste(P1_act_final,1);
% % %         
% % %         M_SAfft=mean(r_ffts_all,1);
% % %         E_SAfft=ste(r_ffts_all,1);
% % %         diffM_SAfft=find(diff(M_SAfft)>0);
% % %         if ~isempty(diffM_SAfft)
% % %             maxP_SAfft=find(diff(diffM_SAfft)>1);
% % %             if ~isempty(maxP_SAfft)
% % %                 maxF_SAfft=[diffM_SAfft(maxP_SAfft)+1 diffM_SAfft(end)+1];
% % %             else
% % %                 maxF_SAfft=diffM_SAfft(end)+1;
% % %             end
% % %         else
% % %             maxF_SAfft=[];
% % %         end
% % %         maxF_SAfft=(maxF_SAfft);
        
        if plotFlag==1
            figure(3)
            subplot(2,ceil(size(filt_movie,2)/2),fixation_num)
            hold all
            imagesc(r_SA_all,[-1 1])
            colormap('jet')
            %         colorbar
            set(gca,'XTick',0:10:1000)
            set(gca,'XTickLabel',0:100:10000)
            xlabel('time lag [ms]')
            ylabel('speed-activation xcorr')
            set(gca,'YTickLabel',[])
            yyaxis right
            
            errorbar(M_SA,E_SA,'k')
            axis([0 time(L)./10 0 1])
            
            figure(4)
            subplot(2,ceil(size(filt_movie,2)/2),fixation_num)
            hold all
            imagesc(r_auto_all,[-1 1])
            set(gca,'XTick',0:10:1000)
            set(gca,'XTickLabel',0:100:10000)
            xlabel('time [ms]')
            ylabel('activations - autocorr')
            set(gca,'YTickLabel',[])
            
            figure(5)
            subplot(2,ceil(size(filt_movie,2)/2),fixation_num)
            hold all
            imagesc(P1_act_final,[-1 1])
            set(gca,'XTick',0:5:size(P1_act_final,2))
            set(gca,'XTickLabel',round(f(1:5:size(f,2))))
            colormap('jet')
            ylabel('activations - fft power')
            xlabel('freq [Hz]')
            set(gca,'YTickLabel',[])
            
            yyaxis right
            plot(1:size(f,2)-1,P1_v)
            ylabel('speed - fft power')
            errorbar(M2.*mean(P1_v)/mean(M2),E2.*P1_v(1)/M2(1),'-k')
            xlim([0 size(M2,2)])
            
            figure(6)
            subplot(2,ceil(size(filt_movie,2)/2),fixation_num)
            hold all
            imagesc(r_ffts_all,[-1 1])
            set(gca,'XTick',0:5:size(r_ffts_all,2))
            set(gca,'XTickLabel',round(f(1:5:size(f,2))))
            colormap('jet')
            xlabel('freq lags[ms]')
            ylabel('S fft - A fft xcorr')
            set(gca,'YTickLabel',[])
            
            yyaxis right
            
            errorbar(M_SAfft,E_SAfft,'k')
            xlim([0 size(M_SAfft,2)])
            
            colors={[212,237,255]/255,[182,224,255]/255,[148,204,255]/255,[90,174,255]/255,[0,122,255]/255,[2,82,198]/255,[8,62,127]/255,[0,41,81]/255,[0,28,61]/255};
            colors{size(filt_movie,2)}='k';
            for i=1:100:size(activations,1)
                figure(10)
                subplot(1,3,1)
                hold on
                plot3(v.*100,activations(i,:),flip(time(1:L)),'color',colors{fixation_num})
                zlabel('time before next sacc')
                xlabel('speed [M]')
                ylabel('activations [S]')
                view(80,30)
                subplot(1,3,2)
                hold on
                plot(v(end).*100,activations(i,end),'.','color',colors{fixation_num})
                xlabel('speed end [M]')
                ylabel('activations end [S]')
            end
            subplot(1,3,3)
            plot(fixation_num,infoRec,'*','color',colors{fixation_num})
            xlabel('fixation number')
            ylabel('number of info receptors')
            hold on
        end
        
        classfeatures.numOfinfoRec(fixation_num)=infoRec;
        classfeatures.meanInfoPerRec(fixation_num)=sum(meanActivation);
        classfeatures.finalInsInfoPerRec(fixation_num)=mean(meanActivation(end-3:end));
        classfeatures.varInfoPerRec(fixation_num)=varRec;
        classfeatures.movvarmeanInfoPerRec{fixation_num}=movvar(meanActivation,10);
        classfeatures.actCorrelations{fixation_num}=r;
        
        classfeatures.meanSpeed(fixation_num)=mean(v);
        classfeatures.targetSpeed(fixation_num)=mean(v(10:end));
        classfeatures.finalInsSpeed(fixation_num)=mean(v(end-3:end));
        classfeatures.verSpeed(fixation_num)=var(v);
        
        classfeatures.ampFixation(fixation_num)=amp;
        classfeatures.distFixation(fixation_num)=dist;
        
%         classfeatures.xcorrSA_max{fixation_num}=maxT_SA;
%         classfeatures.xcorrSAfft_max{fixation_num}=maxF_SAfft;
    else
        classfeatures.numOfinfoRec(fixation_num)=0;
        classfeatures.meanInfoPerRec(fixation_num)=0;
        classfeatures.finalInsInfoPerRec(fixation_num)=0;
        classfeatures.varInfoPerRec(fixation_num)=0;
        classfeatures.movvarmeanInfoPerRec{fixation_num}=[];
        classfeatures.actCorrelations{fixation_num}=[];
        
        classfeatures.meanSpeed(fixation_num)=mean(v);
        classfeatures.targetSpeed(fixation_num)=mean(v(10:end));
        classfeatures.finalInsSpeed(fixation_num)=0;
        classfeatures.verSpeed(fixation_num)=var(v);
        
        classfeatures.ampFixation(fixation_num)=amp;
        classfeatures.distFixation(fixation_num)=dist;
       
    end
    toc
end
% tilefigs;
end