function ARGYBtilde = LMStoARGYBtilde(LMS)
% conversion de l'espace LMS vers l'espace ARGYBtilde.
% LMS: matrice de taille, MxNx3. Les valeurs vont de 0 (exclus) à 100=M0


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maximal values definition
M0 = getColipM0();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n,~] = size(LMS); % image size

% conversion to (L~,M~,S~): applying LIP isomorphism
%warning('attention au epsilon pour le passage en tons lms')
LMSton = lmstone(LMS);
LMStilde = phi(LMSton, M0);

% conversion to antagonist color space (a~,rg~,yb~)
P = [40/61,20/61,1/61;1,-12/11,1/11;1/9,1/9,-2/9 ]; % antagonist matrix
LMStilde = reshape(LMStilde,[m*n,3]);
LMStilde = LMStilde';
ARGYBtilde = P*LMStilde;
ARGYBtilde = ARGYBtilde';
ARGYBtilde = reshape(ARGYBtilde,[m,n,3]);
