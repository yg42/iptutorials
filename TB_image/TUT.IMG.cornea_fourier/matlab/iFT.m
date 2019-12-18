% Inverse Fourier transform utility of spectrum S
function I=iFT(S)
I=real(ifft2(fftshift(S)));