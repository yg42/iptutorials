%% CORRECTION TUTORIAL "Boolean Models"

%% 0 - Cleaning

clear all;
close all;
clc;

%% 1 - Simulation of a Boolean model

% parameters
Wsize = [500 500];
Gamma = 100/Wsize(1)/Wsize(2);
WidthLaw = [30 10]; 
LengthLaw = [50 20];

% generation
warning off;
[BM] = BMgenerationRectangle(Wsize,Gamma,WidthLaw,LengthLaw);

% visualization
BMshow(BM.Polygons);
axis off
axis([0 500 0 500]);

%% 2 - Geometrical characterization of a Boolean model

% computation of the Minkowski densities on different realizations
nbRealizations = 20;
W = zeros(nbRealizations,3);

for i=1:nbRealizations
    [BM] = BMgenerationRectangle(Wsize,Gamma,WidthLaw,LengthLaw);
    [area, per, chi] = BMminkowskiDensities(BM.Polygons,Wsize);
    W(i,:) = [area, per/2, chi*pi];
    clear area per chi;
end

% mean densisties
W = mean(W,1);

% inversion of the Miles formulas
Gamma_num = 1/pi * (W(3)/(1-W(1)) + W(2)^2/((1-W(1))^2) );
Area_num = 1/Gamma_num * (-log(1-W(1)));
Per_num = 1/Gamma_num * ( W(2)/(1-W(1)) );

% theoretical values
Area = WidthLaw(1)*LengthLaw(1);
Per = (WidthLaw(1)+LengthLaw(1));

% comparison
error_Gamma = abs(Gamma_num-Gamma)/Gamma
error_Area = abs(Area_num-Area)/Area
error_Per = abs(Per-Per_num)/Per