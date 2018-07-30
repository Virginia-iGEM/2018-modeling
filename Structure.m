%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expected Predefined Functions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%
function [Psi_cells, M_cells] = Structure(Psi, M, parameters, config)
   
[Psi_cells, M_cells]= Simulate(Psi, M, parameters, config);
   
import Diffusion.m.*
import Cellular_Function.m.*




%%%%%%%%%%%%%%%%%
% Initial Setup %
%%%%%%%%%%%%%%%%%

function [Psi_snapshots, M_snapshots] = Simulate(Psi, M, parameters, config)

    %%% Setup parameters needed for snapshot saving %%%

    steps = parameters('t_i'):parameters('dt'):parameters('t_f');
    
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
            fprintf("Simulation is %d%% done\n", ceil(100 * (t + parameters('dt')) / parameters('t_f')))
        end
        if mod(i, snapshotstep) == 0
            Psi_snapshots{snapshotcounter} = Psi;
            M_snapshots{snapshotcounter} = M;
            snapshotcounter = snapshotcounter + 1;
        end
        [Psi, M] = mapcell(Psi, M, parameters('dt'), config); % Update cell columns and diffusion matrix using cellular model
        M = M + Diffusion(M, parameters('D'))*parameters('dt');             % Call diffusion solver on M
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
            Psi(:, col) = Psi(:, col) + Cellular_Function(Psi(:, col))*dt;
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
            Psi(:, col) = column + Cellular_Function(column)*dt;
            M(column(config('Psi_x')), column(config('Psi_y'))) = column(config('Psi_Ao'));
            %Psi
            for i = 1:parameters('n')
                for j = 1:parameters('m')
                    if isinf(abs(Psi(j,i)))
                        display(Psi);
                        exit;
                    end
                end
            end
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
end