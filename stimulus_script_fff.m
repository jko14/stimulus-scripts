function stimulus_script_fff(Q, dark, bright, reps, lum, cont)
%STIMULUS_SCRIPT_FFF Dark to bright switches.
% The stimulus window stays dark for 'dark' seconds, and then bright for
% 'bright' seconds. This repeats for 'reps' times.

% ---Parameters---
% Q: struct returned by 'init.m'
% dark: dark interval (s)
% bright: bright interval (s)
% reps: repetitions
% lum: luminence
% cont: contrast

p = struct('dark', dark, 'bright', bright, 'reps', reps, 'lum', lum, 'cont', cont);
Q.record({GetSecs, true, mfilename, p});

dark_val = lum * (1 - cont);
bright_val = lum * (1 + cont);
dark_color = [0 get_intensity_bits(dark_val,'G') get_intensity_bits(dark_val,'B')];
bright_color = [0 get_intensity_bits(bright_val,'G') get_intensity_bits(bright_val,'B')];

p = struct('dark_color', dark_color, 'bright_color', bright_color);% change this to the contrast.
Q.record({GetSecs, false, 'colors', p});

config = params;

for i = 1: reps
    % Dark interval
    
    % Starting time
    t0 = GetSecs;
    elapsed = 0;
    % Used for timing rect
    counter = 0;
    while elapsed < dark
        % Check whether Esc is being pressed
        check_esc;
        Screen('FillRect', Q.screen_ptr, dark_color, Q.stimulus_rect);
        if counter < config.timing_frames
            Screen('FillRect', Q.screen_ptr, config.timing_bright, Q.timing_rect);
        else
            Screen('FillRect', Q.screen_ptr, config.timing_dark, Q.timing_rect);
        end
        t = Screen('Flip', Q.screen_ptr);
        if counter == 0
            Q.record({t, false, 'tick', []});
        end
        
        counter = counter + 1;
        elapsed = t - t0;
    end

    % Bright interval
    
    % Starting time
    t0 = GetSecs;
    elapsed = 0;
    % Used for timing rect
    counter = 0;
    while elapsed < bright
        % Check whether Esc is being pressed
        check_esc;
        Screen('FillRect', Q.screen_ptr, bright_color, Q.stimulus_rect);
        if counter < config.timing_frames
            Screen('FillRect', Q.screen_ptr, config.timing_bright, Q.timing_rect);
        else
            Screen('FillRect', Q.screen_ptr, config.timing_dark, Q.timing_rect);
        end
        t = Screen('Flip', Q.screen_ptr);
        if counter == 0
            Q.record({t, false, 'tick', []});
        end
        
        counter = counter + 1;
        elapsed = t - t0;
    end
end