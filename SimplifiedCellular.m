%2018 Virginia iGEM 
%Quorum Sensing 
%Model of Population Activation

function [ddt] = SimplifiedCellular(c)

%{
Function Module
Input vector "c" is an array of m by 1
Vector "c" contains state information of one cell
%}

%c(1) = x
%c(2) = y
%c(3) = Ap
%c(4) = Ai
%c(5) = Ao
%c(6) = B
%---------------------------

%{
Function will calculate and output d/dt for each c(i)
 d/dt of c(i) will be determined by state of c and differential equations
 relating how the species concentrations affect each other
%}

rate_of_AI2_production = 1;
import_constant = 1;
AI2P_LsrK_relationship = 1;


if ~isvector(c)
    error('Input must be a vector')
end
ddt = zeros(23,1);
ddt(4,1) = rate_of_AI2_production + import_constant*c(6);
ddt(3,1) = ddt(4,1);
ddt(5,1) = -import_constant*c(6);
ddt(6,1) = AI2P_LsrK_relationship*c(3);

end