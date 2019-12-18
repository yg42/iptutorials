function [coeff, x, y]=besicovitch(I)
% Fonction qui calcule le coefficient de Besicovitch d'antysymetrie
%
% coeff: valeur du coefficient
%        ce coefficient est compris entre 0  (le plus symetrique)
%        et 1/3 (pour la figure la moins symetrique, un triangle)
%
% Dans le systeme de coordonnees de I:
% x: abscisse du point de symetrie
% y: ordonnee du point de symetrie

% Calcul de la correlation entre l'image I et son symetrique
I = I>0;
I2=I(end:-1:1, end:-1:1);
C = xcorr2(double(I), double(I2));

% Detection du maximum
[valeurs indices] = max(C);
[coeff y] = max(valeurs);
x= indices(y);

% On divise par 2 pour avoir les coordonnees dans le repere de l'image
% d'origine
y=y/2;
x=x/2;

% normalisation du coefficient
coeff = 1 - coeff/sum(I(:));

% Affichage du point de symetrie de Besicovitch
imshow(I, []);
hold on
plot(y, x, 'ro');