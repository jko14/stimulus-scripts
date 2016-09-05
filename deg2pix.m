function pix = deg2pix(Q, deg)
%DEG2PIX Convert degrees to number of pixels on screen.
%
% ---Parameters---
% Q: struct returned by 'init.m'
% deg: degrees
%
% ---Output---
% pix: Corresponding number of pixels

config = params;

pix = deg * pi / 180 ...        % Convert to radians
      * config.dist ...         % Width on the screen
      / config.screen_width ... % Proportion of the stimulus window
      * (Q.stimulus_rect(3) - Q.stimulus_rect(1));

end

