IMAGE_SIZE_DEG=3;
PIXEL2METER=0.000264583;
IMAGE_LENGTH_PIX=round(tand(IMAGE_SIZE_DEG/2)/PIXEL2METER*2);

mircs=dir([pwd '\ImagesForExp\MIRCs']);
sub=dir([pwd '\ImagesForExp\subMIRCs']);

rel=mircs;% sub
for i=3:length(mircs)
    
myimgfile=imread(rel(i).name);
myimgfile_2=imresize(myimgfile,[IMAGE_LENGTH_PIX IMAGE_LENGTH_PIX]);
fig=imshow(myimgfile_2);
saveas(fig,[rel(i).name(1:end-4) '_3.png'])
close all
end