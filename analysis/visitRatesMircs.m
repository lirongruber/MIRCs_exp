
function [full_finalPic,sec1_finalPic,unfull_finalPic,unsec1_finalPic]=visitRatesMircs(XY_vec_pix,imdata)

ms=15;%0 is counting pixel pixel

wW=1920;
wH=1080;
full_finalPic=zeros(size(imdata));
sec1_finalPic=zeros(size(imdata));
unfull_finalPic=zeros(size(imdata));
unsec1_finalPic=zeros(size(imdata));
[row , col]=find(imdata);
Row= [min(row) max(row)];
Col=[min(col) max(col)];

for i=1:length(XY_vec_pix)
    currx= XY_vec_pix(1,i);
    curry= XY_vec_pix(2,i);
    myrect=[currx-(ms/(1+1)) curry-(ms/(1+1)) currx+(ms/(1+1/1))+1 curry+(ms/(1+1))+1];
    
    y1=max(Row(1),round(myrect(2))); y1=min(y1,Row(2)); y1=min(y1,wH); y1=max(y1,1);
    y2=max(Row(1),round(myrect(4))); y2=min(y2,Row(2)); y2=min(y2,wH); y2=max(y2,1);
    x3=max(Col(1),round(myrect(1))); x3=min(x3,Col(2)); x3=min(x3,wW); x3=max(x3,1);
    x4=max(Col(1),round(myrect(3))); x4=min(x4,Col(2)); x4=min(x4,wW); x4=max(x4,1);

    full_finalPic(y1:y2,x3:x4)=full_finalPic(y1:y2,x3:x4)+1;
    if i<length(XY_vec_pix)/3
       sec1_finalPic(y1:y2,x3:x4)=sec1_finalPic(y1:y2,x3:x4)+1;
    end
end

unfull_finalPic(full_finalPic==0)=1;
unsec1_finalPic(sec1_finalPic==0)=1;

% imshow(full_finalPic)
end