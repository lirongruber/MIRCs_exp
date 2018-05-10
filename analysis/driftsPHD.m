% drifts analysis
%input - res of samples (example - 0.01 sec)
%output: times,amplitudes, velocities and labels in row 4:

% label 0 = no drift
% label 1 = kinda strait
% label 2 = kinda circular
% label 3 = both/other/medium


function [driftLabeled_saccade_vec,drift_time_ms,drift_dist_degrees,drift_amp_degrees,drift_vel_deg2sec]=driftsPHD(saccade_vec,XY_vec_deg,XY_vec_pix,res,imdata)

driftLabeled_saccade_vec=saccade_vec;
drift_time_ms=[];
drift_amp_degrees=[];
drift_dist_degrees=[];
drift_vel_deg2sec=[];

minDriftTimeMs=40; % x*10 milsec
minLengthofDrift=0.15;% in degrees!
%para for type of drift:
smallDistofDrift=0.15; %for kinda circular
bigLenthofline=smallDistofDrift*6;%for kinda circular
bigDistofDrift=0.3; % for kinda strait

for i =1:size(saccade_vec,2)
    temp=[];
    tempPIX=[];
    if isempty(find(saccade_vec,1))
        temp=XY_vec_deg';
        tempPIX=XY_vec_pix';
    else
        if i==1
            temp=(XY_vec_deg(:,(1:saccade_vec(1,2)))');
            tempPIX=(XY_vec_pix(:,(1:saccade_vec(1,2)))');
        else if i==size(saccade_vec,2)
                temp=(XY_vec_deg(:,((saccade_vec(1,i)+saccade_vec(2,i)):end))');
                tempPIX=(XY_vec_pix(:,((saccade_vec(1,i)+saccade_vec(2,i)):end))');
            else
                temp=(XY_vec_deg(:,((saccade_vec(1,i)+saccade_vec(2,i)):saccade_vec(1,i+1)))');
                tempPIX=(XY_vec_pix(:,((saccade_vec(1,i)+saccade_vec(2,i)):saccade_vec(1,i+1)))');

            end
        end
    end
    [len,~,~] = EULength(temp);
    drift_time_ms(i)=length(temp)*res*1000; % x*10 milsec
    if isempty(find(saccade_vec,1))
            drift_dist_degrees(i)=EUDist(XY_vec_deg(:,1)',XY_vec_deg(:,end)');
    else
        if i==1
            drift_dist_degrees(i)=EUDist(XY_vec_deg(:,1)',XY_vec_deg(:,(saccade_vec(1,i+1)))');
        else if i==size(saccade_vec,2)
                drift_dist_degrees(i)=EUDist(XY_vec_deg(:,(saccade_vec(1,i)+saccade_vec(2,i)))',XY_vec_deg(:,end)');
            else
                drift_dist_degrees(i)=EUDist(XY_vec_deg(:,(saccade_vec(1,i)+saccade_vec(2,i)))',XY_vec_deg(:,(saccade_vec(1,i+1)))');
            end
        end
    end
    drift_amp_degrees(i)=len;
    drift_vel_deg2sec(i)=drift_amp_degrees(i)/(drift_time_ms(i)/1000);
    %debug
    if drift_vel_deg2sec(i)>100
       drift_vel_deg2sec(i) ;
    end
    %
    if  drift_amp_degrees(i)<minLengthofDrift || drift_time_ms(i)< minDriftTimeMs || drift_vel_deg2sec(i)>100
        drift_amp_degrees(i)=0;
        drift_vel_deg2sec(i)=0;
        drift_time_ms(i)=0;
    end
    
    if drift_time_ms(i)< minDriftTimeMs || len<minLengthofDrift
        driftLabeled_saccade_vec(4,i)= 0;
    else if  len> 6*drift_dist_degrees(i) %distofDrift<smallDistofDrift  && len>bigLenthofline %2 = kinda circular
            driftLabeled_saccade_vec(4,i)= 2;
        else if drift_dist_degrees(i)> bigDistofDrift
                driftLabeled_saccade_vec(4,i)= 1;% 1 = kinda strait
            else
                driftLabeled_saccade_vec(4,i)= 3;
            end
        end
        
        
    end
    if isempty(find(saccade_vec,1))
        
        break
    end
    
% %         plot for debugging:
% imshow(imdata)
% %         by type
%         hold on
%         if size(temp,1)>1
%         plot(tempPIX(:,1),tempPIX(:,2),'.r')
%         type=driftLabeled_saccade_vec(4,i);
%         if type==0
%             disp('no drift')
%             c='k';
%         else if type==1
%                 disp('strait')
%                 c='b';
%             else if type==2
%                     disp('circular')
%                     c='r';
%                 else if type==3
%                         disp('other')
%                         c='g';
%                     end
%                 end
%             end
%         end
%             plot(tempPIX(:,1),tempPIX(:,2),[c])
%         end
        

%         % by velocity
%         hold on


%         % by duration
%         hold on


end
end