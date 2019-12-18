%% random chord generations on a disk (2D)
N = 1e7; % nb of points
nBins = 1000; % histogram
R = 1; % radius of the disk

% Note on the random uniform generation
% rand generates number between ]0;1[ (open interval)
% this should not be a problem in this simulation


%% 1st method: random radius
% take a random (uniform law) number between 0 and R and compute the
% half length of the cord
d=R * rand(N, 1);
radii = sqrt(R^2 - d.^2);
probaSimu = histcounts(radii, nBins, 'normalization', 'probability');

%% 2nd method: random endpoints
% take 2 points A and B uniformly on the disk (from an angle), 
% compute their half length
thetas = 2*pi * rand(N,2);

dX = diff(R * cos(thetas),1,2);
dY = diff(R * sin(thetas),1,2);
radii = 1/2 * sqrt(dX.^2 + dY.^2);
probaSimu2 = histcounts(radii, nBins, 'normalization', 'probability');
%pdfSimu2 = pdfSimu2 / N ;

%% 3: analytical value
step = 0.1;
r2 = 0:step:R;
p = 1/R* r2./sqrt(R^2 - r2.^2);
p = p * R/nBins; % approximate the integral

%% 4: 2 random points
% take 2 random points by another method.
% this is equivalent to previous method
% n1 = randn(N,2);
% mynorm = sqrt(sum(n1.^2,2));
% n1 = R* n1 ./ repmat(mynorm,1,2);
% 
% n2 = randn(N,2);
% mynorm = sqrt(sum(n2.^2,2));
% n2 = R* n2 ./ repmat(mynorm,1,2);
% 
% radii = 1/2 * sqrt(sum((n2-n1).^2, 2));
% probaSimu3 = histcounts(radii, nBins, 'normalization', 'probability');

%% plot
figure; hold on
r = 0:R/nBins:R*(1-1/nBins);
plot(r, probaSimu, 'r', 'linewidth', 2);
plot(r2,p,'ko', 'linewidth', 3);
plot(r, probaSimu2, 'b', 'linewidth', 2);
%plot(r, probaSimu3, 'g', 'linewidth', 2);
legend({'random radius' 'Analytical values' 'random endpoints' 'rand endpoints 2'});

%matlab2tikz('disk.tikz')
