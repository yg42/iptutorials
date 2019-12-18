function d=codediff(fcc,conn)
% fcc : freeman chain code
% conn: connectivity
sr=circshift(fcc, 1);
d=fcc-sr;
d = mod(d, conn);
