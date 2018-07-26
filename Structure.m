%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expected Predefined Functions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Diffusion(M, D, dt)
% Function(c)

%%%%%%%%%%%%%%
% Parameters %
%%%%%%%%%%%%%%

% Simulation %

variables = containers.Map;
%%% Cell Matrix %%%
variables('n') = 1000;           % Number of Cells
variables('m') = 4;              % Number of Parameters for each Cell

%%% Diffusion Matrix %%%
variables('w') = 1000;            % Medium/Diffusion Grid Width
variables('h') = 1000;            % Medium/Diffusion Grid height

%%% Constants %%%

variables('t_i') = 0;            % Set initial time to 0
variables('t_f') = 10;          % Final time
variables('dt') = 0.1;             % Constant timestep 
variables('D') = 10^-10;         % Diffusion coefficient

% Settings %

% Config file to be passed into setup and simulate functions
config = containers.Map;
% The number of different workers to use for the simulation.
% This value should be equal to the number of cores, *not* the number of
% threads you have available. For most consumer computers this is 2-4, for
% clusters, consult your sysadmin or documentation.
config('workers') = 4; 

% Should progress reports be printed to console?
config('print') = 1;

% How many times should we print progress reports?
config('n_prints') = 4;

% Should .csv files be written to the data folder?
config('write') = 0;

% How many times should we write .csv files?
config('n_writes') = 50;

% Save to cell matrix this many times
config('n_snapshots') = 100;

% Which rows are the different variables in the cell matrix?o
config('Psi_x') = 1;    % The row of Psi which contains the x positions of cells
config('Psi_y') = 2;    % The row of Psi which contains the y position of cells
config('Psi_Ai') = 3;   % The row of Psi which contains the A_o value for cells
config('Psi_Ao') = 4;   % The row of Psi which contains the A_i value for cells

%%%%%%%%%%%%%%%%%
% Initial Setup %
%%%%%%%%%%%%%%%%%

% Temporary setup function
function [Psi, M] = setup(variables, config)
    Psi = ones(variables('m'), variables('n'));   % Matrix of cell column vectors with m rows and n columns
    M = zeros(variables('w'), variables('h'));     % w x h discrete diffusion matrix

    % Assign all A_0 in the cell to the initial value in M
    for col=1:size(Psi, 2)
        column = Psi(:, col);
        % Pass in every value of M at (x, y) (row, columns) to the cell
        Psi(config('Psi_Ao'), col) = M(column(config('Psi_x')), column(config('Psi_y'))); 
    end
end



function [Psi_snapshots, M_snapshots] = simulate(Psi, M, variables, config)

    %%% Setup variables needed for snapshot saving %%%

    steps = variables('t_i'):variables('dt'):variables('t_f');
    
    Psi_snapshots = cell(1, config('n_snapshots'));
    M_snapshots = cell(1, config('n_snapshots'));

    writestep = round(size(steps, 2) / config('n_writes')); % Calculates how often to write files
    printstep = round(size(steps, 2) / config('n_prints'));
    snapshotstep = round(size(steps, 2) / config('n_snapshots'));
    snapshotcounter = 1;
    %%%%%%%%%%%%%%
    % Simulation %
    %%%%%%%%%%%%%%

    for i=1:size(steps,2) % For each timestep
        t = steps(i);
        if config('write') == 1 && mod(i, writestep) == 0 % If enabled, write data to console
            snapshot(Psi, M, t);
        end
        if config('print') == 1 && mod(i, printstep) == 0 % If enabled, print snapshots to .csv
            fprintf("Simulation is %d%% done\n", ceil(100 * (t + variables('dt')) / variables('t_f')))
        end
        if mod(i, snapshotstep) == 0
            Psi_snapshots{snapshotcounter} = Psi;
            M_snapshots{snapshotcounter} = M;
            snapshotcounter = snapshotcounter + 1;
        end
        [Psi, M] = mapcell(Psi, M, variables('dt'), config); % Update cell columns and diffusion matrix using cellular model
        M = M + Diffusion(M, variables('d'))*variables('dt');             % Call diffusion solver on M
        for col=1:size(Psi,2) % Send M Ao to Psi to ensure that diffusion changes are saved to cells
            column = Psi(:, col);
            Psi(config('Psi_Ao'), col) = M(column(config('Psi_x')), column(config('Psi_y')));
        end
    end

end
%%%%%%%%%%%%%
% Functions %
%%%%%%%%%%%%%

% Run cell function on each column of Psi with paralellization
function [Psi, M] = mapcell(Psi, M, dt, config)
    if config('workers') > 0
        % Parallelized for loop of all independent cell model calculations
        parfor (col=1:size(Psi,2), config('workers'))
            Psi(:, col) = Psi(:, col) + Function(Psi(:, col))*dt;
        end
        % Update m_0's A_0 values for each occupied location. This must be
        % done outside of parfor as it would otherwise require passing in
        % m_0 cells, which Matlab does not allow and is very expensive
        % in terms of overhead.
        for col=1:size(Psi,2) 
            column = Psi(:, col);
            M(column(config('Psi_x')), column(config('Psi_y'))) = column(config('Psi_Ao'));
        end
    else
        % For a nonparallel simulation we can just do all of this at once
        for col=1:size(Psi,2)
            column = Psi(:, col);
            Psi(:, col) = column + Function(column)*dt;
            M(column(config('Psi_x')), column(config('Psi_y'))) = column(config('Psi_Ao'));
            %Psi
        end
    end
end

% Do nothing for now, will output CSV's later
function snapshot(Psi, M, time)
    csvwrite(sprintf('data/Psi/time%05d.csv', time), Psi);
    csvwrite(sprintf('data/M/time%05d.csv', time), M);
end

% Dummy cell function, sqrts all column vector values
%{
function c = cell(c, dt)
    c(1) = 0;
    c(2) = 0;
    c(3) = 0;
    c(5) = sum(c);
    c(4) = mean(c);
end
%}

% Dummy diff function, halves all matrix values
%{
function m = diff(m, D, dt)
    m = m + 1;
end
%}