%% Active contours
close all
tic

%% generate image with binary circle
n = 1024;
R  =300;
[X, Y] = meshgrid(-n/2:n/2-1, -n/2:n/2-1);
I = double(X.^2+Y.^2 >= R^2);
%imwrite(I, 'circle.png');

clear X,Y; % clear unused variables

%% intialize snake with an ellipse
x = n/2 + 400 * cos(0:.01:2*pi);
y = n/2 + 200 * sin(0:.01:2*pi);
x = x';
y = y';

%plot([x;x(1)], [y;y(1)], 'r', 'linewidth', 3);

%% parameters
k=1e-1;
alpha = .0001*k;
beta  = 50*k;
gamma = 200;
iterations = 500;

%% construct of iteration matrix for internal forces
N = length(x);
X = [-beta alpha+4*beta -2*alpha-6*beta alpha+4*beta -beta -beta alpha+4*beta -beta alpha+4*beta];
B = repmat(X, N, 1);
A = full(spdiags(B, [-2 -1 0 1 2 N-2 N-1 -N+2 -N+1], N, N));

AA = eye(N) - gamma*A;
invAA = inv(AA);

%% external forces
% define convolution kernels
hgauss = fspecial('gaussian', 100, 30);
hprewitt  = fspecial('prewitt');

% gaussian filter
G = imfilter(I, hgauss, 'replicate');
% gradient (prewitt) and its norm
Fy= imfilter(G, hprewitt, 'symmetric');
Fx= imfilter(G, hprewitt', 'symmetric');
G = sqrt(Fx.^2+Fy.^2);

% orientation of previous gradient
Fy= imfilter(-G, hprewitt, 'symmetric');
Fx= imfilter(-G, hprewitt', 'symmetric');

%% display results
imshow(I,[])
hold on
plot([x;x(1)], [y; y(1)], 'g', 'linewidth', 3);

%% display arrows for external forces
step=20;
subx = 1:step:size(I,1);
suby = 1:step:size(I,2);
[Xa, Ya] = meshgrid(subx, suby);
quiver(Xa, Ya, Fx(subx, suby), Fy(subx,suby));

%% algorithm
h = waitbar(0, 'snake converging...');
% iterations
for index = 1:iterations,
    % interpolate values of forces
    fex = interp2(Fx, x, y, 'linear');
    fey = interp2(Fy, x, y, 'linear');
    
    x = invAA*(x+gamma*fex);
    y = invAA*(y+gamma*fey);
    % display snake every 10 iterations
    if mod(index,10)==0
        plot([x;x(1)], [y;y(1)], 'b');
    end
    waitbar(index/iterations);
end
toc
plot([x;x(1)], [y;y(1)], 'r', 'linewidth', 3);
close(h)
