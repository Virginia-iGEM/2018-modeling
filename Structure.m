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
Psi_Ao = 3;        % The row of Psi which contains the A_0 value for cells

% The number of different workers to use for the simulation.
% This value should be equal to the number of cores, *not* the number of
% threads you have available. For most consumer computers this is 2-4, for
% clusters, consult your sysadmin or documentation.
workers = 0;

print = 1;       % Print progress reports?
n_prints = 4;
write = 1;       % Should we write out data?
n_snapshots = 50;   % How many snapshots of the simulation do we want to write out for analysis

config = [workers, psi_x, psi_y, psi_Ao, print, n_prints, write, n_snapshots];

%%%%%%%%%%%%%%%%%
% Initial Setup %
%%%%%%%%%%%%%%%%%

function [psi, m] = setup(n, m, w, h)
    Psi = ones(m, n);   % Matrix of cell column vectors with m rows and n columns
    M = zeros(w, h);     % w x h discrete diffusion matrix

    % Assign all A_0 in the cell to the initial value in M REVISE FOR X AND Y
    for col=1:size(Psi, 2)
        Psi(Psi_Ao, col) = M(col);
    end
end



function [psi_snapshots, m_snaphots] = simulate(psi, m, t_i, t_f, dt, d, config)

    %%% Setup variables needed for snapshot saving %%%

    steps = t_i:dt:t_f;

    writestep = round(size(steps, 2) / config(8)); % Calculates how often to write files
    printstep = round(size(steps, 2) / config(6));

    %%%%%%%%%%%%%%
    % Simulation %
    %%%%%%%%%%%%%%

    for i=1:size(steps,2) % For each timestep
        t = steps(i);
        if config(7) == 1 && mod(i, writestep) == 0
            snapshot(psi, m, t);
        end
        if config(5) == 1 && mod(i, printstep) == 0
            fprintf("Simulation is %d%% done\n", ceil(100 * (t + dt) / t_f))
        end
        [psi, m] = mapcell(psi, m, dt, config(1:4)); % Update cell columns and diffusion matrix using cellular model
        m = m + diff(m, d, dt)*dt;             % Call diffusion solver on M
    end

end
%%%%%%%%%%%%%
% Functions %
%%%%%%%%%%%%%

% Run cell function on each column of Psi with paralellization
function [psi, m] = mapcell(psi, m, dt, config)
    if config(1) > 0
        % Parallelized for loop of all independent cell model calculations
        parfor (col=1:size(psi,2), config(1))
            psi(:, col) = psi(:, col) + cell(psi(:, col), dt)*dt;
        end
        % Update m_0's A_0 values for each occupied location. This must be
        % done outside of parfor as it would otherwise require passing in
        % m_0 cells, which Matlab does not allow and is very expensive
        % in terms of overhead.
        for col=1:size(psi,2) 
            column = psi(:, col);
            m(column(config(2)), column(config(3))) = column(config(4));
        end
    else
        % For a nonparallel simulation we can just do all of this at once
        for col=1:size(psi,2)
            column = psi(:, col);
            psi(:, col) = column + cell(column, dt)*dt;
            m(column(config(2)), column(config(3))) = column(config(4));
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