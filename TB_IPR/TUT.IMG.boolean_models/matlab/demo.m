%% CORRECTION TUTORIAL "Boolean Models"

%% 0 - Cleaning

clear;
close all;
clc;

%% 1 - Simulation of a Boolean model of disks (discrete case)

% parameters
Wsize = [500 500];
Gamma = 100/Wsize(1)/Wsize(2);
RadiusParam = [10 30]; % uniform law between 20 and 50
% generation
Z = BooleanModel(Wsize,Gamma,RadiusParam);
% visualization
imshow(Z);

%% 2 - Geometrical characterization of a Boolean model

% use of the Tutorial "Integral Geometry"
% computation of the Minkowski densities on different realizations
nbRealizations = 100;
W = zeros(nbRealizations,3);
areaWsize = Wsize(1)*Wsize(2);
for i = 1:nbRealizations
    [Z] = BooleanModel(Wsize,Gamma,RadiusParam);
    [area, per, ~, chi8] = MinkowskiFunctionals(Z);
    W(i,:) = [area, per/2, chi8*pi]/areaWsize;
end

% mean densisties (estimated)
W = mean(W,1);

% mean densities (theoretical) by using Miles formulas
rMean = mean(RadiusParam);
AreaMean = pi*rMean^2;
PerMean = 2*pi*rMean;
W_X = Gamma * [AreaMean,PerMean/2,pi];
W_th(1) = 1 - exp(-W_X(1));
W_th(2) = exp(-W_X(1)) * W_X(2);
W_th(3) = exp(-W_X(1)) * (W_X(3)-W_X(2)^2);

% comparison
error_W0 = abs(W(1)-W_th(1))/W_th(1)
error_W1 = abs(W(2)-W_th(2))/W_th(2)
error_W2 = abs(W(3)-W_th(3))/W_th(3)

