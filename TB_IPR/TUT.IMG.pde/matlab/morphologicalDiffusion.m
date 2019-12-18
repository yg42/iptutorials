function [Zerosion,Zdilation] = morphologicalDiffusion(I,nbIter,dt)

hW = [1 -1 0];
hE = [0 -1 1];
hN = hW';
hS = hE';

Zerosion  = I;
Zdilation = I;

for i=1:nbIter
    % calculate gradient in all directions (N,S,E,W)
    gW = imfilter(Zdilation,hW);
    gE = imfilter(Zdilation,hE);
    gN = imfilter(Zdilation,hN);
    gS = imfilter(Zdilation,hS);
    
    jW = imfilter(Zerosion,hW);
    jE = imfilter(Zerosion,hE);
    jN = imfilter(Zerosion,hN);
    jS = imfilter(Zerosion,hS);
    
    % next Image
    g = sqrt( min(0,-gW).^2 + max(0,gE).^2 + min(0,-gN).^2 + max(0,gS).^2 );
    j = sqrt( max(0,-jW).^2 + min(0,jE).^2 + max(0,-jN).^2 + min(0,jS).^2 );
    Zdilation = Zdilation + dt * g;
    Zerosion  = Zerosion - dt * j;

end


