function [Zerosion,Zdilation] = morphologicalDiffusion2(I,nbIter,dt)
% naive implementation of the morphological filter, which presents numerical shocks
% I: original image
% nbIter: number of iterations
% dt: time increment
h = [-1 0 1];

Zerosion = I;
Zdilation = I;

for i=1:nbIter
    % calculate gradient in vertical V and horizontal H directions, for
    % dilation
    gH = imfilter(Zdilation, h);
    gV = imfilter(Zdilation, h');
    
    % same computation, for erosion
    jH = imfilter(Zerosion, h);
    jV = imfilter(Zerosion, h');
    
    % next step
    Zdilation  = Zdilation + dt * sqrt(gV.^2 +gH.^2);
    Zerosion = Zerosion - dt * sqrt(jV.^2 +jH.^2);

end
