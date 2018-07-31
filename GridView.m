function [ X ] = GridView(M,M_cells,Psi,Psi_cells,PSIIndex,ti,tf,n)
%Creates a grid based on various elements of PSI or M
%PSIIndex references ROW in PSI matrix
close all;

%Determine number of Cells
PSISIZE =size(Psi);
numofcells = PSISIZE(2);

%Determine Dim of Media
MSIZE =size(M);
MH = MSIZE(1);
MW = MSIZE(2);

if PSIIndex ~= 0
    %Intialize Cell GRID
    cellGRID = cell(1,tf);
    for counter = 1:length(cellGRID)
        cellGRID{counter} = zeros(MH,MW);
    end
    %Intialize BooleanGrid
    BooleanGrid = zeros(MH,MW);
end

f = figure('visible','off','position',...
    [360 500 600 600]);

slider =uicontrol('style','slider','position',[150 60 300 20],...
    'min',ti,...
    'max',tf,...
    'SliderStep', [ (1/n) (2/n)],...
    'Value',1,...
    'callback',@callbackfn);

text=uicontrol('style','text',...
    'position',[200 30 200 15],'visible','on');


axes('units','pixels','position',[90 125 450 450]);

movegui(f,'center');

set(f,'visible','on');
    function callbackfn(source,eventdata)
        timestamp=round(get(slider,'value'));
        set(text,'String',strcat('Now Displaying #',num2str(timestamp)));
        if PSIIndex ==0
            %Determine size of the X's
            marksize = 4.5;
            
            %Change value of grid to corresponding value in Matrix M.
            imagesc(M_cells{timestamp});
            axis image;
            colormap winter;
            colorbar;
            hold on;
            
            for Cellcounter = 1:numofcells
                plot(Psi_cells{timestamp}(1,Cellcounter),Psi_cells{timestamp}(2,Cellcounter), '-s',...
                    'MarkerSize',marksize,...
                    'MarkerEdgeColor','r');
            end
        else
            marksize = 4.5;
            
            %Change value of grid at each timestamp to corresponding value in Matrix PSI
            for CellNum = 1:numofcells
                cellGRID{timestamp}(Psi_cells{timestamp}(1,CellNum),Psi_cells{timestamp}(2,CellNum)) = Psi_cells{timestamp}(PSIIndex,CellNum);
                BooleanGrid(Psi_cells{timestamp}(1,CellNum),Psi_cells{timestamp}(2,CellNum)) = 1;
            end
            imagesc(cellGRID{timestamp});
            axis image;
            colormap winter;
            colorbar;
            hold on;
            for Hcounter = 1:MH
                for Wcounter = 1:MW
                    if BooleanGrid(Hcounter,Wcounter) == 1
                        plot(Wcounter,Hcounter,'-s',...
                            'MarkerSize',marksize,...
                             'MarkerEdgeColor','red');
                    end
                end
            end
        end
    end

end


