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
function [] = Model_Population(filename)

%Imports
import Structure.*
import GridView.*
%---------------------

%Initial Parameters
para = containers.Map;
para('n') = 9;      %DEFAULT = 9         % Number of Cells (needs to be square number)
para('m') = 25;                             % Number of Parameters for each Cell
para('w') = ceil(2.1*para('n')^(1/2));           % Medium/Diffusion Grid Width
para('h') = ceil(2.1*para('n')^(1/2));           % Medium/Diffusion Grid height
para('t_i') = 0;           %DEFAULT = 0         % Set initial time to 0
para('t_f') =  120;         %DEFAULT = 120       % Final time
para('dt')= 10^(-5);       %DEFAULT = 10^(-5)   % Constant timestep 
para('D') = 10^3;          %DEFAULT = 10^(3)    % Diffusion coefficient
%--------------------------------------------------------

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
var('X_g') = 20;
var('X_p') = 21;
var('X_p|mrna') = 22;
var('Y_g') = 23;
var('Y_p') = 24;
var('Y_p|mrna') = 25;
%-------------------------------

%Configuration Parameters
config = containers.Map;
config('workers') = 27; 

config('n_snapshots') = 200;
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
c_i(var('F')) = 		0.32619;
c_i(var('F|mrna')) = 	0.002646;
c_i(var('G')) = 		0;
c_i(var('G|mrna')) = 	0;
c_i(var('K')) = 		0.3857258/100; %OR 0.183
c_i(var('K|mrna')) = 	0.0056787/100;
c_i(var('P')) = 		0;
c_i(var('P|mrna')) = 	0;
c_i(var('R')) = 		1.7143;
c_i(var('R|mrna')) = 	0.01514;
c_i(var('T')) = 		0;
c_i(var('T|mrna')) = 	0;
c_i(var('X_g')) = 		5.85966;
c_i(var('X_p')) =       0;
c_i(var('X_p|mrna')) =    0;
c_i(var('Y_g')) = 		1.4565;
c_i(var('Y_p')) =       0;
c_i(var('Y_p|mrna')) =    0;
%--------------------------

%Reinitialize M Matrix
for p = 1:para('h')
    for q = 1:para('w')
        M(p,q) = c_i(var('Ao'));
    end
end

%initialize Psi Matrix
iter = 1;

%Cells Tightly Packed
%{
for x = round(para('w')/2-sqrt(para('n'))/2):1:(round(para('w')/2+sqrt(para('n')/2))-1)
    for y = round(para('h')/2-sqrt(para('n'))/2):1:(round(para('h')/2+sqrt(para('n'))/2)-1)
        if i<=para('n')
            Psi(1,i) = round(x);
            Psi(2,i) = round(y);
            i = i+1;
        end
    end
end
%}
%-----------------------------------------

%Cells Spaced Out

for i = 1:round(sqrt(para('n')))
    for j = 1:round(sqrt(para('n')))
        if iter<=para('n')
            Psi(1,iter) = round(para('w')/2-2*sqrt(para('n')-1)/2+2*(i-1))+1;
            Psi(2,iter) = round(para('h')/2-2*sqrt(para('n')-1)/2+2*(j-1))+1;
            iter = iter+1;
        end
    end
end
%----------------------------------

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
SaveData(M_cells, Psi_cells, time, para, config, var, filename);

end