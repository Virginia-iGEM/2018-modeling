function [ X ] = GridView(M,PSI)
%Creates a grid based on various elements of PSI
close all

MSIZE =size(M);
MH = MSIZE(1);
MW = MSIZE(2);

PSISIZE =size(PSI);
PH = PSISIZE(1);
PW = PSISIZE(2);

GRID = zeros(MH,MW);


for Mcounter = 1:MH*MW
    GRID(Mcounter) = M(Mcounter);
end

% for PSICounter = 1:PH*PW
%     plot(PSI(1,counter),PSI(2,counter), '-o')
% end
figure(1);
imagesc(GRID);
axis image;

colormap winter;
colorbar;

% PSI = [ 1 3 5 7; 1 2 4 9; 4 5 9 2]
% M = [ 1 3 5 7; 1 2 4 9; 4 5 9 2; 0 2 3 9]
end

