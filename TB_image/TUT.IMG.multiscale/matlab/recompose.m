function B=recompose(A,R,seuil)
B=imresize(A,2,'nearest'); % sur-échantillonnage
Rseuil = R.*(abs(R)<=seuil); % seuillage
B=B+Rseuil;