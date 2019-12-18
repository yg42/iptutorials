%% image enhancement tutorial

%% 0 - cleaning
clear all; close all;clc

%% 1 - Intensity transform
% read and display image
A=imread('osteoblaste.tif');
A=double(A);
A=A/255;
% gamma transform
figure
subplot(2,2,1);viewImage(A);title('original image');
Ar=imadjust(A,[min(A(:)) max(A(:))],[0 1],1); %imwrite(uint8(255*Ar), 'osteo_g1.png');
subplot(2,2,2);viewImage(Ar);title('enhanced, g=1');
Ar=imadjust(A,[0.25 0.75],[0 1],0.5); %imwrite(uint8(255*Ar), 'osteo_g05.png');
subplot(2,2,3);viewImage(Ar);title('enhanced, g=0.5');
Ar=imadjust(A,[0.25 0.5],[0 1],2); %imwrite(uint8(255*Ar), 'osteo_g2.png');
subplot(2,2,4);viewImage(Ar);title('enhanced, g=2');
% contrast stretching
m=mean(A(:));
figure
subplot(2,2,1);viewImage(A);title('originale');
Ar=1./(1+(m./(A+eps)).^5); %imwrite(uint8(255*Ar), 'osteo_E5.png');
subplot(2,2,2);viewImage(Ar);title('contrast stretching : E=5');
Ar=1./(1+(m./(A+eps)).^10);%imwrite(uint8(255*Ar), 'osteo_E10.png');
subplot(2,2,3);viewImage(Ar);title('contrast stretching: E=10');
Ar=1./(1+(m./(A+eps)).^1000);%imwrite(uint8(255*Ar), 'osteo_E1000.png');
subplot(2,2,4);viewImage(Ar);title('contrast stretching: E=1000');

%% 2 - Histogram equalization
A=imread('osteoblaste.tif');
Ar=histeq(A); imwrite(uint8(Ar), 'osteo_histeq.png');
figure
subplot(3,2,1);viewImage(A);title('Original image');
subplot(3,2,2);viewImage(Ar);title('Histogram equalization');
subplot(3,2,3);imhist(A);title('Initial histogram');
subplot(3,2,4);imhist(Ar);title('Equalized histogram');
hnorm = imhist(A)./numel(A);
cdf=255.*cumsum(hnorm);
subplot(3,2,5);plot(1:1:256,cdf);title('LUT');
axis([0 260 0 260]);

%% 3 - Histogram matching
% histogram equalization
A=imread('phobos.jpg');
%A=double(A);
Ar=histeq(A); imwrite(uint8(Ar), 'phobos_histeq.png');
Ar2 = histo_eq(A);
figure
subplot(3,2,1);imshow(A, []);title('Original image');
subplot(3,2,2);imshow(Ar, []);title('Histogram equalization (matlab)');
subplot(3,2,3);bar(histcounts(A(:), 256));title('Initial histogram');
subplot(3,2,4);bar(histcounts(Ar(:), 256));title('Enhanced histogram');
subplot(3,2,5);imshow(Ar2, []);title('histo\_eq own version');
subplot(3,2,6);bar(histcounts(Ar2(:), 256));title('histo\_eq histogram');

% target histogram, with two modes
p=twomodegauss(0.05,0.1,0.8,0.2,0.04,0.01,0.002);
% matching
% matlab version 
%Ar=uint8(histeq(A,p)); 
% own version
Am = histo_matching(A, cumsum(p)); imwrite(Am, 'phobos_histmatch.png');
figure
subplot(3,2,6);plot(p);title('bi-modal target histogram');
xlim([0 255])
subplot(3,2,1);imshow(A);title('Original image');
subplot(3,2,2);imshow(Am);title('Resulting image');
subplot(3,2,3);bar(histcounts(A(:)));title('Initial histogram');
subplot(3,2,4);bar(histcounts(Am(:)));title('Resulting histogram');
