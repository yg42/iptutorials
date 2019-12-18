function approx = waveSingleRec(a, d, lr, hr)
% 1D wavelet reconstruction at one scale
% a: vector of approximation
% d: vector of details
% lr: low pass filter defined by wavelet
% hr: high pass filter defined by wavelet
%
% This is Mallat algorithm.
% NB: to avoid side effects, the convolution function does not use the
% 'same' option

approx = zeros(1, length(a)*2);
approx(1:2:end) = a;
approx = conv(approx, lr);

detail = zeros(1, length(a)*2);
detail(1:2:end) = d;
detail = conv(detail, hr);

% sum up approximation and details to reconstruct signal at lower scale
approx = approx + detail;

% get rid of last value
approx = approx(1:length(a)*2)