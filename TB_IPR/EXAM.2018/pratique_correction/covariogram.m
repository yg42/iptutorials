function [error]=covariogram( R , standalone)
% covariogram
% R: radius of disk
% standalone: true if results are displayed in figures,
%             false if called several times to evaluate error

step = .01;
% sample the spatial support
x = -4*R:step:4*R;

[X, Y] = meshgrid(x, x);

% draw first disk
D = (X.^2 +Y.^2) <= R^2;

% normalization is the area of a disk of radius 1
% with a given sample step
D1 = (X.^2 +Y.^2) <= 1;
A0 = bwarea(D1);

% perform covariogram
% notice that only direction on x is required
U = 0:step:2*R; % vector of displacements
c = zeros(length(U), 1);
for i=1:length(U)
    D2 = ((X-U(i)).^2 + Y.^2) <= R^2;
    C = D & D2;
    %imshow(C);
    c(i) =  pi*bwarea(C)/A0;
end

% analytical value
ct = 2*R^2*acos(U/(2*R)) - U.*sqrt(4*R^2-U.^2)/2;
if standalone
    figure
    hold on
    plot(U, ct); %label('analytical value')
    plot(U, c); title('Covariogram')
    legend({'analytical value' 'simulation'});
end
error = mean( (ct-c').^2 );
end


