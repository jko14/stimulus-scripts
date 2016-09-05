function stimulus_script_fff_sto(Q, dur, tau, reps, lum, cont)
%STIMULUS_SCRIPT_FFF_STO Changing color stochastically in every frame.
%   For 'reps' repetitions and for 'dur' seconds: change the color of the
%   stimulus window in every frame. The new color is obtained by calling
%   'gaussian_lowpass' with 'tau' as the time constant.

% ---Parameters---
% Q: struct returned by 'init.m'
% dur: duration (s)
% tau: time constant (s)
% reps: repetitions
% lum: luminence
% cont: contrast

p = struct('dur', dur, 'tau', tau, 'reps', reps, 'lum', lum, 'cont', cont);
Q.record({GetSecs, true, mfilename, p});

config = params;

for i = 1: reps
    % Initialize the random number generator
    rng('default');

    % The random variable
    nval = 0;

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
        color = [0 get_intensity_bits(n1, 'G') get_intensity_bits(n2, 'B')];

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
        Q.record({t, false, 'flipped', color});

        counter = counter + 1;
        elapsed = t - t0;
    end
end

end