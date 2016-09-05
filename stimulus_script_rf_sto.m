function stimulus_script_rf_sto(Q, dur, deg, tau, lum, cont)
%STIMULUS_SCRIPT_RF_STO Changing all blocks' color in every frame.
%   For 'dur' seconds: change the color of every block in the stimulus
%   window, whose width and height constitutes 'deg' degrees of the view
%   angle, in every frame stochastically, with 'tau' as the time constant.
%
% ---Parameters---
% Q: struct returned by 'init.m'
% dur: duration (s)
% deg: view angle of a block (degrees)
% tau: time constant
% lum: luminence
% cont: contrast

p = struct('dur', dur, 'deg', deg, 'tau', tau, 'lum', lum, 'cont', cont);
Q.record({GetSecs, true, mfilename, p});

% Initialize the random number generator
rng('default');
    
% Number of pixels on screen corresponding to 'deg' degrees
pix = deg2pix(Q, deg);
% Number of horizontal blocks
h = floor((Q.stimulus_rect(3) - Q.stimulus_rect(1)) / pix);
% Number of vertical blocks
v = floor((Q.stimulus_rect(4) - Q.stimulus_rect(2)) / pix);
% Total number of blocks
N = h * v;
% The random variables
nval = zeros(1, N);

seq = 0: N - 1;
h_seq = Q.stimulus_rect(1) + mod(seq, h) * pix;
v_seq = Q.stimulus_rect(2) + floor(seq / h) * pix;
% All the rects inside the stimulus window
rects = [h_seq; v_seq; h_seq + pix; v_seq + pix];

h_deg = mod(seq, h) * deg;
v_deg = floor(seq / h) * deg;
rect_deg = [h_deg; v_deg; h_deg + deg; v_deg + deg];
Q.record({GetSecs, false, 'rect degrees', rect_deg});

config = params;

% Starting time
t0 = GetSecs;
elapsed = 0;
% Used for timing rect
counter = 0;

while elapsed < dur
    % Check whether Esc is being pressed
    check_esc;
    
    nval = gaussian_lowpass(nval, tau, Q.dt);
    n1 = lum * (1 + cont * nval);
    nval = gaussian_lowpass(nval, tau, Q.dt);
    n2 = lum * (1 + cont * nval);
    colors = [zeros(1, N); get_intensity_bits(n1, 'G'); get_intensity_bits(n2, 'B')];

    Screen('FillRect', Q.screen_ptr, colors, rects);
    if counter < config.timing_frames
        Screen('FillRect', Q.screen_ptr, config.timing_bright, Q.timing_rect);
    else
        Screen('FillRect', Q.screen_ptr, config.timing_dark, Q.timing_rect);
    end
    t = Screen('Flip', Q.screen_ptr);
    if counter == 0
        Q.record({t, false, 'tick', []});
    end
    Q.record({t, false, 'flipped', colors});

    counter = counter + 1;
    elapsed = t - t0;
end