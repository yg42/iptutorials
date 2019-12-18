% function single step wavelet decomposition
function [A, D]=waveSingleDec(signal, ld, hd)
% 1D wavelet decomposition into
% A: approximation vector
% D: detail vector
% ld: low pass filter
% hd: high pass filter

% convolution
A = conv(signal, ld, 'same');
D = conv(signal, hd, 'same');

% subsampling
A = A(1:2:end);
D = D(1:2:end);

