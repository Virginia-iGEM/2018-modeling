%{
Virginia iGEM 2018
Population Model of Quorum Sensing
Requires:
    Cellular_Function.m
    Diffusion.m
    Structure.m
    GridView.m

Manipulate Psi and M matricies to test effects of initial conditions:
Manipulate constants within Cellular_Function to test sensitivity

%}
clf
clear
%Imports
import Structure.*
import GridView.*
%---------------------

%Variable Indices
var = containers.Map;
var('x') = 1;
var('y') = 2;
var('Ap') = 3;
var('Ai') = 4;
var('Ao') = 5;
var('B') = 6;
var('B|mrna') = 7;
var('F') = 8;
var('F|mrna') = 9;
var('G') = 10;
var('G|mrna') = 11;
var('K') = 12;
var('K|mrna') = 13;
var('P') = 14;
var('P|mrna') = 15;
var('R') = 16;
var('R|mrna') = 17;
var('T') = 18;
var('T|mrna') = 19;
var('X') = 20;
var('X|mrna') = 21;
var('Y') = 22;
var('Y|mrna') = 23;

%Model Parameters
para = containers.Map;
para('n') = 16;                % Number of Cells (needs to be square numer)
para('m') = 23;              % Number of Parameters for each Cell
para('w') = para('n')^2;      % Medium/Diffusion Grid Width
para('h') = para('n')^2;      % Medium/Diffusion Grid height
para('t_i') = 0;              % Set initial time to 0
para('t_f') =  20;             % Final time
para('dt')= 0.005;            % Constant timestep 
para('D') = 1;                 % Diffusion coefficient
parmeters('index') = 0;
%--------------------------------------------------------

%Configuration Parameters
config = containers.Map;
config('workers') = 8; 

config('n_snapshots') = 100;
config('n_snapshots') = config('n_snapshots') - 1;
config('print') = 1;% Should progress reports be printed to console?
config('n_prints') = 5;% How many times should we print progress reports?

config('write') = 0; % Should .csv files be written to the data folder?
config('n_writes') = 50;  % How many times should we write .csv files?

config('Psi_x') = 1;    % The row of Psi which contains the x positions of cells
config('Psi_y') = 2;    % The row of Psi which contains the y position of cells
config('Psi_Ai') = 4;   % The row of Psi which contains the A_o value for cells
config('Psi_Ao') = 5;   % The row of Psi which contains the A_i value for cells
%----------------------------------------------------

%Initial Matrices
Psi = zeros(para('m'),para('n'));
M = zeros(para('h'),para('w'));
%------------------------------


%initial c vector
c_i = zeros(para('m'),1);
%{
for i = 1:para('m')
    c_i(i,1) = 1;
end
%}
c_i(var('Ap')) = 		0;
c_i(var('Ai')) = 		0;
c_i(var('Ao')) = 		0;
c_i(var('B')) = 		0;
c_i(var('B|mrna')) = 	0;
c_i(var('F')) = 		0;
c_i(var('F|mrna')) = 	0;
c_i(var('G')) = 		0;
c_i(var('G|mrna')) = 	0;
c_i(var('K')) = 		1;
c_i(var('K|mrna')) = 	0;
c_i(var('P')) = 		1;
c_i(var('P|mrna')) = 	0;
c_i(var('R')) = 		10;
c_i(var('R|mrna')) = 	0;
c_i(var('T')) = 		0;
c_i(var('T|mrna')) = 	0;
c_i(var('X')) = 		1;
c_i(var('X|mrna')) =    0;
c_i(var('Y')) = 		10;
c_i(var('Y|mrna')) = 	1;

%--------------------------


%initialize Psi Matrix
i = 1;

for x = floor(para('w')/2-sqrt(para('n'))/2):1:(floor(para('w')/2+sqrt(para('n')/2))-1)
    for y = floor(para('h')/2-sqrt(para('n'))/2):1:(floor(para('h')/2+sqrt(para('n'))/2)-1)
        if i<=para('n')
            Psi(1,i) = round(x);
            Psi(2,i) = round(y);
            i = i+1;
        end
    end
end

%Randomization Distribution
gm = gmdistribution(1,0);

%--------
for i = 1:para('n')
    for j = 3:para('m')
    Psi(j,i) = c_i(j,1)*random(gm);
    end
end
%--------------------------

%initialize M Matrix
for i = 1:para('n')
    x = Psi(1,i);
    y = Psi(2,i);
    M(x,y) = Psi(5,i);
end
%------------------------

%Simulate
[Psi_cells, M_cells,time] = Structure(Psi, M, para, config);
%-----------------

%Statistically Analyze

%Graph
Readout1 = zeros(para('n'),config('n_snapshots'));
Readout2 = zeros(para('n'),config('n_snapshots'));
Readout3 = zeros(para('n'),config('n_snapshots'));
for i = 1:config('n_snapshots')
    for j = 1:para('n')
        Readout1(j,i) = Psi_cells{i}(var('Ao'),j);
    end
end
t =  1:config('n_snapshots');
figure(1)

for i=1:para('n')
    plot(t,Readout1(i,:));
     hold on
    %plot(t,Readout2(i,:));
    %plot(t,Readout3(i,:));
    legend('Ao')
end
hold off
%View
%GridView(M_cells,Psi_cells,para(index))
%----------------