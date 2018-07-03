%popstate variables---------
height = 1000;
width = 1000;
numcells = 1000;
dt = 1;
medium = zeros(height,width);

%cellstate variables-----------
C = zeros(numcells,2);
    %C(1) = AI-2 in
    %C(2) = LsrACDB


%functions---------------------
function cell = cellular(x)
if ~isvector(x)
    error('Input must be a vector')
end
for i = 1:numcells
    
end
