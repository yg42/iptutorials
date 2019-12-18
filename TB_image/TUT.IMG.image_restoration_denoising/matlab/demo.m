%% Image restoration: denoising

%% 0 - Cleaning

clear all;close all;clc

%% 1 - Generation of random noise images
S = 32;
% uniform
a=0;b=255;
R1=a+(b-a)*rand(S);
R1 = uint8(R1);
% Gaussian
b=1;
R2=a+b*randn(S);
R2=hist_stretch(R2);
% Salt and pepper
a=0.05;b=0.05;
R3=0.5*ones(S);
X=rand(S);
R3(X<=a)=0;
R3(X>a & X<=a+b)=1;
R3=hist_stretch(R3);
% exponential
a=1;
R4=-1/a*log(1-rand(S));R4=hist_stretch(R4);
figure;
subplot(2,2,1);viewImage(R1);title('uniform noise');
subplot(2,2,2);viewImage(R2);title('Gaussian noise');
subplot(2,2,3);viewImage(R3);title('salt and pepper noise');
subplot(2,2,4);viewImage(R4);title('exponential noise');

imwrite(R1, 'uniform_noise.png');
imwrite(R2, 'gaussian_noise.png');
imwrite(R3, 'sp_noise.png');
imwrite(R4, 'exp_noise.png');

% histograms
figure;
subplot(2,2,1);imhist(R1);title('uniform noise');
subplot(2,2,2);imhist(R2,50);title('Gaussian noise');
subplot(2,2,3);imhist(R3);title('salt and pepper noise');
subplot(2,2,4);imhist(R4);title('exponential noise');

imwrite(R1, 'uniform_noise.png');
imwrite(R2, 'gaussian_noise.png');
imwrite(R3, 'sp_noise.png');
imwrite(R4, 'exp_noise.png');

%% 2 - Noise evaluation

A=imread('jambe.tif');
A=double(A);
A=A/255;
figure;
c=[160 200 200 160];
r=[200 200 240 240];
C=roipoly(A,c,r);
subplot(1,3,1);viewImage(A);title('image originale');
subplot(1,3,2);viewImage(C);title('ROI');
subplot(1,3,3);imhist(A(C));title('histogramme de la ROI');
% exponential noise
[m,n]=size(A);
expnoise=1/0.5*log(1-rand(m,n));
B=A-expnoise/max(abs(expnoise(:)));B=hist_stretch(B);
imwrite(B, 'im_exp.png');
figure;
subplot(1,2,1);viewImage(B);title('Image with exponential noise');
subplot(1,2,2);imhist(B(C));title('histogram in ROI');

% Gaussian noise
B=imnoise(A,'gaussian',0,0.004);
imwrite(B, 'im_gauss.png');
figure;
subplot(1,2,1);viewImage(B);title('image with Gaussian noise');
subplot(1,2,2);imhist(B(C));title('histogramin ROI');

%% 3 - Spatial filtering
% load and display image
A=imread('jambe.tif');
A=double(A);
A=A/255;
[m,n]=size(A);
% add salt and pepper noise
B=imnoise(A,'salt & pepper', 0.25);
imwrite(B, 'noise_image.png');
% filtering
% mean
w=fspecial('average',5);
B1=imfilter(B,w);
imwrite(B1, 'mean_filter.png');
% max
B2=ordfilt2(B,9,ones(3,3));
imwrite(B2, 'max_filter.png');
% min
B3=ordfilt2(B,1,ones(3,3));
imwrite(B3, 'min_filter.png');
% median
B4=medfilt2(B,[7,7]);
imwrite(B4, 'med_filter.png');
%
figure
subplot(3,2,1);viewImage(A);title('original image');
subplot(3,2,2);viewImage(B);title('noisy image image');
subplot(3,2,3);viewImage(B1);title('mean filter');
subplot(3,2,4);viewImage(B2);title('max filter');
subplot(3,2,5);viewImage(B3);title('min filter');
subplot(3,2,6);viewImage(B4);title('median filter');
%adaptive median filter
B5=amf(B,7);
imwrite(B5, 'amf_filter.png');
figure
subplot(2,2,1);viewImage(A);title('original image');
subplot(2,2,2);viewImage(B);title('noisy image');
subplot(2,2,3);viewImage(B4);title('median filter 7x7');
subplot(2,2,4);viewImage(B5);title('adaptive median filter');