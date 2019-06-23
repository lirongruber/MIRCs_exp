function [saccade_vec, n] = saccadesDetection( chan_h_deg, chan_v_deg, rate, sacc_parameters)
% @ Amos Arieli , (Liron Gruber 01/2018).

debugFlg =  0; % 1 if to display (for debugging) stages of Saccade detection

% Parameters & Initialization
saccade_vec = zeros(3, fix(length(chan_h_deg)*10/rate));    % max number of saccades = 10/s

minimum_amplitude=sacc_parameters.saccade_min_amp;
maximum_amplitude=sacc_parameters.saccade_max_amp;
minimum_velocity = sacc_parameters.saccade_min_velocity/rate;
peak_velocity = sacc_parameters.saccade_peak_velocity/rate;
minimum_duration = fix( sacc_parameters.saccade_min_duration*rate/1000);
maximun_angleChange = sacc_parameters.saccade_angle_threshold; 

overshoot_max_gap = fix( 10*rate/1000); %10ms
overshoot_minimum_amplitude = sacc_parameters.overshoot_min_amp*minimum_amplitude; % smaller minimal amplitude for overshoot

intrusion_angle_threshold = sacc_parameters.intrusion_angle_threshold;
intrusion_max_gap = fix( sacc_parameters.intrusion_range*rate/1000);

chan_h_deg_flg = 1; % there is data in chan_h_deg
chan_v_deg_flg = 1; % there is data in chan_v_deg
if(min(chan_h_deg) == max(chan_h_deg)), chan_h_deg_flg = 0; end
if(min(chan_v_deg) == max(chan_v_deg)), chan_v_deg_flg = 0; end

filtered_chan_h_deg=chan_h_deg;
filtered_chan_v_deg=chan_v_deg;

% Amos's old filter
% Low pass Filter data:
% FilterFlg = 1;
% filter_order = 4; % filter order=4
% filter_cutoff = 120; % low pass < 120Hz
% if(FilterFlg == 1)
%     if filter_cutoff<rate
%         [b, a] = butter( filter_order, filter_cutoff/(rate/2),'low' );
%         if(chan_h_deg_flg == 1), filtered_chan_h_deg = filtfilt(b, a,double(chan_h_deg)); end
%         if(chan_v_deg_flg == 1), filtered_chan_v_deg = filtfilt(b, a,double(chan_v_deg)); end
%     end
% end

% Tangental Velocity, Speed & angle diff
velocity_h = diff( filtered_chan_h_deg);
velocity_v = diff( filtered_chan_v_deg);
sample_speed_vec = sqrt(velocity_h.^2 + velocity_v.^2);
sample_difangle_vec = abs(diff(atan2( velocity_v, velocity_h))) .* 180/pi;
sample_difangle_vec=min(sample_difangle_vec,360-sample_difangle_vec);

% Saccade detection
i = 1; % index for current sample number [ 1<= i < length(filtered_chan_h_deg-1) ]
n = 0; % number of saccades

