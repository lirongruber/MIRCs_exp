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
    Eyelink('message', 'display_coords %ld %ld %ld %ld', 0, 0, 1919, 1079);
    Eyelink('command','marker_phys_coords = -280, 180, -280, -40, 280, 180, 280, -40');
    Eyelink('command','screen_phys_coords = -260, 147, 260, -147'); %screen vpixx is 52/29.4 cm
    Eyelink('command','simulation_screen_distance = 1000');%1000= 1 meter
    Eyelink('command','calibration_type = HV9');
    el=EyelinkInitDefaults(w);
    
    if strcmp(domEye,'r')
        Eyelink('command','active_eye=RIGHT');	% set eye to record
    else if strcmp(domEye,'l')
            Eyelink('command','active_eye=LEFT');	% set eye to record
        else
            error('enter dominant eye')
        end
    end
    Eyelink('command', 'binocular_enabled = NO');
    EyelinkDoTrackerSetup(el);
end