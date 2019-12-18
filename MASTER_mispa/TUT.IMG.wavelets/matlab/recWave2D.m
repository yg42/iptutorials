%% 2D simple wavelet reconstruction
function A = recWave2D(LcLrA, HcLrA, LcHrA, HcHrA, lr, hr)
% Reconstruction of an image from lr and hr filters and from the wavelet
% decomposition.
% A: resulting (reconstructed) image
%
% NB: This algorithm supposes the number of pixels in x and y dimensions is
% a power of 2.

[sx, sy] = size(LcLrA);

%% Allocate temporary matrices
LrA = zeros(sx*2, sy);
HrA = zeros(sx*2, sy);
A   = zeros(sx*2, sy*2);

%% Reconstruct from cols
for j=1:sy,
    LrA(:,j) = waveSingleRec(LcLrA(:,j), HcLrA(:,j), lr, hr);
    HrA(:,j) = waveSingleRec(LcHrA(:,j), HcHrA(:,j), lr, hr);
end

%% Reconstruct from rows
for i=1:sx*2,
    A(i,:) = waveSingleRec(LrA(i,:), HrA(i,:), lr, hr);
end

%% Display reconstructed image
figure();
imshow(A,[]);