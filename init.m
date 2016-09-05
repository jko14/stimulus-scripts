function Q = init
%INIT Opens a window, reads the rects, and returns a struct.
%   Note that this function is expected to be called inside a try-clause to
%   let the program exit properly in case an exception is thrown.

% Switch to unified (OSX) key names
KbName('UnifyKeyNames');

Q = [];

% Modify 'params.m' to run on a different screen
config = params;
screen_number = config.screen_number;
% Rect of the experiment screen
Q.screen_rect = Screen('Rect', screen_number);

% Background color is black
screen_ptr = Screen('OpenWindow', screen_number, 0);
% The window pointer
Q.screen_ptr = screen_ptr;

% We can draw to an offscreen window and then copy certain area to the
% onscreen window. This is how I do masking.
Q.offscreen_ptr = Screen('OpenOffscreenWindow', screen_number, 0);

% Used in 'gaussian_lowpass.m'
% Probably should be set to the flip interval later
Q.dt = 1 / 240;

% This helps timing accuracy. See Chapter 9 of 'MATLAB for Psychologists'
% by Mauro Borgo, et al.
% Q.slack = Screen('GetFlipInterval', screen_ptr) / 2;

stimulus_rect = load('stimulus_rect.mat');
stimulus_rect = stimulus_rect.rect;
% The stimulus rect
Q.stimulus_rect = stimulus_rect;

timing_rect = load('timing_rect.mat');
timing_rect = timing_rect.rect;
% The timing rect
Q.timing_rect = timing_rect;

% Struct array used to record experiment data. It does NOT grow, as this is
% likely to cause interruption in display. Therefore, it's critical to
% preallocate a sufficiently large one. At most one row is recorded for
% each frame, so a length of 120000 is sufficient for 1000 seconds, given a
% frame rate of 120Hz.

% Also, I tried to use nested functions to achieve reference semantics, but
% it didn't work. Therefore, global variables are the only choice.

global exp_data counter t0;
exp_data = struct('time', cell(120000, 1), 'is_top_level', [], 'event', [], 'parameters', []);
counter = 0;
t0 = GetSecs;

Q.record = @record;
Q.save = @save_data;

end

% Call with 1*4 cell array
function record(row)
    assert(iscell(row) && length(row) == 4);
    global exp_data counter t0;
    counter = counter + 1;
    exp_data(counter).time = row{1} - t0;
    exp_data(counter).is_top_level = row{2};
    exp_data(counter).event = row{3};
    exp_data(counter).parameters = row{4};
end

function save_data(filename)
    global exp_data counter;
    exp_data = exp_data(1:counter);
    save(filename, 'exp_data');
end