while i < length(filtered_chan_h_deg) - 2

    if sample_speed_vec(i) < minimum_velocity % below thereshold for minimal velocity
        i = i + 1;
        continue;
    else  % above thereshold for minimal velocity
        j = 0; % index for current sample inside a potential saccade (general index=i+j)
        while i+j < length(filtered_chan_h_deg)- 2
            curr_angle = sample_difangle_vec(i+j);
            j = j + 1;
            %
            display1(debugFlg,i,j,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec,minimum_velocity,peak_velocity,maximun_angleChange)
            %
            if curr_angle < maximun_angleChange &&...
                    (sample_speed_vec(i+j) > minimum_velocity) % below threshold for within angle diff and above minimum velocity
                continue; % continue increasing j
            else % stop increasing j and check saccade
                %
                display2(i,j,debugFlg,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec)
                %
                saccade_amp = sqrt((filtered_chan_h_deg(i+j)-filtered_chan_h_deg(i))^2 + (filtered_chan_v_deg(i+j)-filtered_chan_v_deg(i))^2);
                SCok = 0; % 1 - if SC
                if (n > 0 && (i - (saccade_vec(1,n) + saccade_vec(2,n)) < overshoot_max_gap))% new saccade start is close enough to previus saccade end
                    if (saccade_amp > overshoot_minimum_amplitude) &&... % an "oveshoot saccade" (allowed to be smaller in amp)
                            (saccade_amp < maximum_amplitude)  &&...
                            (max(sample_speed_vec(i:i+j)) > peak_velocity) && ...
                            (j > minimum_duration) &&...
                            (saccade_amp/(max(sample_speed_vec(i:i+j))*rate) > 0.001) && ...
                            (saccade_amp/(max(sample_speed_vec(i:i+j))*rate) < 10.6)
                        SCok = 1; % 1 - if Sacc
                    end
                else  % a regular "independent saccade"
                    if (saccade_amp > minimum_amplitude) &&...
                            (saccade_amp < maximum_amplitude)  &&...
                            (max(sample_speed_vec(i:i+j)) > peak_velocity) && ...
                            (j > minimum_duration) &&...
                            (saccade_amp/(max(sample_speed_vec(i:i+j))*rate) > 0.001) && ...
                            (saccade_amp/(max(sample_speed_vec(i:i+j))*rate) < 10.6)
                        SCok = 1; % 1 - if Sacc
                    end
                end
                % update for merge overshoot
                if(SCok == 1) % 1 - if Sacc
                    if n > 0
                        if ((sacc_parameters.merge_overshoot || sacc_parameters.merge_intrusions)  && ...%if to merge overshoot
                                (i - (saccade_vec(1,n) + saccade_vec(2,n)) < overshoot_max_gap))% new saccade start is close enough to previus saccade end
                            saccade_vec(2,n) = i+j - saccade_vec(1,n) ;
                            %
                            display3(debugFlg,saccade_vec,n,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec)
                            %
                        else
                            angle_between_saccs = abs((atan2( velocity_v(saccade_vec(1,n)), velocity_h(saccade_vec(1,n))) - atan2( velocity_v(i), velocity_h(i)))) * 180/pi;
                            if sacc_parameters.merge_intrusions &&... %if to merge intrusion
                                    (i-saccade_vec(1,n)) <  intrusion_max_gap &&... % new saccade is still in the allowed range for intrusion
                                    (angle_between_saccs > intrusion_angle_threshold) % new saccade angle is allowed
                                saccade_vec(2,n) = i+j - saccade_vec(1,n) ;
                                %
                                display3(debugFlg,saccade_vec,n,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec)
                                %
                                if saccade_vec(3,n) < 5
                                    saccade_vec(3,n) = saccade_vec(3,n) + 1;  % Increase Saccade Intrusion count.
                                end
                            else
                                n = n + 1;
                                saccade_vec(:,n) = [i j 1]'; % define a new saccade!
                                %
                                display4(i,j,debugFlg,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec)                                %
                                %
                            end
                            
                        end
                    else
                        n = n + 1;
                        saccade_vec(:,n) = [i j 1]'; % define a new saccade!
                        %
                        display4(i,j,debugFlg,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec)
                        %
                    end
                end
                
                break % (placed inside "else" that stop increasing j => break the "j while" - jump to i=i+j....)
            end
        end
        i = i + j;
    end
end
numOfSacc=find(saccade_vec(1,:));
if isempty(numOfSacc)
    numOfSacc=0;
else
numOfSacc=numOfSacc(end);
end
saccade_vec=saccade_vec(:,1:numOfSacc); % cutting the extra zeros of saccade_vec
end


