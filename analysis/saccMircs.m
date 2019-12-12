function [sacc_time_ms,sacc_amp_degrees,sacc_vel_deg2sec,sacc_maxvel_deg2sec]=saccMircs(saccade_vec,XY_vecs_deg,rate)

sacc_time_ms=[];
sacc_amp_degrees=[];
sacc_vel_deg2sec=[];
sacc_maxvel_deg2sec=[];

tempLength=[];
maxtempLength=[];
for i=2:size(saccade_vec,2)
    saccades{i}=XY_vecs_deg(:,(saccade_vec(1,i):saccade_vec(2,i)+saccade_vec(1,i)));
    sacc_time_ms(i)=size(saccades{i},2)*rate/1000;
    sacc_amp_degrees(i)=EULength(saccades{i}');
    tempLength=[];
    for j=1:length(saccades{i})-1
        tempLength(j)=EUDist(saccades{i}(:,j)',saccades{i}(:,j+1)');
    end
        maxtempLength(i)=max(tempLength);
end
sacc_vel_deg2sec=sacc_amp_degrees./(sacc_time_ms/1000);
sacc_maxvel_deg2sec=maxtempLength.*rate;

for i=2:length(sacc_time_ms)
    if sacc_amp_degrees(i)> 28 
    sacc_amp_degrees(i)=0;
    sacc_vel_deg2sec(i)=0;
    sacc_maxvel_deg2sec(i)=0;
    sacc_time_ms(i)=0;
    end
end