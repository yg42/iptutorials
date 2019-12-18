function [x,y]=semi_NS(nRoot, xmin, xmax, ymin, ymax, lambdaS, rSon)
% Neyman-Scott process simulation
% i.e. aggregate of processes
% nRoot   : number of agregates
% lambdaS : number of points, lambda is a density, S is the spatial support
%          area
% rSon    : radius around agregate (points are distributed in a square)
 

% should generate the number of sons per each root point
n = poissrnd(lambdaS, nRoot, 1);

% Allocation of memory
nb = sum(n(:));
% final random points for the process
x=zeros(nb,1);
y=zeros(nb,1);

xp = xmin+randi(xmax-xmin, nRoot, 1); % root points
yp = ymin+randi(ymax-ymin, nRoot, 1);

dx=randi(2*rSon, nb, 1)-rSon;
dy=randi(2*rSon, nb, 1)-rSon;

indice=1;
% loop over all agregates
for i=1:nRoot
    
    for j=1:n(i)
        
        x(indice)=xp(i)+dx(indice);
        y(indice)=yp(i)+dy(indice);
        indice = indice + 1;
    end
end