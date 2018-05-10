% cleaning -all- the gazes..........(only used "once" - all analysis on cleaned data)
clear
clc

dataType='MircsData'; %'CurvesData'
savePath=['C:\Users\bnapp\Documents\phd-pre-proposal\analysis\cleanData\' dataType '\'];
trialNum=10; %16
maxerror=0.005;
count=0;
E=[];

for name={'SL','RV','RB','NS','ML','IS','G','EH','AR','AK','AH'};%,subjects
    n=cell2mat(name);
    for sessionNum={'1' '2' '3'};%'CN' 'CS'
        sz=cell2mat(sessionNum);
        for t=1:trialNum %trial number
            fileName=[n , '_'  sz '_' num2str(t)];
            [dataLen,time,expType,gazeX,gazeY,fix,pd,myimgfile,PicName,gazeX_cal,gazeY_cal,answer,missedSamples]=loadAndFixPHD(dataType,fileName);
            [~ ,c ,val ]=find(missedSamples);
            
            maxError=max(val);
            if maxError>maxerror
                error=val(val>maxerror);
                count=count+length(error);
                E=[E error];
            end
            
            gazeX(gazeX>2500)=nan;
            gazeX(gazeX<-500)=nan;
            gazeX_cal(gazeX_cal>2500)=nan;
            gazeX_cal(gazeX_cal<-500)=nan;
            gazeY(gazeY>1500)=nan;
            gazeY(gazeY<-500)=nan;
            gazeY_cal(gazeY_cal>1500)=nan;
            gazeY_cal(gazeY_cal<-500)=nan;
            %                 figure(1); plot(gazeX,gazeY,'.')
            
            currVars={gazeX,gazeX_cal,gazeY,gazeY_cal};
            for j=1:4
                currVar=currVars{1,j};
                while  max(isnan(currVar))> 0
                    nans=isnan(currVar);
                    i=find(nans);
                    if i(1)==1
                        i=i(2:end);
                        currVar(1)=0;
                    end
                    currVar(i)=currVar(i-1);
                end
                if j==1
                    gazeX=currVar;
                else if j==2
                        gazeX_cal=currVar;
                    else if j==3
                            gazeY=currVar;
                        else if j==4
                                gazeY_cal=currVar;
                            end
                        end
                    end
                end
            end
            
            
            SavingFile=[savePath n '\' n '_'  sz  '_' num2str(t)   '.mat'];
            save(SavingFile, '-regexp', '^(?!(c|counts|E|error|i|n|p|sz|t|val|trialNum|totalTrials|sessionNum|savePath)$).')
        end
    end
end

% count
% totalTrials


