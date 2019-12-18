function [x,y]=semi_alea(point_nb,xmin,xmax,ymin,ymax)
% Conditional Poisson Point process
% uniform distribution
% point_nb is the number of points
% xmin, xmax, ymin, ymax define the domain

x = xmin + (xmax-xmin)*rand(point_nb, 1);
y = ymin + (ymax-ymin)*rand(point_nb, 1);