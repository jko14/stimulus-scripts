try
    Q = init;
    HideCursor;
    show_interval(Q);
    stimulus_script_fff(Q, 1, 6, 2, 0.5, 1);
    stimulus_script_fff_sto(Q, 5, 0.01, 2, 0.5, 0.35);
    stimulus_script_rf(Q, 2, 0.5, false, 0, 0, 10, 5, false, 0.5, 0.5);
    stimulus_script_rf_sto(Q, 10, 10, 0.05, 0.5, 0.35);
    stimulus_script_moving_line(Q, 5, 30, 15, false, 0.5, 0.5);
    stimulus_script_moving_edge(Q, 60, 15, true, 0.5, 0.5);
    stimulus_script_step_cont(Q, 1, 1, 2, 0.5, 0.1:0.1:0.5);
    stimulus_script_moving_sine(Q, 5, 30, 10, 10, 0.5, 0.3);
    stimulus_script_moving_square(Q, 5, 30, 10, 10, 0.5, 0.3);
    show_interval(Q);
    sca;
    Q.save(['data_', datestr(now, 'yyyymmddHHMMSS'), '.mat']);
catch ME
    sca;
    rethrow(ME);
end