function config = params
%PARAMS Returns a struct of global experimental parameters.

config = [];

% Number of the screen that the experiment will be running on
config.screen_number = 0;

% The distance to the screen (mm)
config.dist = 40;

% The width of the stimulus window (mm)
config.screen_width = 55;

% Color of the timing rect when it's dark
config.timing_dark = 0;

% Color of the timing rect when it's bright
config.timing_bright = 255;

% Number of frames that the timing rect will remain bright
config.timing_frames = 10;

end

