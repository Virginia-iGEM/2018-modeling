%Slider Test
function [x] = TEST(M,M_cells,Psi,Psi_cells,PSIIndex,ti,tf,dt)
close all;
f = figure('visible','off','position',...
    [360 500 600 600]);

slider =uicontrol('style','slider','position',[160 60 300 20],...
    'min',ti,...
    'max',tf,...
    'SliderStep', [ (dt/tf) (dt*2/tf)],...
    'Value',1,...
    'callback',@callbackfn);

hsttext=uicontrol('style','text',...
    'position',[170 340 40 15],'visible','off');

axes('units','pixels','position',[90 125 450 450]);

movegui(f,'center');

set(f,'visible','on');
    function callbackfn(source,eventdata)
        num=get(slider,'value');
        visual = imread(strcat('Matrix_at_TS_',num2str(num),'.png')); %%%Make for Cell_at_TS too
        visual = imresize(visual, [450 450]);
        imshow(visual);
%         imagesc(GRID{num});
%         axis image;
%         colormap winter;
%         colorbar;
%         hold on;
    end
end