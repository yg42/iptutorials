function [ fr ] = vca( g, psf, n_iter)
% Van Cittert iteration algorithm
% for deconvolution
%
% g: degraded image
% psf: point spread function
% n_iter: number of iterations

H = psf2otf(psf, size(g));

fr=g;

beta = .1;
for iter = 1:n_iter
    fr = fr + beta*(g -ifft2(H .* fft2(fr)));
end

end

