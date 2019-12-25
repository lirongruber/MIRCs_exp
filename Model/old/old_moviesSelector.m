% relevant no sides movies from videos matrixes

rate=10; %ms
thresh=0.1;

paths={...
    'C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\videos\MIRCs_yes' ;
    'C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\videos\MIRCs_no' ;
    'C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\videos\subMIRCs_yes' ;
    'C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\videos\subMIRCs_no' ;
    };
paths=paths';

for cond=1:4
    currpath=paths{cond};
    files = dir(currpath);
    files=files(4:end);
    relM=0;
    for file = files'
        load(file.name)
        mov=zeros(50,50,size(finalTrial,3)/rate);
        tic
        frame=0;
        for i=1:rate:size(finalTrial,3)
            frame=frame+1;
            mov(:,:,frame)=finalTrial(:,:,i);
%             imshow(mov(:,:,frame)./255)
%             pause(rate/1000)
        end
        toc
        
        sides=length(find(mov==255));
        S=size(mov);
        per=sides/(S(1)*S(2)*S(3));
        if per<thresh
            relM=relM+1;
            save([currpath '\forDNN\mov' num2str(relM) '.mat'], 'mov', 'per')
        end
    end
end
    