M_cells_json = jsonencode(M_cells);
Psi_cells_json = jsonencode(Psi_cells);

ds = datestr(now, 'dd-mmm-yyyy_HH-MM-SS');

mkdir('data');
mkdir(['data/', ds]);

M_file = fopen(['data/', ds, '/M_cells_', ds, '.json'], 'w');
Psi_file = fopen(['data/', ds, '/Psi_cells_', ds, '.json'], 'w');

fprintf(M_file, M_cells_json);  
fprintf(Psi_file, Psi_cells_json);

save(['data/', ds, '/matlab_data_', ds], 'M_cells', 'Psi_cells');