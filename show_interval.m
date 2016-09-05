function show_interval(Q)
%SHOW_INTERVAL Show gray rect for 'interval' seconds.
%
% ---Parameters---
% Q: struct returned by 'init.m'

Q.record({GetSecs, true, mfilename, struct()});

% Length of the interval (s)
interval = 3;
% Color of the stimulus rect
color = 127;

config = params;

% Starting time
t0 = GetSecs;
elapsed = 0;
% Used for timing rect
counter = 0;

while elapsed < interval
    check_esc;
    Screen('FillRect', Q.screen_ptr, color, Q.stimulus_rect);
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