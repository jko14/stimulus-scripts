function check_esc
%CHECK_ESC Checks and throws an exception if Esc is being pressed.

[~, ~, keys] = KbCheck;
if keys(KbName('ESCAPE')) ~= 0
    ME = MException('FlyProject:TerminatedByUser', ...
                    'Execution terminated because the Escape key was pressed.');
    throw(ME);
end

end

