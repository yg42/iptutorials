%% introduction tutorial
%% 0 - Cleaning

clear all;close all;

%% 1 - First manipulations

% Load and display an image
I=imread('retine.png');
imagesc(I);
figure(2);
imshow(I);

% Data contained in image
imfinfo('retine.png');
size(I)

% Green channel, second component of image: I(:,:,2);
% Display all channels
affichePar4(I, I(:,:,1), I(:,:,2), I(:,:,3))

% test read/write with loss in quality
imwrite(I, 'retine_lossy_25.jpg', 'jpg', 'Mode', 'lossy', 'Quality', 25);
a1=imread('retine_lossy_25.jpg');

imwrite(I, 'retine_lossy_50.jpg', 'jpg', 'Mode', 'lossy', 'Quality', 50);
a2=imread('retine_lossy_50.jpg');

imwrite(I, 'retine_lossy_75.jpg', 'jpg', 'Mode', 'lossy', 'Quality', 75);
a3=imread('retine_lossy_75.jpg');

imwrite(I, 'retine_lossy_100.jpg', 'jpg', 'Mode', 'lossy', 'Quality', 100);
a4=imread('retine_lossy_100.jpg');

% zoom on a specific region
d1=imcrop(a1, [75 68 130 112]);
d2=imcrop(a2, [75 68 130 112]);
d3=imcrop(a3, [75 68 130 112]);
d4=imcrop(a4, [75 68 130 112]);
% 
affichePar4(d1, d1, d3, d4);
imwrite(d1, 'retine_crop_25.png');
imwrite(d2, 'retine_crop_50.png');
imwrite(d3, 'retine_crop_75.png');
imwrite(d4, 'retine_crop_100.png');

%% 2 - Histogram
muscle=imread('muscle.jpg');
h = imhist(muscle); % to be coded
figure();plot(h);

% equivalent function:
figure(); imhist(muscle);

%% 3 - Linear stretching
% cornee is already a single channel (grey levels) image
cornee=imread('cellules_cornee.jpg');

minimum = min(cornee(:));
maximum = max(cornee(:));

a=255/(maximum-minimum);
b=-255*minimum/(maximum-minimum);

cornee2 = a*cornee + b;

figure();
subplot(2,2,1);imshow(cornee); title('cornea');
subplot(2,2,2);imshow(cornee2);title('stretch cornea');

% histograms
subplot(2,2,3);plot(imhist(cornee)); title('cornea histogram');
subplot(2,2,4);plot(imhist(cornee2));title('stretched histogram');


%% 4 - Color quantification
% the objective is to reduce the number of colors. The image is required to
% be coded in integers. The division thus performs a rounding (floor
% operation).
% The human eye is really tolerant to sub-quantification of
% intensities/colors, the result might not be evident to see at first,
% depending on the image.
image_gris = I(:,:,2); % take green channel
imwrite(image_gris, 'origine_green.png');
q4=image_gris/4*4;    % 64 grey levels
q16=image_gris/16*16; % 16 grey levels
q32=image_gris/32*32; %  8 grey levels
affichePar4(image_gris, q4, q16, q32);
imwrite(q4, 'quantification_q4.png');
imwrite(q16, 'quantification_q16.png');
imwrite(q32, 'quantification_q32.png');


%% 5 - Moiré effect

type cercle
C1=cercle(300,50);
C2=cercle(80,50);
figure
subplot(121);imshow(C1);
subplot(122);imshow(C2);

%% 6 - Low-pass filters
A=imread('bloodCells.bmp');
A=double(A);
A=A/255;
figure;
subplot(231);imshow(A);title('original image');
Amin=ordfilt2(A,1,ones(5,5),'symmetric');
subplot(232);imshow(Amin);title('low pass : min');
Amax=ordfilt2(A,25,ones(5,5),'symmetric');
subplot(233);imshow(Amax);title('low pass : max');
Amoyen=imfilter(A,1/25*ones(5,5),'symmetric');
subplot(234);imshow(Amoyen);title('low pass : moyen');
Amedian=ordfilt2(A,13,ones(5,5),'symmetric');
subplot(235);imshow(Amedian);title('low pass : median');
hgauss=fspecial('gaussian',[5 5],1);
Agauss=imfilter(A,hgauss);
subplot(236);imshow(Agauss);title('low pass : gaussien');

