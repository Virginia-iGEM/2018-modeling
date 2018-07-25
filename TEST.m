clc
clear
close all

N = 10;
M = 12;

GRID = zeros(N,M);

Size =size(GRID);

i = 2;
j= 5;
GRID(i,j) = 5;

figure(1);
imagesc(GRID);
axis image;

colormap winter;
colorbar;