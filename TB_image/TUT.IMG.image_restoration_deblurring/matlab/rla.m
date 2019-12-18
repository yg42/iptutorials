% Lucy Richardson algorithm
function fr = rla(g, psf, n_iter)
% Richardson-Lucy algorithm for deconvolution
%
% g: image to restore. initial value of fr is g
% psf: point spread function
% n_iter: number of iterations

H = psf2otf(psf, size(g));
fr = g;

for iter=0:n_iter
    % estimated blurred image
    estimation = ifft2(H.*fft2(fr));
    
    M = ifft2(conj(H) .* fft2(g./estimation));
    fr = max(0,fr.* M);
end

% %methode par convolution directe
% fpsf = flip(flip(psf, 2), 1);
% 
% fr=g;
% for iter = 1:n_iter
%     yk = conv2(fr, psf, 'same');
%     
%     fr = fr .* conv2(g./yk, fpsf, 'same');
% end