function display1(debugFlg,i,j,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec,minimum_velocity,peak_velocity,maximun_angleChange)
% every j=j+1 inside a potential saccade
if debugFlg == 1
    figure(5); %clf;
    IndDBGbgn = i - 50; if(IndDBGbgn < 1), IndDBGbgn = 1; end
    IndDBGend = i + 50; if(IndDBGend > length(filtered_chan_h_deg)-1), IndDBGend = length(filtered_chan_h_deg)-1; end
    axDBG(1) = IndDBGbgn/rate; % for axis
    axDBG(2) = IndDBGend/rate; % for axis
    if(chan_h_deg_flg == 1)
        if(chan_v_deg_flg == 1), subplot(4,1,1); end
        plot((IndDBGbgn:IndDBGend)/rate,filtered_chan_h_deg(IndDBGbgn:IndDBGend),'k','LineWidth',1.5);
        hold on;
        plot(i/rate,filtered_chan_h_deg(i),'c*','Markersize',5,'LineWidth',2);
        plot((i+j)/rate,filtered_chan_h_deg(i+j),'r*','Markersize',5,'LineWidth',2);
        MinYaxDBG = min(filtered_chan_h_deg(IndDBGbgn:IndDBGend)); % for axis
        MaxYaxDBG = max(filtered_chan_h_deg(IndDBGbgn:IndDBGend)); % for axis
        axDBG(3) =  MinYaxDBG - 0.1*(MaxYaxDBG - MinYaxDBG); % for axis
        axDBG(4) =  MaxYaxDBG + 0.1*(MaxYaxDBG - MinYaxDBG); % for axis
        axis(axDBG);
        title(sprintf('Horizontal SC(%i)',i));
    end
    if(chan_v_deg_flg == 1)
        if(chan_h_deg_flg == 1), subplot(4,1,2); end
        plot((IndDBGbgn:IndDBGend)/rate,filtered_chan_v_deg(IndDBGbgn:IndDBGend),'k','LineWidth',1.5);
        hold on;
        plot(i/rate,filtered_chan_v_deg(i),'c*','Markersize',5,'LineWidth',2);
        plot((i+j)/rate,filtered_chan_v_deg(i+j),'r*','Markersize',5,'LineWidth',2);
        MinYaxDBG = min(filtered_chan_v_deg(IndDBGbgn:IndDBGend)); % for axis
        MaxYaxDBG = max(filtered_chan_v_deg(IndDBGbgn:IndDBGend)); % for axis
        axDBG(3) =  MinYaxDBG - 0.1*(MaxYaxDBG - MinYaxDBG); % for axis
        axDBG(4) =  MaxYaxDBG + 0.1*(MaxYaxDBG - MinYaxDBG); % for axis
        axis(axDBG);
        title(sprintf('Vertical SC(%i)',i));
    end
    % Speed
    subplot(4,1,3)
    plot((IndDBGbgn:IndDBGend)/rate,sample_speed_vec(IndDBGbgn:IndDBGend),'k','LineWidth',1.5);
    hold on;
    plot(i/rate,sample_speed_vec(i),'c*','Markersize',5,'LineWidth',2);
    plot((i+j)/rate,sample_speed_vec(i+j),'r*','Markersize',5,'LineWidth',2);
    MinYaxDBG = min(sample_speed_vec(IndDBGbgn:IndDBGend)); % for axis
    MaxYaxDBG = max(sample_speed_vec(IndDBGbgn:IndDBGend)); % for axis
    axDBG(3) =  MinYaxDBG - 0.1*(MaxYaxDBG - MinYaxDBG); % for axis
    axDBG(4) =  MaxYaxDBG + 0.1*(MaxYaxDBG - MinYaxDBG); % for axis
    axis(axDBG);
    title(sprintf('Speed (%i)',i));
    plot([IndDBGbgn IndDBGend]./rate,[minimum_velocity minimum_velocity],'--b')
    plot([IndDBGbgn IndDBGend]./rate,[peak_velocity peak_velocity],'--b')
    % Angle
    subplot(4,1,4)
    plot((IndDBGbgn:IndDBGend-1)/rate,sample_difangle_vec(IndDBGbgn:IndDBGend-1),'k','LineWidth',1.5);
    hold on;
    plot(i/rate,sample_difangle_vec(i),'c*','Markersize',5,'LineWidth',2);
    plot((i+j)/rate,sample_difangle_vec(i+j),'r*','Markersize',5,'LineWidth',2);
    MinYaxDBG = min(sample_difangle_vec(IndDBGbgn:IndDBGend-1));
    MaxYaxDBG = max(sample_difangle_vec(IndDBGbgn:IndDBGend-1));
    axDBG(3) =  MinYaxDBG - 0.1*(MaxYaxDBG - MinYaxDBG);
    axDBG(4) =  MaxYaxDBG + 0.1*(MaxYaxDBG - MinYaxDBG);
    axis(axDBG);
    title(sprintf('Angle Diff(%i)',i));
    plot([IndDBGbgn IndDBGend]./rate,[maximun_angleChange maximun_angleChange],'--b')
