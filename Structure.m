%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expected Predefined Functions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% diff(M, D, dt)
% cell(c, dt)

%%%%%%%%%%%%%%
% Parameters %
%%%%%%%%%%%%%%

%%% Matrices %%%

%%% Cell Matrix %%%
n = 1000;           % Number of Cells
m = 4;              % Number of Parameters for each Cell

%%% Diffusion Matrix %%%
w = 1000;            % Medium/Diffusion Grid Width
h = 1000;            % Medium/Diffusion Grid height

%%% Constants %%%

t_i = 0;            % Set initial time to 0
t_f = 10;          % Final time
dt = 0.1;             % Constant timestep 
D = 10^-10;         % Diffusion coefficient

%%% Settings %%%

Psi_indices = [1,2,3,4]
%Psi_x = 1;          % The row of Psi which contains the x positions of cells
%Psi_y = 2;          % The row of Psi which contains the y position of cells
%Psi_Ai = 3;         % The row of Psi which contains the A_o value for cells
%Psi_Ao = 4;         % The row of Psi which contains the A_i value for cells

% The number of different workers to use for the simulation.
% This value should be equal to the number of cores, *not* the number of
% threads you have available. For most consumer computers this is 2-4, for
% clusters, consult your sysadmin or documentation.
workers = 4;

print = 1;       % Print progress reports?
n_prints = 4;
write = 1;       % Should we write out data?
n_snapshots = 50;   % How many snapshots of the simulation do we want to write out for analysis

config = [workers, Psi_indices, print, n_prints, write, n_snapshots];

%%%%%%%%%%%%%%%%%
% Initial Setup %
%%%%%%%%%%%%%%%%%

% Temporary setup function
function [Psi, M] = setup(n, m, w, h, config)
    Psi = ones(m, n);   % Matrix of cell column vectors with m rows and n columns
    M = zeros(w, h);     % w x h discrete diffusion matrix

    % Assign all A_0 in the cell to the initial value in M
    for col=1:size(Psi, 2)
        column = Psi(:, col);
        % Pass in every value of M at (x, y) (row, columns) to the cell
        Psi(config(2,4), col) = M(column(config(2,1)), column(config(2,2))); 
    end
end



function [Psi_snapshots, M_snapshots] = simulate(Psi, M, t_i, t_f, dt, d, config)

    %%% Setup variables needed for snapshot saving %%%

    steps = t_i:dt:t_f;
    
    Psi_snapshots = cell(1, steps);
    M_snapshots = cell(1, steps);

    writestep = round(size(steps, 2) / config(8)); % Calculates how often to write files
    printstep = round(size(steps, 2) / config(6));

    %%%%%%%%%%%%%%
    % Simulation %
    %%%%%%%%%%%%%%

    for i=1:size(steps,2) % For each timestep
        t = steps(i);
        if config(5) == 1 && mod(i, writestep) == 0 % If enabled, write data to console
            snapshot(Psi, M, t);
        end
        if config(3) == 1 && mod(i, printstep) == 0 % If enabled, print snapshots to .csv
            fprintf("Simulation is %d%% done\n", ceil(100 * (t + dt) / t_f))
        end
        Psi_snapshots{i} = Psi;
        M_snapshots{i} = M;
        [Psi, M] = mapcell(Psi, M, dt, config(1:2)); % Update cell columns and diffusion matrix using cellular model
        M = M + diff(M, d, dt)*dt;             % Call diffusion solver on M
    end

end
%%%%%%%%%%%%%
% Functions %
%%%%%%%%%%%%%

% Run cell function on each column of Psi with paralellization
function [Psi, M] = mapcell(Psi, M, dt, config)
    if config(1) > 0
        % Parallelized for loop of all independent cell model calculations
        parfor (col=1:size(Psi,2), config(1))
            Psi(:, col) = Psi(:, col) + cell(Psi(:, col), dt)*dt;
        end
        % Update m_0's A_0 values for each occupied location. This must be
        % done outside of parfor as it would otherwise require passing in
        % m_0 cells, which Matlab does not allow and is very expensive
        % in terms of overhead.
        for col=1:size(Psi,2) 
            column = Psi(:, col);
            M(column(config(2)), column(config(3))) = column(config(4));
        end
    else
        % For a nonparallel simulation we can just do all of this at once
        for col=1:size(Psi,2)
            column = Psi(:, col);
            Psi(:, col) = column + cell(column, dt)*dt;
            M(column(config(2)), column(config(3))) = column(config(4));
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