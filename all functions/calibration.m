%calibration with eyelink

function [el]= calibration(w,backgroundcolor,textColor,mouseNum,domEye)

    Screen('FillRect', w, backgroundcolor);
    Screen('TextSize',w,40);
    DrawFormattedText(w, 'Click mouse to start calibration and varification \n \n from now on -DO NOT MOVE YOUR HEAD','center','center',textColor);
    Screen('Flip',w);
    while  KbCheck(mouseNum)==0 % waits for mouse click
    end
    Screen('FillRect', w, backgroundcolor);
    Screen('Flip',w);
    
    Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, 1919, 1079);
    Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, 1919, 1079);
    Eyelink('command','marker_phys_coords = -280, 180, -280, -40, 280, 180, 280, -40');
    Eyelink('command','screen_phys_coords = -260, 147, 260, -147'); %screen vpixx is 52/29.4 cm
    Eyelink('command','simulation_screen_distance = 1000');%1000= 1 meter
    Eyelink('command','calibration_type = HV9');
%     Eyelink('command','calibration_area_proportion = 0.9');
%     Eyelink('command','validation_area_proportion = 0.9');

    if strcmp(domEye,'r')
        Eyelink('command','active_eye=RIGHT');	% set eye to record
    else if strcmp(domEye,'l')
            Eyelink('command','active_eye=LEFT');	% set eye to record
        else
            error('enter dominant eye')
        end
    end
    Eyelink('command', 'binocular_enabled = NO')
    
    el=EyelinkInitDefaults(w);
    % parameter specifying what instructions to print for calibration
    el.helptext = '';
    % sound control parameters
    % parameters are in frequency, volume, and duration
    % set the second value in each line to 0 to turn off the sound
    el.targetbeep = 0;
    el.cal_target_beep=[600 0 0.05];
    el.drift_correction_target_beep=[600 0 0.05];
    el.calibration_failed_beep=[400 0 0.25];
    el.calibration_success_beep=[800 0 0.25];
    el.drift_correction_failed_beep=[400 0 0.25];
    el.drift_correction_success_beep=[800 0 0.25];
    % you must call this function to apply the changes from above
    EyelinkUpdateDefaults(el);
    
    EyelinkDoTrackerSetup(el);
end