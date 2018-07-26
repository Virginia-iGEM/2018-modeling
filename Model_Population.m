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
%Imports
import SimuPop.*
import GridView.*
%----------------------

%Model Parameters
parameters = containers.Map;
parameters('n') = 9;                % Number of Cells (needs to be square numer)

parameters('m') = 2+4;              % Number of Parameters for each Cell
parameter('w') = n;               % Medium/Diffusion Grid Width
parameters('h') = n;              % Medium/Diffusion Grid height
parameters('t_i') = 0;              % Set initial time to 0
parameters('t_f') = 10;             % Final time
parameters('dt')= 0.1;              % Constant timestep 
parameters('D') = 10^-10;           % Diffusion coefficient
parmeters('index') = 0;
%--------------------------------------------------------

%Configuration Parameters
config = containers.Map;
config('workers') = 4; 

config('n_snapshots') = 100;

config('print') = 1;% Should progress reports be printed to console?
config('n_prints') = 4;% How many times should we print progress reports?

config('write') = 0; % Should .csv files be written to the data folder?
config('n_writes') = 50;  % How many times should we write .csv files?

config('Psi_x') = 1;    % The row of Psi which contains the x positions of cells
config('Psi_y') = 2;    % The row of Psi which contains the y position of cells
config('Psi_Ai') = 4;   % The row of Psi which contains the A_o value for cells
config('Psi_Ao') = 5;   % The row of Psi which contains the A_i value for cells
%----------------------------------------------------

%Randomization Distribution
gm = gmdistribution(1,0.000005);
%------------------------------

%Initial Matrices
Psi = zeros(m,n);
M = zeros(h,w);
%------------------------------

%initial c vector
c_i = zeros(m,1);
c_i(3,1) = 0; %Ap
c_i(4,1) = 0; %Ai
c_i(5,1) = 10; %Ao
c_i(6,1) = 1; %B
%-------------------------

%initialize Psi Matrix
i = 1;
for x = floor(w/2-sqrt(n)/2):1:floor(w/2+sqrt(n)/2)
    for y = floor(h/2-sqrt(n)/2):1:floor(h/2+sqrt(n)/2)
        if i<=n
            Psi(1,i) = round(x);
            Psi(2,i) = round(y);
            i = i+1;
        end
    end
end

for i = 1:n
    for j = 3:m
    Psi(j,i) = c_i(j,1)*random(gm);
    end
end
%--------------------------

%initialize M Matrix
for i = 1:n
    x = Psi(1,i);
    y = Psi(2,i);
    M(x,y) = Psi(5,i);
end
%------------------------

%Simulate
[Psi_cells, M_cells] = Structure(Psi, M, parameters, config);
%-----------------

%Statistically Analyze

%Graph

%View
GridView(M_cells,Psi_cells,parameters(index))
%----------------