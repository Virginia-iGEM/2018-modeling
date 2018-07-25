function [ X ] = GridView(M,PSI,PSIIndex)
%Creates a grid based on various elements of PSI or M
%PSIIndex references ROW in PSI matrix
close all

if PSIIndex == 0
    
    %Determine Dim of Matrix M
    MSIZE =size(M);
    MH = MSIZE(1);
    MW = MSIZE(2);
    GRID = zeros(MH,MW);
    
    %Determine number of Cells
    PSISIZE =size(PSI);
    numofcells = PSISIZE(2);
    
    %Change value of grid to corresponding value in Matrix M.
    for Mcounter = 1:MH*MW
        GRID(Mcounter) = M(Mcounter);
    end
    
    figure(1);
    imagesc(GRID);
    axis image;
    colormap parula;
    colorbar;
    hold on;
    
    for Cellcounter = 1:numofcells
        plot(PSI(1,Cellcounter),PSI(2,Cellcounter), 's')
    end
    
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Determine number of Cells
    PSISIZE =size(PSI);
    numofcells = PSISIZE(2);
    H = 100;
    W = 100;
    marksize = 3;
    GRID = zeros(H,W);
    BooleanGrid = zeros(H,W);
    
    %Change value of grid to corresponding value in Matrix M.
    for Cellcounter = 1:numofcells
        GRID(PSI(1,Cellcounter),PSI(2,Cellcounter)) = PSI(PSIIndex,Cellcounter);
        BooleanGrid(PSI(1,Cellcounter),PSI(2,Cellcounter)) = 1;
    end
    
    figure(1);
    imagesc(GRID);
    axis image;
    colormap parula;
    colorbar;
    hold on;
    
    for Hcounter = 1:H
        for Wcounter = 1:W
            if BooleanGrid(Hcounter,Wcounter) == 0
                plot(Wcounter,Hcounter,'x',...
                        'MarkerSize',marksize,...
                        'MarkerEdgeColor','w',...
                        'MarkerFaceColor',[1,1,1]);
            end
        end
    end
end
% PSI = [ 1 3 5 7; 1 2 4 9; 4 5 9 2]

%M = rand(100)*10;'
end

