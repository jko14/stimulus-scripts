function stimulus_script_moving_sine(Q, dur, direction, period, speed, lum, cont)
%STIMULUS_SCRIPT_MOVING_SINE Displays a moving sine wave in the stimulus rect.
%   For 'dur' seconds: displays a sine wave, whose period is 'period'
%   degrees, moving at a speed of 'speed' degrees/s in the direction of
%   'direction'.
%
% ---Parameters---
% Q: struct returned by 'init.m'
% dur: duration (s)
% direction: moving direction of the wave
%            0-right; 90-down; 180-left; 270-up
%            angles between them are also possible
% period: period of the wave (degrees)
% speed: moving speed of the wave (degrees/s)
% lum: luminence
% cont: contrast

p = struct('dur', dur, 'direction', direction, 'period', period, 'speed', speed, 'lum', lum, 'cont', cont);
Q.record({GetSecs, true, mfilename, p});

% Period in pixels and speed in pixels/s
period_pix = deg2pix(Q, period);
speed_pix = deg2pix(Q, speed);

% Center of the stimulus rect, and also anchor point of the canvas rotation
anchor_x = (Q.stimulus_rect(1) + Q.stimulus_rect(3)) / 2;
anchor_y = (Q.stimulus_rect(2) + Q.stimulus_rect(4)) / 2;

% Diagonal of the stimulus rect
L = calc(Q);

config = params;

% Starting time
t0 = GetSecs;
elapsed = 0;
% Used for timing rect
counter = 0;

while elapsed < dur
    % Check whether Esc is being pressed
    check_esc;
    
    % We first draw to the offscreen window, then copy to the onscreen
    % window, so that only the part inside the stimulus rect is shown
    
    % Save the current transformation
    Screen('glPushMatrix', Q.offscreen_ptr);
    
    % Remember that transformations are applied in reverse order, so what
    % the following three lines do is to rotate the canvas by 'direction'
    % degrees clockwise around the anchor
    Screen('glTranslate', Q.offscreen_ptr, anchor_x, anchor_y);
    Screen('glRotate', Q.offscreen_ptr, direction);
    Screen('glTranslate', Q.offscreen_ptr, -anchor_x, -anchor_y);
    
    % All x coordinates
    % Using a step of 0.5 to cover all pixels when rotated
    x = floor(anchor_x - L / 2):0.5:ceil(anchor_x + L / 2);
    xy_start = [x; ones(1, length(x)) * floor(anchor_y - L / 2)];
    xy_end = [x; ones(1, length(x)) * ceil(anchor_y + L / 2)];
    % Using a series of vertical lines to fill the stimulus rect
    xy = zeros(2, length(x) * 2);
    xy(:, 1:2:end) = xy_start;
    xy(:, 2:2:end) = xy_end;
    
    offset = speed_pix * elapsed;
    
    % These are the most important lines
    % Change these lines to use a different function
    color = sin(2 * pi / period_pix * (xy(1, :) - offset)) * cont + lum;
    color = [zeros(1, length(color)); get_intensity_bits(color,'G'); get_intensity_bits(color,'B')];
    
    Screen('DrawLines', Q.offscreen_ptr, xy, [], color);
    
    % Load the saved transformation
    Screen('glPopMatrix', Q.offscreen_ptr);
    
    Screen('CopyWindow', Q.offscreen_ptr, Q.screen_ptr, Q.stimulus_rect, Q.stimulus_rect);
    
    if counter < config.timing_frames
        Screen('FillRect', Q.screen_ptr, config.timing_bright, Q.timing_rect);
    else
        Screen('FillRect', Q.screen_ptr, config.timing_dark, Q.timing_rect);
    end
    t = Screen('Flip',Q.screen_ptr);
    if counter == 0
        Q.record({t, false, 'tick', []});
    end
    
    counter = counter + 1;
    elapsed = t - t0;
end

end

% Returns the diagonal of the stimulus rect
function L = calc(Q)
    [width, height] = RectSize(Q.stimulus_rect);
    L = sqrt(width ^ 2 + height ^ 2);
end