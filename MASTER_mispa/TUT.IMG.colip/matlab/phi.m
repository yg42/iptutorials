function x = phi(f, M0)
% isomorphisme LIP
% paramètres:
% f : fonction en niveaux de gris à utiliser
% M0: valeur maximale à utiliser

x = -M0*log(1-f/M0);