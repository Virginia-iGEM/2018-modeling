%2018 Virginia iGEM 
%Quorum Sensing 
%Model of Population Activation

%Diffusion Module
%Input vector "M" is an array of w by h 
%M(x,y): is [a square with a [AI2] at x-y coordinate of the medium
%
%Function will calculate diffusion dynamics of the medium
%Function will compute change d[AI2]/dt for each Mxy
%Function will output either dM/dt or an updated M

function Diffusion = Diffusion(M,D,dt)
if ~ismatrix(M)
    error('Input must be a matrix')
end
%insert code for function
end
