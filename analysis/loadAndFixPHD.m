
function [dataLen,time,expType,gazeX,gazeY,fix,pd,myimgfile,PicName,gazeX_cal,gazeY_cal,answer,missedSamples]=loadAndFixPHD(dataType,fileName)
%%%--------------------------------------------- use only from clean.m and parView.m %%%--------------


% this function loads a given trial by the file name 
% and fix to its real size (time actially) the long vectors of gaze, sac length , velocity, pupil size

line='\_+';

        Name=regexp(fileName,line,'split');
        Name=Name{1,1};
        F=[dataType '\' Name '\' fileName ];
        SavingPath=whichCompPHD;
        full_filename = fullfile(SavingPath,F);
        load(full_filename);
            %how long?
            dataLen=find(gazeX,1,'last');
            time=dataLen/100;
            
            gazeX=gazeX(1:dataLen);
            gazeY=gazeY(1:dataLen);
            if length(missedSamples)>dataLen
            missedSamples=missedSamples(1:dataLen);
            end
            pd=pd(1:dataLen);
            calLen=find(gazeX_cal,1,'last');
            gazeX_cal=gazeX_cal(1:calLen);
            gazeY_cal=gazeY_cal(1:calLen);
           
    
end