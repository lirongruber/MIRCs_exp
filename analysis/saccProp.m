function [saccade_vec,sacc_time_ms,sacc_amp_degrees,sacc_vel_deg2sec,sacc_maxvel_deg2sec]=saccProp(saccade_vec,XY_vec_pix,XY_vecs_deg,imdata,res)


for i=2:size(saccade_vec,2)
    saccades{i}=XY_vecs_deg(:,(saccade_vec(1,i):saccade_vec(2,i)+saccade_vec(1,i)));
    sacc_time_ms(i)=length(saccades{i})*res*1000;
    sacc_length_degrees(i)=EULength(saccades{i}');
    tempLength=[];
    for j=1:length(saccades{i})-1
        tempLength(j)=EUDist(saccades{i}(:,j)',saccades{i}(:,j+1)');
    end
        maxtempLength(i)=max(tempLength);
end
sacc_amp_degrees=sacc_length_degrees;
sacc_vel_deg2sec=sacc_amp_degrees./(sacc_time_ms/1000);
sacc_maxvel_deg2sec=maxtempLength./res;

for i=2:length(sacc_time_ms)
    if sacc_amp_degrees(i)> 28 
    sacc_amp_degrees(i)=0;
    sacc_vel_deg2sec(i)=0;
    sacc_maxvel_deg2sec(i)=0;
    sacc_time_ms(i)=0;
    end
end