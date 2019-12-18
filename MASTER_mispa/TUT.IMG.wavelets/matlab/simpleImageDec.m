function C = simpleImageDec(image, nb_scales)
% wavelet decomposition of <image> into <nb_scales> scales
% This function uses Haar wavelets for demonstration purposes.

% Haar Wavelets filters for decomposition and reconstruction
ld = [1 1];
hd = [-1 1];

% transformation
C=cell(nb_scales+1, 1);
A = image; % approximation

coeffs = cell(3,1);
for i=1:nb_scales
    [A, HcLrA, LcHrA, HcHrA] = decWave2D(A, ld, hd);
    coeffs{1} = HcLrA;
    coeffs{2} = LcHrA;
    coeffs{3} = HcHrA;
    % set the coefficients
    C{i}=coeffs;
end
C{nb_scales+1} = A;