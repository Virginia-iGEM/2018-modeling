%%%%%%%%%%%%%
% Functions %
%%%%%%%%%%%%%

% diff(M, D, dt)
% cell(c, dt)

%%%%%%%%%%%%%%
% Parameters %
%%%%%%%%%%%%%%

%%% Matrices %%%

%%% Cell Matrix %%%
n = 10;           % Number of Cells
m = 5;              % Number of Parameters for each Cell

%%% Diffusion Matrix %%%
w = 100;            % Medium/Diffusion Grid Width
h = 100;            % Medium/Diffusion Grid height

%%% Constants %%%

t_i = 0;            % Set initial time to 0
t_f = 100;          % Final time
dt = 1;             % Constant timestep 
D = 10^-10;         % Diffusion coefficient

%%% Settings %%%

Psi_x = 1;          % The row of Psi which contains the x positions of cells
Psi_y = 2;          % The row of Psi which contains the y position of cells
Psi_a = 3;        % The row of Psi which contains the A_0 value for cells

% The number of different workers to use for the simulation.
% This value should be equal to the number of cores, *not* the number of
% threads you have available. For most consumer computers this is 2-4, for
% clusters, consult your sysadmin or documentation.
workers = 0; 

print = 1;       % Print progress reports?
n_prints = 4;
write = 1;       % Should we write out data?
n_snapshots = 50;   % How many snapshots of the simulation do we want to write out for analysis

%%%%%%%%%%%%%%%%%
% Initial Setup %
%%%%%%%%%%%%%%%%%

Psi = ones(m, n);   % Matrix of cell column vectors with m rows and n columns
M = zeros(w, h);     % w x h discrete diffusion matrix

% Assign all A_0 in the cell to the initial value in M
for col=1:size(Psi, 2)
    Psi(Psi_a, col) = M(col);
end

%%% Setup variables needed for snapshot saving %%%

steps = t_i:dt:t_f;

writestep = round(size(steps, 2) / n_snapshots); % Calculates how often to write files
printstep = round(size(steps, 2) / n_prints);

%%%%%%%%%%%%%%
% Simulation %
%%%%%%%%%%%%%%

for i=1:size(steps,2) % For each timestep
    t = steps(i);
    if write == 1 && mod(i, writestep) == 0
        snapshot(Psi, M, t);
    end
    if print == 1 && mod(i, printstep) == 0
        fprintf("Simulation is %d%% done\n", ceil(100 * (t + dt) / t_f))
    end
    [Psi, M] = mapcell(Psi, M, dt, workers, Psi_x, Psi_y, Psi_a); % Update cell columns and diffusion matrix using cellular model
    M = M + diff(M, D, dt)*dt;             % Call diffusion solver on M
end

%%%%%%%%%%%%%
% Functions %
%%%%%%%%%%%%%

% Run cell function on each column of Psi with paralellization
function [psi, m] = mapcell(psi, m, dt, workers, psi_x, psi_y, psi_a)
    if workers > 0
        % Parallelized for loop of all independent cell model calculations
        parfor (col=1:size(psi,2), workers)
            psi(:, col) = psi(:, col) + cell(psi(:, col), dt)*dt;
        end
        % Update m_0's A_0 values for each occupied location. This must be
        % done outside of parfor as it would otherwise require passing in
        % m_0 cells, which Matlab does not allow and is very expensive
        % in terms of overhead.
        for col=1:size(psi,2) 
            column = psi(:, col);
            m(column(psi_x), column(psi_y)) = column(psi_a);
        end
    else
        % For a nonparallel simulation we can just do all of this at once
        for col=1:size(psi,2)
            column = psi(:, col);
            psi(:, col) = column + cell(column, dt)*dt;
            m(column(psi_x), column(psi_y)) = column(psi_a);
            %psi
        end
    end
end

% Do nothing for now, will output CSV's later
function snapshot(psi, m, time)
    csvwrite(sprintf('data/psi/time%05d.csv', time), psi);
    csvwrite(sprintf('data/m/time%05d.csv', time), m);
end

% Dummy cell function, sqrts all column vector values
function c = cell(c, dt)
    c(1) = 0;
    c(2) = 0;
    c(3) = 0;
    c(5) = sum(c);
    c(4) = mean(c);
end

% Dummy diff function, halves all matrix values
function m = diff(m, D, dt)
    m = m + 1;
end