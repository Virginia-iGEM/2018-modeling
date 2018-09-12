function SaveData(M_cells, Psi_cells, time)
    % Prep an idiotproof datestring
    ds = datestr(now, 'dd-mmm-yyyy_HH-MM-SS');

    % Create directories for data if they don't already exist
    % May throw warning; doesn't matter.
    mkdir('data');
    mkdir(['data/', ds]);

    % Save data to json format for display on the wiki
    % Package all data in json format
    json_data = jsonencode(containers.Map( ...
    {'M_cells', 'Psi_cells', 'time'}, ...
    {M_cells, Psi_cells, time}));

    % Open json file for writing
    json_file = fopen(['data/', ds, '/web_data_', ds, '.json'], 'w');
    fprintf(json_file, json_data);

    % Save data to .mat format for reloading in matlab
    save(['data/', ds, '/matlab_data_', ds], 'M_cells', 'Psi_cells');
end