%         keyboard;
end
end

function display2(i,j,debugFlg,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec)
% every end of potential saccade, before chekings (when 'stop incresing j'))
if debugFlg == 1
    if(chan_h_deg_flg == 1)
        if(chan_v_deg_flg == 1), subplot(4,1,1); end
        plot((i+j)/rate,filtered_chan_h_deg(i+j),'m+','Markersize',5,'LineWidth',2);
    end
    if(chan_v_deg_flg == 1)
        if(chan_h_deg_flg == 1), subplot(4,1,2); end
        plot((i+j)/rate,filtered_chan_v_deg(i+j),'m+','Markersize',5,'LineWidth',2);
    end
    subplot(4,1,3)
    plot((i+j)/rate,sample_speed_vec(i+j),'m+','Markersize',5,'LineWidth',2);
    subplot(4,1,4)
    plot((i+j)/rate,sample_difangle_vec(i+j),'m+','Markersize',5,'LineWidth',2);
%             keyboard;
end
end

function display3(debugFlg,saccade_vec,n,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec)
% merging close saccade
if(debugFlg == 1)
    ii = saccade_vec(1,n); jj = saccade_vec(2,n);
    figure(5);
    if(chan_h_deg_flg == 1)
        if(chan_v_deg_flg == 1), subplot(4,1,1); end
        plot((ii:ii+jj)/rate,filtered_chan_h_deg(ii:ii+jj),'g','LineWidth',2);
    end
    if(chan_v_deg_flg == 1)
        if(chan_h_deg_flg == 1), subplot(4,1,2); end
        plot((ii:ii+jj)/rate,filtered_chan_v_deg(ii:ii+jj),'g','LineWidth',2);
    end
    subplot(4,1,3)
    plot((ii:ii+jj)/rate,sample_speed_vec(ii:ii+jj),'g','LineWidth',2);
    subplot(4,1,4);
    plot((ii:ii+jj)/rate,sample_difangle_vec(ii:ii+jj),'g','LineWidth',2);
    figure(6)
    plot(filtered_chan_h_deg(ii:ii+jj),filtered_chan_v_deg(ii:ii+jj),'LineWidth',2)
    hold all
    xlabel('Horizontal')
    ylabel('Vertical')
    axis([-15 15 -10 10])
    keyboard;
    figure(5)
end

end

function display4(i,j,debugFlg,filtered_chan_h_deg,filtered_chan_v_deg,chan_h_deg_flg,chan_v_deg_flg,sample_difangle_vec,rate,sample_speed_vec)
% new saccade detection
if(debugFlg == 1)
    figure(5);
    if(chan_h_deg_flg == 1)
        if(chan_v_deg_flg == 1), subplot(4,1,1); end
        plot((i:i+j)/rate,filtered_chan_h_deg(i:i+j),'r','LineWidth',3);
    end
    if(chan_v_deg_flg == 1)
        if(chan_h_deg_flg == 1), subplot(4,1,2); end
        plot((i:i+j)/rate,filtered_chan_v_deg(i:i+j),'r','LineWidth',3);
    end
    subplot(4,1,3)
    plot((i:i+j)/rate,sample_speed_vec(i:i+j),'r','LineWidth',3);
    subplot(4,1,4)
    plot((i:i+j)/rate,sample_difangle_vec(i:i+j),'r','LineWidth',3);
    figure(6)
    plot(filtered_chan_h_deg(i:i+j),filtered_chan_v_deg(i:i+j),'LineWidth',3)
    hold all
    xlabel('Horizontal')
    ylabel('Vertical')
    axis([-15 15 -10 10])
    keyboard;
    figure(5)
end
end