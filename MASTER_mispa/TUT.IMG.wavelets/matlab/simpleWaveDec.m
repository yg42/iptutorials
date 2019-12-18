function C = simpleWaveDec(signal, nb_scales)
% wavelet decomposition of <signal> into <nb_scales> scales
% This function uses Haar wavelets for demonstration purposes.

% Haar Wavelets filters for decomposition and reconstruction
ld = [1 1];
hd = [-1 1];

% transformation
C=cell(nb_scales+1, 1);
A = signal; % approximation
for i=1:nb_scales
    [A, D] = waveSingleDec(A, ld, hd);
    % get the coefficients
    C{i}=D;
end
C{nb_scales+1}=A;