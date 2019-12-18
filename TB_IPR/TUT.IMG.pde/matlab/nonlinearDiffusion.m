function Z = nonlinearDiffusion(I,nbIter,dt,alpha)

hW = [1 -1 0];
hE = [0 -1 1];
hN = hW';
hS = hE';

Z = I;

for i=1:nbIter
    % calculate gradient in all directions (N,S,E,W)
    gW = imfilter(Z,hW);
    gE = imfilter(Z,hE);
    gN = imfilter(Z,hN);
    gS = imfilter(Z,hS);
    
    % next Image
    Z = Z + dt*(c(gN,alpha).*gN + c(gS,alpha).*gS + c(gW,alpha).*gW + c(gE,alpha).*gE);
end

end

function Z = c(I,alpha)

  Z = exp(-(abs(I)/alpha).^2);

end

