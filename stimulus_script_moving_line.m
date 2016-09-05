function stimulus_script_moving_line(Q, width, direction, speed, dark_line, lum, cont)
%STIMULUS_SCRIPT_MOVING_LINE Displays a moving line in the stimulus rect.
%   Displays a line, whose width is 'width' degrees, moving at a speed of
%   'speed' degrees/s in the direction of 'direction'.
%
% ---Parameters---
% Q: struct returned by 'init.m'
% width: width of the line (degrees)
% direction: moving direction of the line
%            0-right; 90-down; 180-left; 270-up
%            angles between them are also possible
% speed: moving speed of the line (degrees/s)
% dark_line: 'true' for dark line and bright rect
%            'false' for bright line and dark rect
% lum: luminence
% cont: contrast

p = struct('width', width, 'direction', direction, 'speed', speed, 'dark_line', dark_line, 'lum', lum, 'cont', cont);
Q.record({GetSecs, true, mfilename, p});

dark_val = lum * (1 - cont);
bright_val = lum * (1 + cont);
dark_color = [0 get_intensity_bits(dark_val,'G') get_intensity_bits(dark_val,'B')];
bright_color = [0 get_intensity_bits(bright_val,'G') get_intensity_bits(bright_val,'B')];

if dark_line
    line_color = dark_color;
    rect_color = bright_color;
else
    line_color = bright_color;
    rect_color = dark_color;
end

p = struct('line_color', line_color, 'rect_color', rect_color);
Q.record({GetSecs, false, 'colors', p});

% Speed in pixels/s and width in pixels
speed_pix = deg2pix(Q, speed);
width_pix = deg2pix(Q, width);

% Center of the stimulus rect, and also anchor point of the canvas rotation
anchor_x = (Q.stimulus_rect(1) + Q.stimulus_rect(3)) / 2;
anchor_y = (Q.stimulus_rect(2) + Q.stimulus_rect(4)) / 2;

% Initial offset and length of the line
[initial_offset, L] = calc(Q, direction);

% Duration
dur = 2 * initial_offset / speed_pix;

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
    Screen('FillRect', Q.offscreen_ptr, rect_color, Q.stimulus_rect);
    
    % Save the current transformation
    Screen('glPushMatrix', Q.offscreen_ptr);
    
    % Remember that transformations are applied in reverse order, so what
    % the following three lines do is to rotate the canvas by 'direction'
    % degrees clockwise around the anchor
    Screen('glTranslate', Q.offscreen_ptr, anchor_x, anchor_y);
    Screen('glRotate', Q.offscreen_ptr, direction);
    Screen('glTranslate', Q.offscreen_ptr, -anchor_x, -anchor_y);
    
    offset = speed_pix * elapsed;
    rect = [anchor_x - initial_offset + offset - width_pix / 2, ...
            anchor_y - L / 2, ...
            anchor_x - initial_offset + offset + width_pix / 2, ...
            anchor_y + L / 2];
    Screen('FillRect', Q.offscreen_ptr, line_color, rect);
    
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
    Q.record({t, false, 'flipped', elapsed / dur});
    
    counter = counter + 1;
    elapsed = t - t0;
end

end

% Returns the initial offset and length of the line
function [initial_offset, L] = calc(Q, direction)
    [width, height] = RectSize(Q.stimulus_rect);
    diagonal = sqrt(width ^ 2 + height ^ 2);
    
    % Set the line to be slightly longer than the diagonal
    L = 1.3 * diagonal;
    
    % Angle between the diagonal and the left/right border (radians)
    theta = atan(width / height);
    
    % Angle between the line and the left/right border (radians)
    alpha = mod(direction, 180);
    if alpha > 90
        alpha = alpha - 90;
    end
    alpha = alpha * pi / 180;
    
    initial_offset = diagonal / 2 * sin(alpha + theta);
end