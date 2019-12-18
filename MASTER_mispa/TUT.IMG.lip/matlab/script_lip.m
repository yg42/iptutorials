%% CORRECTION TP LIP - OPTION I&S

%% 0 - Nettoyage

clear all;close all;clc

%% 1 - Elementary LIP operations
M=256;

% read image
B=imread('breast.tif');
B=double(B);
% show image
figure;viewImage(B);title('Image originale');
% gray-tone function
tone = graytone(B, M);

D=graytone(timesLIP(2, tone), M);
figure;imshow(D,[0 256]);title('LIP scalar multiplication by 2');

%% 2 - Dynamic expansion

l=computeLambda(tone)
E=graytone(timesLIP(l,tone), M);
figure
subplot(1,3,1);imshow(B, [0 256]);title('Original image');
subplot(1,3,2);imshow(E,[0 256]);title('Dynamic expansion');
imwrite(uint8(E), 'expanded.png');
subplot(1,3,3);imshow(255*histeq(B/255),[0 256]);title('Histogram equalization');
imwrite(uint8(255*histeq(B/255)), 'histeq.png');

%% 3 - Contour detection
% The results are not really convincing in this case.
% The important thing is the use of the isomorphism to simplify the
% computations.
BW = edge(phi(tone, M));
figure(); imshow(BW); title('LIP edge detection')

BW = edge(B);
figure(); imshow(BW); title('Classic edge detection')

%% 4 - Fonctions annexes

type('plusLIP.m');
type('timesLIP.m');
type('computeLambda.m');
type('viewImage.m');