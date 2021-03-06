
function [full_finalPic,tillFixation4_finalPic,fromFixation4_finalPic]=visitRatesMircs_Yarbus(XY_vec_pix,imdata,fourthFixationStart)

ms=25;%0 is counting pixel pixel

wW=1920;
wH=1080;
full_finalPic=zeros(size(imdata));
sec1_finalPic=zeros(size(imdata));
tillFixation4_finalPic=zeros(size(imdata));
fromFixation4_finalPic=zeros(size(imdata));
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
    if i<fourthFixationStart
        tillFixation4_finalPic(y1:y2,x3:x4)=tillFixation4_finalPic(y1:y2,x3:x4)+1;
    else
        fromFixation4_finalPic(y1:y2,x3:x4)=fromFixation4_finalPic(y1:y2,x3:x4)+1;
    end
end

% figure(1)
% subplot(1,3,1)
% imshow(full_finalPic)
% subplot(1,3,2)
% imshow(tillFixation4_finalPic)
% subplot(1,3,3)
% imshow(fromFixation4_finalPic)
end