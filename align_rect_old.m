function align_rect
%ALIGN_RECT Places the stimulus and timing rects on the screen.
%   In this function, the user is able to control the position of the
%   stimulus and timing rects with arrow keys. The position is then saved
%   in either 'stimulus_rect.mat' or 'timing_rect.mat' as the variable
%   'rect'.

% Modify 'params.m' to run on a different screen
config = params;
screen_number = config.screen_number;
screen_rect = Screen('Rect', screen_number);

choice = -1;
while choice ~= 0 && choice ~= 1
    choice = input('Input ''0'' for the stimulus rect and ''1'' for the timing rect: ');
end

% The file that will be read in and written out
if choice == 0
    file = 'stimulus_rect.mat';
else
    file = 'timing_rect.mat';
end

width = -1;
while width <= 0 || width > screen_rect(3)
    width = input('Input width of the window: ');
end
height = -1;
while height <= 0 || height > screen_rect(4)
    height = input('Input height of the window: ');
end
rect = CenterRect([0 0 width height], screen_rect);

% Return to MATLAB in case of any error
try
    % Background color is black
    window_ptr = Screen('OpenWindow', screen_number, 0);
    HideCursor;
    DrawFormattedText(window_ptr, ...
        ['Use the arrow keys to move the rect\n', ...
         'Press any key to continue'], 'center', 'center', 255);
    Screen('Flip', window_ptr);
    KbWait;
    % Prevent the keypress from being captured in future calls of KbWait
    WaitSecs(0.2);
    
    % Switch to unified (OSX) key names
    KbName('UnifyKeyNames');
    left = KbName('LeftArrow');
    right = KbName('RightArrow');
    up = KbName('UpArrow');
    down = KbName('DownArrow');
    esc = KbName('ESCAPE');
    
    keys = zeros(1, 256);
    while keys(esc) == 0
        % Target rect is in white
        Screen('FillRect', window_ptr, 255, rect);
        Screen('Flip', window_ptr);
        
        % Prevent any boundaries from going beyond the edge of the screen
        [~, keys] = KbWait;
        if keys(left)
            if rect(1) > 0
                rect(1) = rect(1) - 1;
                rect(3) = rect(3) - 1;
            end
        elseif keys(right)
            if rect(3) < screen_rect(3)
                rect(1) = rect(1) + 1;
                rect(3) = rect(3) + 1;
            end
        elseif keys(up)
            if rect(2) > 0
                rect(2) = rect(2) - 1;
                rect(4) = rect(4) - 1;
            end
        elseif keys(down)
            if rect(4) < screen_rect(4)
                rect(2) = rect(2) + 1;
                rect(4) = rect(4) + 1;
            end
        end
    end
    
    ShowCursor;
    Screen('CloseAll');
    
    fprintf('\n');
    fprintf('Upper left: (%d, %d), Bottom right: (%d, %d), Size: (%d, %d)\n', rect(1), rect(2), rect(3), rect(4), width, height);
    fprintf('Result saved to %s\n', file);
    save(file, 'rect');
catch ME
    ShowCursor;
    Screen('CloseAll');
    rethrow(ME);
end

end