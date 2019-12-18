%% white noise simulation
close all
n = 128;
W = randn(n);
imagesc(W);

imwrite_rf(W, 'wn.png');

%% Gaussian random field
% Discretization grid
N = 1024;
N = 2^nextpow2(N); % force power of two
[Y, X] = meshgrid(-N/2:N/2-1, -N/2:N/2-1);

% Gaussian covariance function in 2D
sigma = 10;
a = 2;
Cmat = exp(-(sqrt((X./(sqrt(2)*sigma)).^2+(Y./(sqrt(2)*sigma)).^2)).^(a)./2);
figure()
h=surf(Cmat);
set(h, 'edgecolor','none')

% Fourier domain
% gaussian complex white noise
W=randn(N);

% covariance matrix in the Fourier domain
Cf = real(fft2(Cmat));

Cf = sqrt(max(zeros(size(Cf)), Cf)); 

% phi_hat is the fourier transform of the gaussian random field
phi_hat = Cf.*fft2(W);

% we take the real part (should be real, but due to numerical
% approximations...)
G = real(ifft2(phi_hat));


% verify statistical properties
m = mean(G(:));
s = std(G(:));

figure()
imagesc(G);
imwrite_rf(G, 'grf.png');

%% compute the minkowski functionals
hmin = min(G(:));
hmax = max(G(:));
H = hmin:.1:hmax;


% Area, Perimeter and Euler number
A = zeros(length(H), 1);
P = zeros(length(H), 1);
E = zeros(length(H), 1);

% analytical values
rho_0 = zeros(length(H), 1);
rho_1 = zeros(length(H), 1);
rho_2= zeros(length(H), 1);

lambda = 1/(2*sigma^2);

% for all threshold values (level sets)
for i = 1:length(H)
    levelSet = G>=H(i);
    A(i) = bwarea(levelSet);
    P(i) = bwarea(bwperim(levelSet,4));
    E(i) = bweuler(levelSet,4);
    
%     % analytic
%     rho_0(i) =  1/2*erfc(H(i)/sqrt(2));
%     rho_1(i) = sqrt(lambda)*exp(-H(i)^2/2)/(2*pi); 
%     rho_2(i) = lambda /(2*pi)^(3/2) * exp(-(H(i)^2)/2)*H(i);
end
rho_0 =  1/2*erfc(H/sqrt(2));
rho_1 = sqrt(lambda)*exp(-H.^2/2)/(2*pi); 
rho_2 = lambda /(2*pi)^(3/2) * exp(-(H.^2)/2).*H;
Aa = N^2*rho_0;
Pa = 4*N*rho_0 + pi*N^2*rho_1;
Ea = 1*rho_0 + 2*N*rho_1 + N^2*rho_2;


figure;
subplot(131);plot(H, A); hold on; plot(H, Aa, 'r'); title('Area');
subplot(132);plot(H, P); hold on; plot(H, Pa, 'r'); title('Perimeter');
subplot(133);plot(H, E); hold on; plot(H, Ea, 'r'); title('Euler number');

%figure;
%plot((Pa-P)/P)
