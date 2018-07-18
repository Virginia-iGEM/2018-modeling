%2018 Virginia iGEM 
%Quorum Sensing 
%Model of Population Activation

%Diffusion Module
%Input vector "M" is an array of w by h 
%M(x,y): is [a square with a [AI2] at x-y coordinate of the medium
%
%Function will calculate diffusion dynamics of the medium
%Function will compute change d[AI2]/dt for each Mxy
%Function will output either dM/dt

function dM = Diffusion(M,d)
if ~ismatrix(M)
    error('Input must be a matrix')
end

%initialize variables    
    [w,h] = size(M);
    x = 2:w-1;
    y = 2:h-1;
    dM = zeros(w,h);
%Dirichlet Boundary Conditions
    dM(1,:)= -M(1,:);
    dM(w,:)= -M(w,:);
    dM(:,1)= -M(:,1);
    dM(:,h)= -M(:,h);
%Explicit Method for Finite Element Diffusion
    dM(x,y) = (d*(M(x+1,y)-2*M(x,y)+M(x-1,y)))+(d*(M(x,y+1)-2*M(x,y)+M(x,y-1)));

end
