%% Random chord generation on a sphere
figure
N = 1e7; % number of points
R = 1; % radius of the sphere
nBins = 1000;

radii = 0:R/nBins:R*(1-1/nBins);

%% first simulation: equivalent to a disk
x = R*rand(N, 1);
r = sqrt(R^2 - x.^2);
proba2 = histcounts(r(r<=R), nBins, 'normalization', 'probability');
hold on
plot(radii, proba2, 'r');

%% second simulation
% choose 3 points to define a plane
% then, compute the distance from origin to this plane
n1 = randn(N,3);
mynorm = sqrt(sum(n1.^2,2));
n1 = R* n1 ./ repmat(mynorm,1,3);

n2 = randn(N,3);
mynorm = sqrt(sum(n2.^2,2));
n2 = R* n2 ./ repmat(mynorm,1,3);

n3 = randn(N,3);
mynorm = sqrt(sum(n3.^2,2));
n3 = R* n3 ./ repmat(mynorm,1,3);

% u and v are two points on the plane
u=n2-n1;
v=n3-n1;
% n: normal vector to the plane
n = cross(u,v);
x = dot(n, n1, 2) ./ sqrt(sum(n.^2, 2));

r = sqrt(R^2 - x.^2);

proba = histcounts(r, nBins, 'normalization', 'probability');
plot(radii, proba, 'b');

%% third simulation
% 2 points on the sphere and distance between them
n1 = randn(N,3);
mynorm = sqrt(sum(n1.^2,2));
n1 = R* n1 ./ repmat(mynorm,1,3);

n2 = randn(N,3);
mynorm = sqrt(sum(n2.^2,2));
n2 = R* n2 ./ repmat(mynorm,1,3);

r = sqrt(sum((n1-n2).^2, 2))/2;
proba = histcounts(r, nBins, 'normalization', 'probability');
plot(radii, proba, 'g');

%% analytical values
step = 0.05;
r2 = 0:step:R;
p = 1/R* r2./sqrt(R^2 - r2.^2);
p = p * R/nBins;

plot(r2,p,'ko', 'linewidth', 3);

legend({'First case: random radius', 'Second case: 3 pts defining a plane', 'Third Case: dist between 2 pts', 'Analytical value'})
