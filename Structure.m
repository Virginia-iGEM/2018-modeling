%%%%%%%%%%%%%
% Functions %
%%%%%%%%%%%%%

% diff(M, D, dt)
% cell(c, dt)

%%%%%%%%%%%%%%
% Parameters %
%%%%%%%%%%%%%%

%%% Matrices %%%

n = 1000; % Number of Cells
m = 5;    % Number of Parameters for each Cell
Psi = ones(m, n); % Matrix of cell column vectors with m rows and n columns

w = 100; % Medium/Diffusion Grid Width
h = 100; % Medium/Diffusion Grid height
M = ones(w, h);   % w x h discrete diffusion matrix

%%% Constants %%%

t_i = 0; % Set initial time to 0
t_f = 100; % Final time
dt = 1;     % Constant timestep 
D = 10^-10; % Diffusion coefficient

%%% Settings %%%

Psi_x = 1; % The row of Psi which contains the x positions of cells
Psi_y = 2; % The row of Psi which contains the y position of cells
Psi_A_0 = 3; % The row of Psi which contains the A_0 value for cells

parallel = 4; % The number of different workers to use for the simulation.
% This value should be equal to the number of cores, *not* the number of
% threads you have available. For most consumer computers this is 2-4, for
% clusters, consult your sysadmin or documentation.

write = true;     % Should we write out data?
n_snapshots = 50; % How many snapshots of the simulation do we want to write out for analysis

%%%%%%%%%%%%%%%%%
% Initial Setup %
%%%%%%%%%%%%%%%%%

%%% Setup variables needed for snapshot saving %%%

snapshots_Psi = {n_snapshots, 1};
snapshots_M = {n_snapshots, 1};
steps = t_i:dt:t_f;
snapstep = size(steps, 1) / size(snapshots, 1);
snapcount = 1;

%%%%%%%%%%%%%%
% Simulation %
%%%%%%%%%%%%%%

for i=1:size(steps,1) % For each timestep
    t = steps(i);
    if i == snapstep
        snapshot(Psi, M);
        snapcount = snapcount + 1;
    end
    [Psi, M] = mapcell(Psi, M); % Update cell columns and diffusion matrix using cellular model
    M = M + diff(M, D, dt)*dt;             % Call diffusion equation on M
    
end

%%%%%%%%%%%%%
% Functions %
%%%%%%%%%%%%%

% Run cell function on each column of Psi with paralellization
function [psi, m] = mapcell(psi, m)
    if parallel > 0
        % Parallelized for loop of all independent cell model calculations
        parfor col=1:size(psi,2)
            psi(:, col) = cell(psi(:, col), dt);
        end
        % Update m_0's A_0 values for each occupied location. This must be
        % done outside of parfor as it would otherwise require passing in
        % m_0 cells, which Matlab does not allow and is very expensive
        % in terms of overhead.
        for col=1:size(psi,2) 
            column = psi(:, col);
            m(column(Psi_x), column(Psi_y)) = column(Psi_A_0);
        end
    else
        % For a nonparallel simulation we can just do all of this at once
        for col=1:size(psi,2)
            column = psi(:, col);
            psi(:, col) = column + cell(column, dt)*dt;
            m(column(Psi_x), column(Psi_y)) = column(Psi_A_0);
        end
    end
end

% Do nothing for now, will output CSV's later
function snapshot(psi, m, time)
    if write
        csvwrite(sprintf('data/psi/time%05d.csv', time), psi);
        csvwrite(sprintf('data/m/time%05d.csv', time), m);
    end
end