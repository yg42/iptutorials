%%%%%%%%%%%%%%%%%%%

N = 2^10;
N = 2^nextpow2(N); % force power of two
[Y, X] = meshgrid(-N/2+1:N/2, -N/2+1:N/2);

% covariance
sigma = 10;
Cmat = exp(-((X./sigma).^2+(Y./sigma).^2)./2);
figure()
h=surf(Cmat);
set(h, 'edgecolor','none')

% Fourier domain
% gaussian complex white noise
W1=randn(N);

% covariance matrix in the Fourier domain
Cf = sqrt(fft2(Cmat));

% phi_hat is the fourier transform of the gaussian random field
phi_hat = Cf.*fft2(W1);

% we take the real part (should be real, but due to numerical
% approximations...)
G = real(ifft2(phi_hat));

% verify statistical properties
m = mean(G(:));
s = std(G(:));

figure()
imagesc(G);

% bornes pour les seuils
hmin = min(G(:));
hmax = max(G(:));
H = hmin:.1:hmax;

% valeurs mesurées
A = zeros(length(H), 1);
P = zeros(length(H), 1);
E = zeros(length(H), 1);

% analytical values
Aa = zeros(length(H), 1);
Pa = zeros(length(H), 1);
Ea = zeros(length(H), 1);

lambda = 1/(sigma^2);

for i = 1:length(H)
    levelSet = G>=H(i);
    A(i) = bwarea(levelSet)/N^2;
    P(i) = bwarea(bwperim(levelSet,8))/(4*N);
    E(i) = bweuler(levelSet,8);

    % analytic
    Aa(i) =  1/2*erfc(H(i)/sqrt(2));
    Pa(i) = sqrt(lambda)*exp(-H(i)^2/2)/(2*pi);
    Ea(i) = lambda* exp(-(H(i)^2)/2)*H(i)/(2*pi)^(3/2);
end
per = Aa + N*Pa;
Ea = N^2*Ea + 4*N*Pa/2 + Aa;

figure;
subplot(131);plot(H, A); hold on; plot(H, Aa, 'r'); title('Area');
subplot(132);plot(H, P); hold on; plot(H, per, 'r'); title('Perimeter');
subplot(133);plot(H, E); hold on; plot(H, Ea, 'r'); title('Euler number');

figure;
plot((per-P)/P)
