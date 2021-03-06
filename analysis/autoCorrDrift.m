% CONVERGENCE WITHIN TRIAL
clear
close all

paths={...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat',...
    };
paths={...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec Yes.mat',...
    'C:\Users\lirongr\Documents\MIRCs_exp\data\processedData\OnlyFirst0_Sub1Mirc1Full0Ref0_rec No.mat',...
    };

% paths={...
%     'C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\perSubject\NG_OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat',...
%     'C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\perSubject\YS_OnlyFirst1_Sub1Mirc0Full0Ref0_rec No.mat',...
%     };

methods={'fullImage' 'Mirc' 'subMirc' 'stabMirc'};
methods2={'fullImage' 'mean' 'Mirc' 'mean' 'subMirc' 'mean' 'stabMirc' 'mean'};
methods={'Recog' 'notRecog'};
currcolor={'b','c'};

windowAvSize_forMean=5;%1
windowAvSize_forStd=5;%3

for group=1:length(paths)
    MeanVel=[];
    MeanVar=[];
    MeanCC=[];
    Amp=[];
    freqAmp=[];
    load(paths{group});
    relD=0;
    for t =1:size(labeled_saccade_vecs,2)
        currSaccVec=labeled_saccade_vecs{1,t};
        XY_vec_deg=XY_vecs_deg{1,t};
        for i=0:size(currSaccVec,2)
            temp=[];
            if isempty(find(currSaccVec,1))
                temp=XY_vec_deg';
            else
                if i==0
                    temp=(XY_vec_deg(:,(1:currSaccVec(1,1)))');
                else if i<size(currSaccVec,2)
                        temp=(XY_vec_deg(:,((currSaccVec(1,i)+currSaccVec(2,i)):currSaccVec(1,i+1)))');
                    else
                        temp=(XY_vec_deg(:,((currSaccVec(1,i)+currSaccVec(2,i)):end))');
                    end
                end
            end
            
            
            
            if length(temp)>100 && size(currSaccVec,2)>2 && sum(sum(isnan(temp)))==0
                currAmp=[];
                for j=2:length(temp)
                    currAmp(j-1) = sqrt((temp(j,1)-temp(j-1,1))^2+(temp(j,2)-temp(j-1,2))^2);
                end
                
                if max(currAmp)<0.12
                    relD=relD+1;
                    %for any given drift
                    M=movmean(currAmp.*250,windowAvSize_forMean);
                    V=movvar(currAmp.*250,windowAvSize_forStd);
                    
                    MeanVel(relD,1:length(M))=M;
                    MeanVar(relD,1:length(M))=V;
%                     figure(1)
%                     subplot(2,2,group)
%                     a=plot(M);
%                     hold all
%                     axis([0 1000 0 14])
%                     xlabel('Time within fixation pause [ms]','FontSize', 20);
%                     ylabel('Speed')
%                     title(methods{group})
                    
                    
                    Fs = 250;            % Sampling frequency
                    T = 1/Fs;             % Sampling period
                    L = size(M,2);             % Length of signal
                    fftM=fft(M);
                    P2=abs(fftM/L);
                    P1 = P2(1:floor(L/2)+1);
                    P1(2:end-1) = 2*P1(2:end-1);
                    f = Fs*(0:(L/2))/L;
                    
                    f_des=1:500;
                    ap_des = interp1(f, P1, f_des, 'linear');
                    freqAmp(relD,1:length(ap_des))=ap_des;
                    
                    subplot(2,2,group+2)
                    a=plot(ap_des);
                    a.Color(4) = 0.5;
      
                    axis([0 500 0 10])
                    hold all
                    %
                    corrLags=200;
                    [xcf_amp,lags_amp,bounds_amp]=crosscorr(M,M,min(corrLags,length(M)-1));
                    speedCC_1=xcf_amp(floor(length(xcf_amp)/2):end);
                    speedCC=zeros(size(speedCC_1));
                    speedCC(speedCC_1>bounds_amp(1))=speedCC_1(speedCC_1>bounds_amp(1));
                    speedCC(speedCC_1<bounds_amp(2))=speedCC_1(speedCC_1<bounds_amp(2));
                    
                    MeanCC(relD,1:length(speedCC))=speedCC;
              
                end
            end
            MeanVel(MeanVel==0)=nan;
            MeanVar(MeanVar==0)=nan;
        end
    end
    figure(2)
    errorbar(1:size(MeanVel,2),nanmean(MeanVel),nanstd(MeanVel)./sqrt(size(MeanVel,1)-sum(isnan(MeanVel))),'color',currcolor{1,group},'LineWidth',3)
    hold on
    plot(nanmean(MeanVel),'k')
    legend('Recog','','notRecog')
    axis([0 200 2 7])
    xlabel('Time within fixation pause [ms]','FontSize', 20)
    title('Inst Speed')
    
    figure(3)
    subplot(1,2,group)
    MeanCC(MeanCC>0.5)=0.5;
    imagesc(MeanCC(:,2:end),[-1 1])
    colormap('jet')
    caxis([-0.5 0.5])
    colorbar
    xlabel('Time within fixation pause [ms]','FontSize', 20)
    ylabel('single pauses')
    title(['Autocorrelation of inst-Speed - ' methods{group}])
    
    figure(1)
    subplot(2,2,group+2)
    errorbar(1:size(freqAmp,2),nanmean(freqAmp),nanstd(freqAmp)./sqrt(size(freqAmp,1)-sum(isnan(freqAmp))),'color',currcolor{1,group},'LineWidth',3)
    hold on
    plot(nanmean(freqAmp),'k')
    %     legend('MIRCS','','subMIRCs','')
    axis([0 50 0 2])
    xlabel('Freq [Hz]','FontSize', 20)
    ylabel('Freq Amplitude')
    
end
tilefigs