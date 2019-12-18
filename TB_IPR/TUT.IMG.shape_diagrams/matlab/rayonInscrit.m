function r=rayonInscrit(I)
% Calcul du rayon du cercle inscrit
dm = bwdist(~(I>0));
r=max(dm(:));