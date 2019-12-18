%% CORRECTION TP RESTAURATION 2 - OPTION I&S

%% 0 - Nettoyage

clear all;close all;clc

%% 1 - Fonction de d�gradation

f=checkerboard(8);
psf=fspecial('motion',7,45);
gb=imfilter(f,psf,'circular');
noise=imnoise(zeros(size(f)),'gaussian',0,0.001);
g=gb+noise;

H = psf2otf(psf, size(f));
G = fft2(gb);
alpha = 0.01;
F = G ./ (H+alpha);
fr = ifft2(F);
imshow(fr,[]);

figure;
subplot(2,2,1);imshow(f,[]);title('image originale');
imwrite(f, 'original_image.png');
subplot(2,2,2);imshow(gb,[]);title('flou de mouvement');
imwrite(gb, 'movement.png');
subplot(2,2,3);imshow(noise,[]);title('bruit gaussien');
imwrite(recadre(noise), 'noise.png');
subplot(2,2,4);imshow(g,[]);title('image d�grad�e');
imwrite(g, 'degraded.png');

%% 2 - Filtrage direct inverse et filtrage de Wiener

fr1=deconvwnr(g,psf);

SpecPuissNoise=abs(fft2(noise)).^2;
PuissMoyNoise=sum(SpecPuissNoise(:))/numel(noise);
SpecPuissImageOrig=abs(fft2(f)).^2;
PuissMoyImageOrig=sum(SpecPuissImageOrig(:))/numel(f);
ratio=PuissMoyNoise/PuissMoyImageOrig;

fr2=deconvwnr(g,psf,ratio);

figure
subplot(2,2,1);imshow(f,[]);title('image originale');
subplot(2,2,2);imshow(gb,[]);title('image d�grad�e');
subplot(2,2,3);imshow(fr1,[]);title('filtrage inverse');
imwrite(fr1, 'inverse_filter.png');
subplot(2,2,4);imshow(fr2,[]);title('filtrage wiener');
imwrite(fr2, 'wiener_filter.png');

%% 3 - Filtrage de Lucy-Richardson et d�convolution aveugle
close all

f=checkerboard(8);
psf=fspecial('gaussian',7,10);
sd=0.01;
g=imnoise(imfilter(f,psf, 'circular'),'gaussian',0,sd^2);
dampar=10*sd;
lim=ceil(size(psf,1)/2);
weight=zeros(size(g));
weight(lim+1:end-lim,lim+1:end-lim)=1;

fr3_5=deconvlucy(g,psf,5,dampar,weight);
fr3_10=deconvlucy(g,psf,10,dampar,weight);
fr3_11=deconvlucy(g,psf,10);
fr3_20=deconvlucy(g,psf,20,dampar,weight);
fr3_100=deconvlucy(g,psf,100,dampar,weight);
figure
subplot(2,3,1);imshow(f,[]);title('image originale');
subplot(2,3,2);imshow(g,[]);title('image degradee');
subplot(2,3,3);imshow(fr3_5,[]);title('Lucy-Richardson : 5');
imwrite(fr3_5, 'LR_5.png');
subplot(2,3,4);imshow(fr3_10,[]);title('Lucy-Richardson : 10');imwrite(fr3_10, 'LR_10.png');
subplot(2,3,5);imshow(fr3_11,[]);title('Lucy-Richardson : 10bis');imwrite(fr3_20, 'LR_20.png');
subplot(2,3,6);imshow(fr3_100,[]);title('Lucy-Richardson : 100');imwrite(fr3_100, 'LR_100.png');

% deconvolution aveugle
taille=7;
initpsf=ones(taille,taille);
lim=ceil(taille/2);
weight=zeros(size(g));
weight(lim+1:end-lim,lim+1:end-lim)=1;
[fr4_5,psfe]=deconvblind(g,initpsf,5,dampar);
[fr4_10,psfe]=deconvblind(g,initpsf,10,dampar);
[fr4_20,psfe]=deconvblind(g,initpsf,20,dampar);
[fr4_100,psfe]=deconvblind(g,initpsf,100,dampar);
figure
subplot(2,3,1);imshow(f,[]);title('image originale'); imwrite(g, 'deconvblind_originale.png')
subplot(2,3,2);imshow(g,[]);title('image degradee');
subplot(2,3,3);imshow(fr4_5,[]);title('deconvolution aveugle : 5'); imwrite(fr4_5, 'BD_5.png');
subplot(2,3,4);imshow(fr4_10,[]);title('deconvolution aveugle : 10');imwrite(fr4_5, 'BD_10.png');
subplot(2,3,5);imshow(fr4_20,[]);title('deconvolution aveugle : 20');imwrite(fr4_5, 'BD_20.png');
subplot(2,3,6);imshow(fr4_100,[]);title('deconvolution aveugle : 100');imwrite(fr4_5, 'BD_100.png');

%% 4 - Fonctions annexes
% 
% type('recadre.m');
% type('imshow.m');