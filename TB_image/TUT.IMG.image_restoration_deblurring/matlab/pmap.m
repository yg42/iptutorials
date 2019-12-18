% Lucy Richardson algorithm
function fr = pmap(g, psf, n_iter)
% Poisson Maximum A Posteriori
%
% g: image to restore. initial value of fr is g
% psf: point spread function
% n_iter: number of iterations
% 
H = psf2otf(psf, size(g));

fr = g;

for iter=0:n_iter
    % estimated blurred image
    estimation = max(0,real(ifft2(H.*fft2(fr))));
    
    M = real(ifft2(conj(H) .* fft2(g./estimation)));
    fr = fr.* exp(M-1);
end
