%2018 Virginia iGEM 
%Quorum Sensing 
%Model of Population Activation

%Diffusion Module
%Input vector "M" is an array of w by h 
%M(x,y): is [a rectangle with a [AI2] at x-y coordinate of the medium
%
%Function will calculate diffusion dynamics of the medium
%Function will compute change d[AI2]/dt for each Mxy
%Function will output either dM/dt

function dM = Diffusion(M,d)
if ~ismatrix(M)
    error('Input must be a matrix')
end

%initialize variables    
    [h,w] = size(M);
    x = 2:w-1;
    y = 2:h-1;
    dM = zeros(h,w);
%Dirichlet Boundary Conditions
%{
    dM(1,:)= -M(1,:);
    dM(h,:)= -M(h,:);
    dM(:,1)= -M(:,1);
    dM(:,w)= -M(:,w);
%}

    
%Explicit Method for Finite Element Diffusion
    dM(y,x) = (d*(M(y+1,x)-2*M(y,x)+M(y-1,x)))+(d*(M(y,x+1)-2*M(y,x)+M(y,x-1)));

%Neumann Boundary Condition
%{
    newM(1,:)= M(2,:);
    newM(h,:)= M(h-1,:);
    newM(:,1)= M(:,2);
    newM(:,w)= M(:,w-1);
    %}
    dM(1,:) = M(2,:) - M(1,:);
    dM(h,:)= M(h-1,:) - M(h,:);
    dM(:,1)= M(:,2) - M(:,1);
    dM(:,w)= M(:,w-1) - M(:,w);
    
    
    
end
