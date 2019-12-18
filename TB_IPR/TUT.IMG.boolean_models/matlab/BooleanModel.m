function Z = BooleanModel(Wsize,Gamma,RadiusParam)
% Generates a boolean model of disks in 2D
% The number of disks is chosen according to a Poisson law of parameter
% lambda = Gamma*areaW, where areaW is the area of the window defined by
% Wsize.
%
% Parameters:
% Wsize: size of the window (2x1 array)
% Gamma: Parameter to get the density for the Poisson law
% RadiusParam: [min, max] valus of radii
% returns: boolean array of size Wsize(1)xWsize(2)


edgeEffect = 2*max(RadiusParam)+100;
WsizeExtended = [Wsize(1)+2*edgeEffect,Wsize(2)+2*edgeEffect];
% nb of points
nf = WsizeExtended(1);
nc = WsizeExtended(2);
areaW = nf*nc;
nbPoints = poissrnd(Gamma*areaW);
% germs
x = randi(nf, nbPoints);
y = randi(nc, nbPoints); 
% grains
r = randi(RadiusParam, nbPoints);
Z = false(nf,nc);

% union of grains
[X, Y] = meshgrid(1:nf, 1:nc);
for i = 1:nbPoints
    Z = Z | ((X-x(i)).^2+(Y-y(i)).^2)<= r(i)^2;
end
Z = Z(edgeEffect+1:edgeEffect+Wsize(1),edgeEffect+1:edgeEffect+Wsize(2));
