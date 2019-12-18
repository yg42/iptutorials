%% Fourier 2D Transform - Toolbox Image Processing

%% 0 - Clean

clear all;close all;

%% 1 - Fourier Transform

% read image
A=imread('cerveau.bmp');
% visualisation 
figure;viewImage(A);title('Original image');
% spectrum
Spectrum=FT(A);
% display results
viewImageSpectre(A,Spectrum);title('Spectrum of original image');

%% 2 - Inverse Fourier Transform

% inverse transform
B=iFT(Spectrum);
% visualisation image
figure;imshow(B,[]);title('Inverse Fourier Transform');

% amplitude and phase computation
amplitude = abs(Spectrum);
phase = angle(Spectrum);

% reconstruction from amplitude only
C=iFT(amplitude);
figure;imshow(C,[]);title('Reconstruction from amplitude only');

% reconstruction from phase only
D=iFT(exp(1i*phase));
figure;imshow(D,[]);title('Reconstruction from phase only');



%% 3 - low-pass and high-pass filtering, by spectrum modification

% modification
Spectre_PB0=FiltrePB(Spectrum,20);
Spectre_PH0=FiltrePH(Spectrum,20);
% inverse Fourier transform
A_PB0=iFT(Spectre_PB0);
A_PH0=iFT(Spectre_PH0);
% display results
viewImageSpectre(A_PB0,Spectre_PB0);title('Low-Pass filter PB0');
viewImageSpectre(A_PH0,Spectre_PH0);title('High-Pass filter PH0');

%% 4 - Cornea cell density
A=imread('cornee.tif');
% spectrum
Spectrum=FT(A);
% amplitude computation
amplitude = abs(Spectrum);
viewImageSpectre(A, Spectrum);

% Filtering of the amplitude, classical Gaussian filter (convolution)
PSF = fspecial('gaussian',30,30);
Blurred = imfilter(amplitude,PSF,'symmetric','conv');
% Display the filtered amplitudes
figure;viewImage(Blurred);title('Amplitude filtrée');

% Keep a horizontal line. One has to find the distance between central peak
% (continuous part of the signal) and the second peak, in order to get the
% cell density.
figure();
V = Blurred(:,end/2);
plot(V);

% Finding peaks with an elementary method:
% look for the second peak after the foundamental, which is located at 
% length(V)/2
[pks, locs] = findpeaks(V);
hold on
plot(locs, pks, 'sr');
locs2 = sort(abs(length(V)/2-locs))

disp('frequency of repetition:')
f=locs2(2)/length(V)
disp('cornea diameter:')
d=1/f

%% 5 - Code des fonctions utiles
% type viewImage;
% type viewImageSpectre;
% type FT;
% type iFT;
% type FiltrePB;
% type FiltrePH;