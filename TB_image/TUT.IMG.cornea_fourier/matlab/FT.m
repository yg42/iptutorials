% Fourier transform utility of image I
function S=FT(I)
S=fftshift(fft2(double(I)));

