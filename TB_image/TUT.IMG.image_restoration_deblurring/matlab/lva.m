function [ fr ] = lva( g, psf, n_iter)
% Landweber iteration algorithm
% for deconvolution
%
% g: degraded image
% psf: point spread function
% n_iter: number of iterations

H = psf2otf(psf, size(g));
G = fft2(g);

fr=g;
for iter = 1:n_iter
    fr = fr - ifft2(conj(H) .* (H.*fft2(fr) -G));
    fr(fr<0)=0;
end

end
