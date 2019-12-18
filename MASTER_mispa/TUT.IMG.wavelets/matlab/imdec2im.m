function A = imdec2im(LcLrA, lvlC)
% constructs a single image from:
% LcLrA: the approximation image
% lvlC: the wavelet decomposition at one level
%
% for display purposes

HcLrA=lvlC{1};
LcHrA=lvlC{2};
HcHrA=lvlC{3};
[n, m] = size(HcLrA);

A = zeros(2*n, 2*m);

% approximation image can be with high values when using Haar coefficients
A(1:n, 1:m) =LcLrA/ max(LcLrA(:));

% details are low, and can be negative
A(1:n, m+1:2*m) = imadjust(HcLrA, stretchlim(HcLrA), [0 1]);
A(n+1:2*n, 1:m) = imadjust(LcHrA, stretchlim(LcHrA), [0 1]);
A(n+1:2*n, m+1:2*m) = imadjust(HcHrA, stretchlim(HcHrA), [0 1]);

imshow(A)