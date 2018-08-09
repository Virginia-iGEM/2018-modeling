function [ X ] = GridView(M_cells,Psi_cells,PSIIndex,ti,tf,n)
%Creates a grid based on various elements of PSI or M
%M_cells -> Cell matrix which contains M matrices at different timestamps
%Psi_Cells -> Cell Matrix which contains Psi matrices at different TS's
%PSIIndex -> References ROW Element in PSI matrix (0 = M Matrix)
%ti -> Intial timestamp
%tf -> Final timestamp
%n -> Number of evenly spaced intervals in slider
%close all;

%Determine number of Cells
PSISIZE =size(Psi_cells{1});
numofcells = PSISIZE(2);

%Determine Dim of Media
MSIZE =size(M_cells{1});
MH = MSIZE(1);
MW = MSIZE(2);

%If NOT working with M Matrix
if PSIIndex ~= 0
    %Intialize Cell GRID with 0 matricies
    cellGRID = cell(1,length(Psi_cells));
    for counter = 1:length(cellGRID)
        cellGRID{counter} = zeros(MH,MW);
    end
    %Intialize BooleanGrid
    BooleanGrid = zeros(MH,MW);
end

%Create figure for slider
f = figure('visible','off','position',...
    [360 500 600 600]);

%Creates slider whose length is determined by ti/tf and whose step is
%determined by n
slider =uicontrol('style','slider','position',[150 60 300 20],...
    'min',0,...
    'max',length(M_cells),...
    'SliderStep', [ (1/n) (2/n)],...
    'Value',ti,...
    'callback',@callbackfn);

%Writes text onto figure
text=uicontrol('style','text',...
    'position',[175 30 250 15],'visible','on');

%Creates Axes on which to plot
axes('units','pixels','position',[90 125 450 450]);

%Centers GUI on screen
movegui(f,'center');

%Determine size of the squares which mark the cells
marksize = 4.5;

%Allows Figure to be seen
set(f,'visible','on');

%initializes TS value sets timestamps based on slider value
timestamp= ti;

if ti == 0
    timestamp = timestamp+1;
end

%Displays which timestamp is being used
set(text,'String',strcat('Now Displaying #',num2str(timestamp),' at time: 0 minutes'));

MaxValue = 0;

%If plotting M Matrix
if PSIIndex ==0

    %Change value of grid to corresponding value in Matrix M.
    imagesc(M_cells{timestamp});
    
    for i = 1:length(M_cells)
        
        ColMaxes= max(M_cells{i});
        
        if max(ColMaxes) > MaxValue
            MaxValue = max(ColMaxes);
        end
    end

else

    %Change value of grid at each timestamp to corresponding value in matrix PSI
    for CellNum = 1:numofcells
        cellGRID{timestamp}(Psi_cells{timestamp}(1,CellNum),Psi_cells{timestamp}(2,CellNum)) = Psi_cells{timestamp}(PSIIndex,CellNum);
    end
    imagesc(cellGRID{timestamp});
    
    for i = 1:length(Psi_cells)
        
        ColMaxes= max(Psi_cells{i}(PSIIndex,:));
        
        if ColMaxes > MaxValue
            MaxValue = max(ColMaxes);
        end
    end

end


%Styling
axis image;
colormap default;
colorbar;
if MaxValue == 0
    caxis([0 1]);
else
    caxis([0 MaxValue*1.1]);
end

hold on;

%Plots Cells onto display
% for Cellcounter = 1:numofcells
%     plot(Psi_cells{timestamp}(1,Cellcounter),Psi_cells{timestamp}(2,Cellcounter), '-s',...
%         'MarkerSize',marksize,...
%         'MarkerEdgeColor','r');
% end

%functions which runs after every change in slider value
    function callbackfn(source,eventdata)
        
        %Sets timestamps based on slider value
        timestamp=round(get(slider,'value'));
        
        if timestamp == 0
            timestamp = timestamp+1;
        end
        
        %Displays which timestamp is being used
        set(text,'String',strcat('Now Displaying Frame #',num2str(timestamp),' at time: ',num2str((timestamp/length(M_cells)*tf)),' minutes.'));
              
        %If plotting M Matrix
        if PSIIndex ==0
            
            %Change value of grid to corresponding value in Matrix M.
            imagesc(M_cells{timestamp});            
       
        else
            
            %Change value of grid at each timestamp to corresponding value in matrix PSI
            for CellNum = 1:numofcells
                cellGRID{timestamp}(Psi_cells{timestamp}(1,CellNum),Psi_cells{timestamp}(2,CellNum)) = Psi_cells{timestamp}(PSIIndex,CellNum);
            end
            imagesc(cellGRID{timestamp});
            
        end        
        %Plots Cells onto display
%         for Cellcounter = 1:numofcells
%             plot(Psi_cells{timestamp}(1,Cellcounter),Psi_cells{timestamp}(2,Cellcounter), '-s',...
%                 'MarkerSize',marksize,...
%                 'MarkerEdgeColor','r');
%         end
        
    end

end