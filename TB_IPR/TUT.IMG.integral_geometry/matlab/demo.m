%% cleaning
clc; clear all; close all;

%% reading image
% X = [0 0 0 0 0 0 0 0 0 0 0 0;...
%      0 0 1 1 1 0 0 1 0 0 1 0;...
%      0 1 1 0 1 0 1 0 1 0 0 0;...
%      0 1 0 1 1 0 0 1 0 1 0 0;...
%      0 1 1 1 0 1 0 1 1 0 0 0;...
%      0 1 1 0 1 0 0 0 1 0 1 0;...
%      0 0 0 0 0 0 1 0 0 0 1 0;...
%      0 0 1 0 0 0 1 0 0 1 1 0;...
%      0 0 0 1 1 1 1 1 0 1 1 0;...
%      0 1 0 1 1 0 1 0 0 0 1 0;...
%      0 0 1 1 1 1 1 0 0 1 0 0;...
%      0 0 0 0 0 0 0 0 0 0 0 0];
%  
%  imwrite(logical(X),'X.bmp');
 
X = imread('X.bmp');
imagesc(X);
axis off;
axis square;
colormap gray;

%% Number of faces, edges and vertices
% manual counting!
f_intra = 50;
e_intra = 158;
v_intra = 107;

f_inter = 4;
e_inter = 42;
v_inter = 50;

Area = f_intra
Perimeter = -4*f_intra + 2*e_intra
EulerNb8 = v_intra - e_intra + f_intra
EulerNb4 = v_inter - e_inter + f_inter

%% Computation of the functionals
[Area, Perimeter, EulerNb4, EulerNb8] = minkowski_functionals(X);

%% Crofton perimeter
F = [0 0 0; 0 1 4; 0 2 8];
X = padarray(X, [1,1]); % ensures no pixel touches the border
XF = conv2(double(X),F,'same');
h = hist(XF(:),16);
bar(0:15,h);
P4 = [0 pi/2 0 0 0 pi/2 0 0 pi/2 pi 0 0 pi/2 pi 0 0];
Perimeter4 = sum(h.*P4)
P8 = [0 pi/4*(1+1/(sqrt(2))) pi/(4*sqrt(2)) pi/(2*sqrt(2)) 0 pi/4*(1+1/(sqrt(2))) 0 pi/(4*sqrt(2)) pi/4 pi/2 pi/(4*sqrt(2)) pi/(4*sqrt(2)) pi/4 pi/2 0 0];
Perimeter8 = sum(h.*P8)
 