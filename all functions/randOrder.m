
function  [picOrder]=randOrder(number, picsNames)

%this function shuffles the order of the pictures names in 'picNames'. 
%it is best for 12 sessions (number=12)  and 6 pictures 
%- less it returns an warning
comp=whichComp;
if strcmp(comp,'C:\Users\aslab\Documents\Liron\ACTIVE_VISION\data\')%computer downstairs knows only big S!
    a=Shuffle(1:number);
else
    a=shuffle(1:number);
end

picOrder={};

for i=1:number
    if a(i)==1 || a(i)==7
        picOrder(i)= picsNames(1);
    end
    if a(i)==2 || a(i)==8
        picOrder(i)= picsNames(2);
    end
    if a(i)==3 || a(i)==9
       picOrder(i)= picsNames(3);
    end
    if a(i)==4 || a(i)==10
        picOrder(i)= picsNames(4);
    end
    if a(i)==5 || a(i)==11
        picOrder(i)= picsNames(5);
    end
    if a(i)==6 || a(i)==12
        picOrder(i)= picsNames(6);
    end
end
end

    if mod(number,max(size(picsNames)))~=0
        disp('pictures are not equally shown')
    end
    

end

