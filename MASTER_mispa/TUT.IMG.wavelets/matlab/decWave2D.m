%% 2D simple wavelet decomposition
function [LcLrA, HcLrA, LcHrA, HcHrA] = decWave2D(image, ld, hd)
% wavelet decomposition of a 2D image into four new images.
% The image is supposed to be square, the size of it is a power of 2 in the
% x and y dimensions.

% We manipulate doubles
image = double(image);

%% Decomposition on rows
sx=size(image, 1);
sy=size(image, 2);

LrA = zeros(sx, sy/2);
HrA = zeros(sx, sy/2);
for i=1:sx
    [A, D]= waveSingleDec(image(i,:), ld, hd);
    LrA(i,:)= A;
    HrA(i,:)= D;
end


%% Decomposition on cols
LcLrA = zeros(sx/2, sy/2);
HcLrA = zeros(sx/2, sy/2);
LcHrA = zeros(sx/2, sy/2);
HcHrA = zeros(sx/2, sy/2);
for j=1:sy/2
    [A, D]= waveSingleDec(LrA(:,j), ld, hd);
    LcLrA(:,j) = A;
    HcLrA(:,j) = D;
    
    [A, D]= waveSingleDec(HrA(:,j), ld, hd);
    LcHrA(:,j) = A;
    HcHrA(:,j) = D;
end

%% Display result
figure();
subplot(2, 2, 1); imshow(LcLrA, []);
subplot(2, 2, 2); imshow(HcLrA, []);
subplot(2, 2, 3); imshow(LcHrA, []);
subplot(2, 2, 4); imshow(HcHrA, []);