%{
Virginia iGEM 2018
Population Model
Requires:
    Cellular_Function.m
    Diffusion.m
    Structure.m

Manipulate Psi and M matricies to test effects of initial conditions:
Manipulate constants within Cellular_Function to test sensitivity

%}

%%% Cell Matrix %%%
n = 9;           % Number of Cells (needs to be square numer)
m = 4;              % Number of Parameters for each Cell

%%% Diffusion Matrix %%%
w = 100;            % Medium/Diffusion Grid Width
h = 100;            % Medium/Diffusion Grid height

%%% Constants %%%

t_i = 0;            % Set initial time to 0
t_f = 10;          % Final time
dt = 0.1;             % Constant timestep 
D = 10^-10;         % Diffusion coefficient

gm = gmdistribution(1,0.05);

Psi = zeros(m,n);
M = zeros(w,h);

%initial c vector---------
c_i = zero(1,m)
c_i(3) = 0; %Ap
c_i(4) = 0; %Ai
c_i(5) = 10; %Ao
c_i(6) = 1; %B
%-------------------------

%initialize Psi Matrix
for x = (floor((sqrt(n)-w)/2)):(floor((sqrt(n)+w)/2))
    for y = (floor((sqrt(n)-h)/2)):(floor((sqrt(n)+h)/2))
        if i<=n
            Psi(1,i) = x;
            Psi(2,i) = y;
            i = i+1;
        end
    end
end

for i = 1:n
    for j = 2:m
    Psi(j,i) = c_i(j)*random(gm);
    end
end
%--------------------------
    
    

