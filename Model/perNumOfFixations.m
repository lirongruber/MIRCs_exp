% % % separating analysis for different number of fixations

% class={ class{1,:} ; class{4,:} };
for n=1:12
    one_class={};
    for c=1:size(class,1)
        r=0;
        for t=1:size(class,2)
            curr=class{c,t};
            if ~isempty(curr)
                if size(curr.meanSpeed,2)==n 
                    r=r+1;
                    one_class{c,r}=class{c,t};
                end
            end
        end
    end
    save(['C:\Users\bnapp\Documents\MIRCs_exp\data\modelData\class' num2str(n)] ,'one_class')
end





