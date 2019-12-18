%% Watershed segmentation

%% 0 - Cleaning

close all;clc

%% 1 - distance map and watershed
% read binary image
A=imread('circles.tif');
% distance map
dist=bwdist(~A);
% watershed
watf=watershed(imcomplement(dist));
watf=(watf==0);
% separation of the grains
B=A & ~watf;
% visualisation
figure
subplot(2,2,1);viewImage(A);title('Original image');
imwrite(A,'A.jpg')
subplot(2,2,2);viewImage(dist);title('Distance map');
dist2=uint8(255*(dist-min(min(dist)))/(max(max(dist))-min(min(dist))));
imwrite(dist2,'dist.jpg')
subplot(2,2,3);viewImage(watf);title('Wathershed');
subplot(2,2,4);viewImage(B);title('Separation of the grains');
imwrite(B,'B.png')

%% 2 - Wathershed and gradients

% read grayscale image
A=imread('gel.jpg');
% gradient
gradient=sobel(A);
imwrite(uint8(gradient*255. / max(gradient(:))), 'gradient.png');
rm=imregionalmin(gradient);
imwrite(rm, 'minima_gradient.png');
% watershed
wat=watershed(gradient);
wat=(wat==0);
% visualisation
figure
subplot(2,2,1);viewImage(A);title('Original image');
subplot(2,2,2);viewImage(gradient);title('Gradient image');
subplot(2,2,3);viewImage(rm);title('Minima of gradient image');
subplot(2,2,4);viewImage(wat);title('Watershed');
imwrite(wat, 'wat.png');

% Watershed of the gradient after filtering the image
% read image
A=imread('gel.jpg');
% filtering
se = strel('disk',2);
AA=imopen(A,se);
f=imclose(AA,se);
% gradient
gradient=sobel(f);
rm=imregionalmin(gradient);
imwrite(rm, 'minima_filtered.png');
% watershed
wat=watershed(gradient);
wat=(wat==0);
% visualisation
figure
subplot(2,2,1);viewImage(A);title('Original image');
subplot(2,2,2);viewImage(f);title('Filtered image');
subplot(2,2,3);viewImage(rm);title('Minima : gradient of filtered image');
subplot(2,2,4);viewImage(wat);title('Watershed');
imwrite(wat, 'wat_filtered.png');

%% 3 - Watershed constrained by markers

% internal markers: minima of the filtered image 
se = strel('disk',2);
AA=imopen(A,se);
f=imclose(AA,se);
rm=imregionalmin(f);
rm = bwulterode(rm);
% external markers: watershed of filtered image
watf=watershed(f);
watf=(watf==0);
% display markers
figure
subplot(1,2,1);viewImage(rm);title('internal markers: minima of the filtered image');
subplot(1,2,2);viewImage(watf);title('external markers: waterhed of filtered image');
imwrite(rm, 'int_markers.png');
imwrite(watf, 'ext_markers.png');
% contrain the minima
gradient=sobel(f);
minima=max(rm,watf);
mie=imimposemin(gradient, minima);

% watershed constraint
watc=watershed(mie);
watc=(watc==0);
% over-impose original markers and segmentation
seg=A;
seg(watc==1)=255;
% visualisation
figure
subplot(2,2,1);viewImage(f);title('Filtered image');
subplot(2,2,2);viewImage(gradient);title('Gradient of filtered image');
subplot(2,2,3);viewImage(minima);title('Minima');
subplot(2,2,4);viewImage(seg);title('Segmentation');
imwrite(seg, 'segmentation.png');
