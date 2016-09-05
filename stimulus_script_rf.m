function stimulus_script_rf(Q, dark, bright, dark_rf, h_deg, h_offset, v_deg, v_offset, randomize, lum, cont)
%STIMULUS_SCRIPT_RF (Stochastically) determining the receptive field.
%   In each iteration, a block, which is 'h_deg' degrees in width and
%   'v_deg' degrees in height, stays dark for 'dark' seconds and bright for
%   'bright' seconds.
%
% ---Parameters---
% Q: struct returned by 'init.m'
% dark: dark interval (s)
% bright: bright interval (s)
% dark_rf: 'true' for dark RF in bright window
%          'false' for bright RF in dark window
% h_deg: width of a block (degrees)
% h_offset: horizontal step (degrees)
% v_deg: height of a block (degrees)
% v_offset: vertical step (degrees)
% randomize: whether RFs should be shown in random order
% lum: luminence
% cont: contrast

p = struct('dark', dark, 'bright', bright, 'dark_rf', dark_rf, 'h_deg', h_deg, ...
           'h_offset', h_offset, 'v_deg', v_deg, 'v_offset', v_offset, ...
           'randomize', randomize, 'lum', lum, 'cont', cont);
Q.record({GetSecs, true, mfilename, p});

dark_val = lum * (1 - cont);
bright_val = lum * (1 + cont);
dark_color = [0 get_intensity_bits(dark_val,'G') get_intensity_bits(dark_val,'B')];
bright_color = [0 get_intensity_bits(bright_val,'G') get_intensity_bits(bright_val,'B')];

if dark_rf
    window_color = bright_color;
    rf_color = dark_color;
else
    window_color = dark_color;
    rf_color = bright_color;
end

p = struct('window_color', window_color, 'rf_color', rf_color);
Q.record({GetSecs, false, 'colors', p});
    
% (Horizontal) width and offset of blocks in pixels
% Number of horizontal blocks
if h_deg == 0
    h_pix = Q.stimulus_rect(3) - Q.stimulus_rect(1);
    h_offset = 0;
    h_offset_pix = 0;
    h = 1;
else
    h_pix = deg2pix(Q, h_deg);
    h_offset_pix = deg2pix(Q, h_offset);
    h = floor((Q.stimulus_rect(3) - Q.stimulus_rect(1) - h_pix) / h_offset_pix) + 1;
end
% (Vertical) height and offset of blocks in pixels
% Number of vertical blocks
if v_deg == 0
    v_pix = Q.stimulus_rect(4) - Q.stimulus_rect(2);
    v_offset = 0;
    v_offset_pix = 0;
    v = 1;
else
    v_pix = deg2pix(Q, v_deg);
    v_offset_pix = deg2pix(Q, v_offset);
    v = floor((Q.stimulus_rect(4) - Q.stimulus_rect(2) - v_pix) / v_offset_pix) + 1;
end
% Total number of blocks
N = h * v;
if randomize
    % Initialize the random number generator
    rng('default');
    % Order of display
    ord = randperm(N) - 1;
else
    ord = 0: N - 1;
end

config = params;

for i = 1: N
    % Dark interval
    
    % Starting time
    t0 = GetSecs;
    elapsed = 0;
    % Used for timing rect
    counter = 0;
    while elapsed < dark
        % Check whether Esc is being pressed
        check_esc;
        Screen('FillRect', Q.screen_ptr, window_color, Q.stimulus_rect);
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
    offset_h = mod(ord(i), h) * h_offset_pix;
    offset_v = floor(ord(i) / h) * v_offset_pix;
    rect = [Q.stimulus_rect(1) + offset_h, Q.stimulus_rect(2) + offset_v, ...
            Q.stimulus_rect(1) + offset_h + h_pix, Q.stimulus_rect(2) + offset_v + v_pix];
    
    % Starting time
    t0 = GetSecs;
    elapsed = 0;
    % Used for timing rect
    counter = 0;
    while elapsed < bright
        % Check whether Esc is being pressed
        check_esc;
        Screen('FillRect', Q.screen_ptr, window_color, Q.stimulus_rect);
        Screen('FillRect', Q.screen_ptr, rf_color, rect);
        if counter < config.timing_frames
            Screen('FillRect', Q.screen_ptr, config.timing_bright, Q.timing_rect);
        else
            Screen('FillRect', Q.screen_ptr, config.timing_dark, Q.timing_rect);
        end
        t = Screen('Flip', Q.screen_ptr);
        if counter == 0
            deg_h = mod(ord(i), h) * h_offset;
            deg_v = floor(ord(i) / h) * v_offset;
            rect_deg = [deg_h, deg_v, deg_h + h_deg, deg_v + v_deg];
            Q.record({t, false, 'tick', rect_deg});
        end
        
        counter = counter + 1;
        elapsed = t - t0;
    end
end

end