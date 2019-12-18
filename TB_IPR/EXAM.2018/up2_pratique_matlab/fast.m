I = imread('square.png'); I = I(:,:,2);
%I = imread('sweden_road.png');
I = 255*uint8(I > 200);
tic
W=3;
t = 10;
C=uint8(zeros(size(I)));
N=uint8(zeros(size(I)));
for i=1+W:size(I, 1)-W
    parfor j=1+W:size(I,2)-W
        [res, n1, n2] = isFastCorner(I, i, j, W, t, 11);
        C(i, j) = res;
        N(i, j) = max(n1, n2);
    end
end

imshow(C, [])

% %% used to save image as a color image, with Harris points in color
I2 = repmat(I, 1, 1, 3);

SE = strel('disk', 3);
P = imdilate(255*C, SE);
I2(:,:,1) = max(I2(:,:,1), P);
I2(:,:,2) = min(I2(:,:,2), 255-P);
I2(:,:,3) = min(I2(:,:,3), 255-P);
imshow(I2, [])
toc

figure, imshow(N>=10, []);