%% 7 - High-pass filters
figure;
subplot(231);imshow(A);title('original image');
AminPH=A-Amin;
subplot(232);imshow(AminPH);title('high pass : min');
AmaxPH=Amax-A;
subplot(233);imshow(AmaxPH);title('high pass : max');
AmoyenPH=A-Amoyen;
subplot(234);imshow(AmoyenPH);title('high pass : moyen');
AmedianPH=A-Amedian;
subplot(235);imshow(AmedianPH);title('high pass : median');
AgaussPH=A-Agauss;
subplot(236);imshow(AgaussPH);title('high pass : gaussien');
% Laplacian filter
B=imread('osteoblaste.bmp');
B=double(B);
B=B/255;
hlaplacien=[-1 -1 -1; -1 8 -1;-1 -1 -1];
Blaplacien=imfilter(B,hlaplacien);
Alaplacien=imfilter(A,hlaplacien);
figure;
subplot(221);imshow(A);title('originale');
subplot(222);imshow(Alaplacien);title('high pass: laplacian');
subplot(223);imshow(B);title('originale');
subplot(224);imshow(Blaplacien);title('high pass: laplacian');

%% 8 - Derivative filter (edge detection)

% prewitt
hprewittx=[-1 0 1;-1 0 1;-1 0 1];
hprewitty=[-1 -1 -1;0 0 0;1 1 1];
Aprewittx=imfilter(A,hprewittx);
Aprewitty=imfilter(A,hprewitty);
Aprewittxy=(Aprewittx.^2+Aprewitty.^2).^(0.5);
subplot(221);imshow(A);title('original image');
subplot(222);imshow(Aprewittxy);title('prewitt : x and y');
subplot(223);imshow(Aprewittx);title('prewitt : x');
subplot(224);imshow(Aprewitty);title('prewitt : y');

imwrite(Aprewittxy, 'bloodcells_prewitt.png')
imwrite(Aprewittx, 'bloodcells_prewitt_x.png')
imwrite(Aprewitty, 'bloodcells_prewitt_y.png')

% sobel
figure
hsobelx=[-1 0 1;-2 0 2;-1 0 1];
hsobely=[-1 -2 -1;0 0 0;1 2 1];
Asobelx=imfilter(A,hsobelx);
Asobely=imfilter(A,hsobely);
Asobelxy=(Asobelx.^2+Asobely.^2).^(0.5);
subplot(221);imshow(A);title('original image');
subplot(222);imshow(Asobelxy);title('sobel : x and y');
subplot(223);imshow(Asobelx);title('sobel : x');
subplot(224);imshow(Asobely);title('sobel : y');

imwrite(Asobelxy, 'bloodcells_sobel.png')
imwrite(Asobelx, 'bloodcells_sobel_x.png')
imwrite(Asobely, 'bloodcells_sobel_y.png')

%% 9 - Enhancement filter

figure
Brehauss1=B+Blaplacien;
Brehauss2=0.5*B+Blaplacien;
Brehauss3=2*B+Blaplacien;
subplot(221);imshow(B);title('original image');
subplot(222);imshow(Brehauss1);title('enhancement : 1');
subplot(223);imshow(Brehauss2);title('enhancement : 0.5');
subplot(224);imshow(Brehauss3);title('enhancement : 2');

%% 10 - Open question
figure
Bhisteq=histeq(B);
subplot(131);imshow(B);title('original image');
subplot(132);imshow(Brehauss3);title('laplacian enhancement');
subplot(133);imshow(Bhisteq);title('histogram equalization enhancement');
