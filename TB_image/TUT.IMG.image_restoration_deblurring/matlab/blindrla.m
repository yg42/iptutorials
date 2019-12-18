% Blind Lucy Richardson algorithm
function fr = blindrla(g, psf, f0, n_iter)
% Blind Richardson-Lucy algorithm for deconvolution
%
% g: image to restore
% psf: point spread function
% f0: first guess
% n_iter: number of iterations

H = fft2(fftshift(psf));
Ht = fft2(fftshift(flip(flip(psf),2),1));

fr = f0;
for iter=1:n_iter
    % estimated blurred image
    yk = ifft2(H.*fft2(fr));
    
    
    M = ifft2(Ht .* fft2(g./yk));
    fr = fr.* M;
end