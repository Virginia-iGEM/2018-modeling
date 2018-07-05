%2018 Virginia iGEM 
%Quorum Sensing 
%Model of Population Activation

%Function Module
%Input vector "c" is an array of m by 1
%Vector "c" contains state information of one cell
%
%State information:
%   c(1): x position in M
%   c(2): y position in M
%   c(3): [AI-2] inside cell
%   c(4): [AI-2] outside cell in M(x,y)
%   c(5)...c(m): other molecular concentrations
%
%Function will calculate and output d/dt for each c(i)
% d/dt of c(i) will be determined by state of c

function Function["ToDo"] = cellular(c)
if ~isvector(c)
    error('Input must be a vector')
end
%insert code for function
end
