%% tutorial Harris corner detector
% 

%% checkerboard image
I = checkerboard(8)>.5;

% parameters: use classical value for K. scale is small for this image
K = .04;
sigma=1;
t=20;
[C, pts] = harris(I, K, sigma, t);

subplot(1,2,1);
imshow(C, []);
subplot(1,2,2);
imshow(I); hold on
scatter(pts(:,1), pts(:,2), 40, 'fill');
hold off

%% real image
%I = imread('cameraman.tif');
I = imread('sweden_road.png');
sigma=3;
t=10^7;
[C, pts] = harris(I, K, sigma, t);

figure
subplot(1,2,1);
imshow(C, []);
subplot(1,2,2);
imshow(I, []); hold on
scatter(pts(:,1), pts(:,2), 80, 'fill', 'r');
hold off

% %% used to save image as a color image, with Harris points in color
% I2 = repmat(I, 1, 1, 3);
% P = uint8(zeros(size(I)));
% for i=1:size(pts,1)
%     P(pts(i,2), pts(i,1)) = 255;
% end
% SE = strel('disk', 15);
% P = imdilate(P, SE);
% I2(:,:,1) = max(I2(:,:,1), P);
% I2(:,:,2) = min(I2(:,:,2), 255-P);
% I2(:,:,3) = min(I2(:,:,3), 255-P);
% imshow(I2, [])