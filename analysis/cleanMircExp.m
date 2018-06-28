% cleaning -all- the gazes..........(only used "once" - all analysis on cleaned data)
clear
clc

savePath='C:\Users\bnapp\Documents\MIRCs_exp\data\cleanData\';
rel_folders=dir('C:\Users\bnapp\Documents\MIRCs_exp\data\rawData\');
for sub_i=3:length(rel_folders)
    sub=rel_folders(sub_i).name;
%     sub='EM';
    rel_files=dir(['C:\Users\bnapp\Documents\MIRCs_exp\data\rawData\' sub '\'] );
    for trial_i=3:length(rel_files)
        t=rel_files(trial_i).name;
        load(['C:\Users\bnapp\Documents\MIRCs_exp\data\rawData\' sub '\' t]);
        [~ ,c ,val ]=find(missedSamples);
        
        if ~isempty(intersect(find(c~=1),find(c~=2000)))
            error_i=intersect(find(c~=1),find(c~=2000));
            error_val=val(error_i);
            error=[error_i ; error_val];
        end
%         plot(gazeX)
%         hold on
%         plot(gazeY)
%         hold off
        
        gazeX(gazeX>2500)=nan;
        gazeX(gazeX<-500)=nan;
        gazeY(gazeY>1500)=nan;
        gazeY(gazeY<-500)=nan;
%         plot(gazeX,gazeY)
%         axis([0 1980 0 1020])
        
        if max(isnan(gazeX))>0
%         gazeX=fillmissing(gazeX,'linear');
%         gazeY=fillmissing(gazeY,'linear');
        end
        
        SavingFile=[savePath sub '\' t ];
        save(SavingFile, '-regexp', '^(?!(savePath|rel_folders|sub_i|rel_files|trial_i|t|c|val|error_i|error_val|SavingFile)$).')
    end
end


