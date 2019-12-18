function A = simpleWaveRec(C)
% wavelet simple reconstruction function of a 1D signal
% C: Wavelet coefficients 
%
% The Haar wavelet is used
ld = [1 1];
hd = [-1 1];
lr = ld/2;
hr = -hd/2;

nb_scales = length(C)-1;
A = C{nb_scales+1};
for i=nb_scales:-1:1
    A = waveSingleRec(A, C{i}, lr, hr);
end
