function [ fr ] = lva2( g, psf, n_iter)
% Landweber iteration algorithm
% for deconvolution
%
% g: degraded image
% psf: point spread function
% n_iter: number of iterations

H = psf2otf(psf, size(g));
Hc=conj(H);
G = fft2(g);
alpha = 1;
A = eye(length(size(H,1))) - ifft2(alpha * Hc .* H);
C = alpha * Hc .* G;
FR = G;
for iter = 1:n_iter
    FR = A.*FR + C;
end

fr = ifft2(FR);
end
