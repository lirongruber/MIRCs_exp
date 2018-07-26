% cleaning -all- the gazes..........(only used "once" - all analysis on cleaned data)
clear
clc

savePath='C:\Users\bnapp\Documents\MIRCs_exp\data\cleanData\';
rel_folders=dir('C:\Users\bnapp\Documents\MIRCs_exp\data\rawData\');
for sub_i=3:length(rel_folders)
    disp(sub_i)
    sub=rel_folders(sub_i).name;
    sub='SS';% IN NG UK YM GH
    rel_files=dir(['C:\Users\bnapp\Documents\MIRCs_exp\data\rawData\' sub '\'] );
    for trial_i=3:length(rel_files)
        t=rel_files(trial_i).name;
        load(['C:\Users\bnapp\Documents\MIRCs_exp\data\rawData\' sub '\' t]);
        [~ ,c ,val ]=find(missedSamples);
        blink=0;
        if ~isempty(intersect(find(c~=1),find(c~=2000)))
            error_i=intersect(find(c~=1),find(c~=2000));
            error_val=val(error_i);
            error=[error_i ; error_val];
        end
        figure(1)
        plot(gazeX)
        hold on
        plot(gazeY)
        hold off
        
        gazeX(gazeX>1980)=nan;
        gazeX(gazeX<0)=nan;
        gazeY(gazeY>1020)=nan;
        gazeY(gazeY<0)=nan;
        figure(2)
        plot(gazeX,gazeY)
        hold on
        axis([0 1980 0 1020])
        
        % 100ms before and after blink...
        i=1;
        while i<length(gazeX)-1
            i=i+1;
            if (isnan(gazeX(i)) &&  ~isnan(gazeX(i-1))) ||  (isnan(gazeY(i)) &&  ~isnan(gazeY(i-1)))
                gazeX(max(1,i-150):i)=nan;
                gazeY(max(1,i-150):i)=nan;
                blink=blink+1;
            end
            if (isnan(gazeX(i)) &&  ~isnan(gazeX(i+1))) ||  (isnan(gazeY(i)) &&  ~isnan(gazeY(i+1)))
                gazeX(i:min(i+150,length(gazeX)))=nan;
                gazeY(i:min(i+150,length(gazeX)))=nan;
                i=i+150;
            end
        end
        
        plot(gazeX,gazeY)
        hold off
        if max(isnan(gazeX))>0
            %         gazeX=fillmissing(gazeX,'linear');
            %         gazeY=fillmissing(gazeY,'linear');
        end
        
        
        SavingFile=[savePath sub '\' t ];
        save(SavingFile, '-regexp', '^(?!(savePath|rel_folders|sub_i|rel_files|trial_i|t|c|val|error_i|error_val|SavingFile)$).')
    end
end


