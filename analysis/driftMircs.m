function [drift_time_ms,drift_dist_degrees,drift_amp_degrees,drift_vel_deg2sec]=driftMircs(saccade_vec,XY_vec_deg,rate)

drift_time_ms=[];
drift_dist_degrees=[];
drift_amp_degrees=[];
drift_vel_deg2sec=[];
drift_TarVel_deg2sec=[];
drift_Cur_CI=[];

minDriftTimeMs=40; % in milsec
maxDriftTimeMs=1000; % in milsec
minLengthofDrift=0.15;% in degrees!
maxLengthofDrift=15;% in degrees!
maxDriftVel=15; %in deg/sec

for i =0:size(saccade_vec,2)
    j=i+1;
    temp=[];
    if isempty(find(saccade_vec,1))
        temp=XY_vec_deg';
    else
        if i==0
            temp=(XY_vec_deg(:,(1:saccade_vec(1,1)))');
        else if i<size(saccade_vec,2)
                temp=(XY_vec_deg(:,((saccade_vec(1,i)+saccade_vec(2,i)):saccade_vec(1,i+1)))');
            else
                temp=(XY_vec_deg(:,((saccade_vec(1,i)+saccade_vec(2,i)):end))');
            end
        end
    end
    [len,~,~] = EULength(temp);
    if isnan(len)
        len=0;
    end
    drift_amp_degrees(j)=len;
    drift_time_ms(j)=size(temp,1)/rate*1000; %  milsec
    drift_dist_degrees(j)=EUDist(temp(1,:),temp(end,:));
    drift_vel_deg2sec(j)=drift_amp_degrees(j)/(drift_time_ms(j)/1000);
    
    if  drift_amp_degrees(j)<minLengthofDrift || drift_amp_degrees(j)>maxLengthofDrift ||drift_time_ms(j)< minDriftTimeMs || drift_time_ms(j)> maxDriftTimeMs || drift_vel_deg2sec(j)>maxDriftVel || max(max(isnan(temp)))>0
        drift_amp_degrees(j)=0;
        drift_vel_deg2sec(j)=0;
        drift_time_ms(j)=0;
    end
end
end