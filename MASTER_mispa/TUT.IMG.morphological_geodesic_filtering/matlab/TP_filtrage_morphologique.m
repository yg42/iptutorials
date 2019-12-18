%% morphological geodesic filtering

%% clean
close all; clc;

%% read image and add some noise
A=double(imread('lena.bmp'));
A=255*imnoise(A/255,'salt & pepper', 0.04);

%% morphological center
n=1;
se=strel('disk',n);
coc=imclose(imopen(imclose(A,se),se),se);
oco=imopen(imclose(imopen(A,se),se),se);
cMin=min(oco,coc);
cMax=max(oco,coc);
B=min(max(A,cMin),cMax);
figure;
Bmed=medfilt2(B,[5 5]);
subplot(131);imshow(A/255);colormap gray
subplot(132);imshow(Bmed/255);title('median')
subplot(133);imshow(B/255);title('morphological center')
title('center');

%% alternate sequential filters
n1=1;
n2=2;
n3=3;
se1=strel('disk',n1);
se2=strel('disk',n2);
se3=strel('disk',n3);
co1=imclose(imopen(A,se1),se1);
co2=imclose(imopen(co1,se2),se2);
co3=imclose(imopen(co2,se3),se3);

figure;
subplot(131);imshow(A/255);colormap gray
subplot(132);imshow(medfilt2(B,[5 5])/255);title('median')
subplot(133);imshow(co3/255);title('ASF')


%% ouverture et fermeture par reconstruction
D=openrec(A,3);
E=closerec(A,3);

figure
subplot(141);imshow(A/255);colormap gray
subplot(142);imshow(medfilt2(B,[5 5])/255);title('median')
subplot(143);imshow(D/255);title('open rec')
subplot(144);imshow(E/255);title('close rec')


%% ASF by reconstruction
n1=1;
n2=2;
n3=3;
co1=closerec(openrec(A,n1),n1);
co2=closerec(openrec(co1,n2),n2);
co3=closerec(openrec(co2,n3),n3);

figure;
subplot(131);imshow(A/255);colormap gray
subplot(132);imshow(medfilt2(B,[5 5])/255);title('median')
subplot(133);imshow(co3/255);title('ASF by reconstruction')
title('ASF by recconstruction')

%% centre morphologique par reconstruction
n=1;
coc=closerec(openrec(closerec(A,n),n),n);
oco=openrec(closerec(openrec(A,n),n),n);
cMin=min(oco,coc);
cMax=max(oco,coc);
B=min(max(A,cMin),cMax);

figure;
subplot(131);imshow(A/255);colormap gray
subplot(132);imshow(medfilt2(B,[5 5])/255);title('median')
subplot(133);imshow(B/255);title('centre by reconstruction')
title('center by reconstruction');
