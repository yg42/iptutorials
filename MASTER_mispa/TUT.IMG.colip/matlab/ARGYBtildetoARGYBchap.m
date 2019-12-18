function ARGYBchap = ARGYBtildetoARGYBchap(ARGYBtilde)
% conversion vers l'espace chapeau en prenant la valeur absolue LIP
% cette conversion passe dans l'espace tilde pour réaliser une opération
% classique de valeur absolue
% valeur Max: maximale LIP
Max = getColipM0();

ARGYBchap(:,:,1) = invphi(ARGYBtilde(:,:,1), Max);

for c=2:3
    tmp =  abs(ARGYBtilde(:,:,c));
    
    ARGYBchap(:,:,c) = sign(ARGYBtilde(:,:,c)) .* invphi(tmp, Max);
end

end