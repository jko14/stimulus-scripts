function stimulus_script_step_cont(Q, dark, bright, reps, lum, cont)
%STIMULUS_SCRIPT_STEP_CONT Displays FFF with varying contrasts.
% The stimulus window stays dark for 'dark' seconds, and then bright for
% 'bright' seconds. This repeats for every contrast value in zero-augmented
% 'cont'. This again repeats for 'reps' repetitions.

% ---Parameters---
% Q: struct returned by 'init.m'
% dark: dark interval (s)
% bright: bright interval (s)
% reps: repetitions
% lum: luminence
% cont: array of contrast values
%       if cont == [0.1 0.2 0.3]
%           actual_cont == [0 0.1 0 0.2 0 0.3 0]

p = struct('dark', dark, 'bright', bright, 'reps', reps, 'lum', lum, 'cont', cont);
Q.record({GetSecs, true, mfilename, p});

% Insert zeros before and after elements
cont = cont(:);
cont = [zeros(1, length(cont)); cont'];
cont = [cont(:); 0];

config = params;

for i = 1: reps
    Q.record({GetSecs, false, 'new iteration', []});
    
    for j = 1: length(cont)
        Q.record({GetSecs, false, 'contrast', cont(j)});

        dark_val = lum * (1 - cont(j));
        bright_val = lum * (1 + cont(j));
        dark_color = [0 get_intensity_bits(dark_val,'G') get_intensity_bits(dark_val,'B')];
        bright_color = [0 get_intensity_bits(bright_val,'G') get_intensity_bits(bright_val,'B')];

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
end

end