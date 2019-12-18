function all_deconvolutions( g, psf, N, filename)
% Test several deconvolution algorithms for image g produced by psf 
% and noise N
%
% g: damaged image
% psf: point spread function
% N: noise
% filename: if present, use it to store all the results in images via the
%           'sauvegarde' function

if nargin == 4
    backup = 1;
else
    backup = 0;
end

%% first computations
figure
subplot(241)
imagesc(g); axis equal
title('original')
if backup
    sauvegarde(g, ['original_' filename '.png']);
end

% Fourier transform of the psf
H = psf2otf(psf, size(g));

%% Wiener
% power spectrum
Pf = mean(mean(abs(fft2(g)).^2));
Pn = mean(mean(abs(fft2(N)).^2));

g_autocorr = (abs(fft2(g)).^2);
n_autocorr = (abs(fft2(N)).^2);
% Wiener with constant ratio
ratio = Pn/Pf;
%ratio=.2;
% remember that conj(H).*H = abs(H).^2
Hw = conj(H)./(abs(H).^2+ratio);
fr = ifft2( Hw .* fft2(g));

subplot(242);
imagesc(fr); axis equal
title('Wiener')
if backup
    sauvegarde(fr, ['wiener_' filename '.png']);
end

% matlab method
subplot(248);
imagesc(deconvwnr(g, psf, .1));%, n_autocorr, g_autocorr))
axis equal
title('deconvwnr')

%% Richardson-Lucy
niter = 100;
subplot(243)
frla = rla(g, psf, niter);
imagesc(frla)
axis equal
title('RLA')
if backup
    sauvegarde(frla, ['rla_' filename '.png']);
end

%% Matlab deconvlucy
subplot(244)
frdl=deconvlucy(g, psf, niter);
imagesc(frdl);
axis equal
title('deconvlucy')
if backup
    sauvegarde(frdl, ['deconvlucy_' filename '.png']);
end
%% VanCittert
subplot(245)
frvca = vca(g, psf, niter);
imagesc(frvca);
axis equal
title('VanCittert')
if backup
    sauvegarde(frvca, ['vca_' filename '.png']);
end
%% Landweber
subplot(246)
frlva=lva(g, psf, niter);
imagesc(frlva);
axis equal
title('Landweber')
if backup
    sauvegarde(frlva, ['lva_' filename '.png']);
end
%% Poisson MAP
subplot(247)
frpmap=pmap(g, psf, niter);
imagesc(frpmap);
axis equal
title('Point MAP')
if backup
    sauvegarde(frpmap, ['pmap_' filename '.png']);
end

    % save image function
    function sauvegarde(image, name)
        I = imadjust(image/max(image(:)));
        imwrite(I, name);
    end
end

