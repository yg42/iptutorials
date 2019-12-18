%% morphological geodesic filtering

%% clean
close all; clc;

%% read image and add some noise
A=double(imread('lena512.bmp'));
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

imwrite(uint8(A), 'lena_noisy.png');
imwrite(uint8(Bmed), 'lena_median.png');
imwrite(uint8(B), 'lena_center.png');
%% alternate sequential filters
N = asf_n(A, 3);
M = asf_m(A, 3);
figure;
subplot(131);imshow(A/255);colormap gray
subplot(132);imshow(M/255);title('ASF M')
subplot(133);imshow(N/255);title('ASF N')


imwrite(uint8(M), 'lena_asf_m.png');
imwrite(uint8(N), 'lena_asf_n.png');
%% ouverture et fermeture par reconstruction
D=openrec(A,3);
E=closerec(A,3);

figure
subplot(141);imshow(A/255);colormap gray
subplot(142);imshow(medfilt2(B,[5 5])/255);title('median')
subplot(143);imshow(D/255);title('open rec')
subplot(144);imshow(E/255);title('close rec')


imwrite(uint8(D), 'lena_openrec.png');
imwrite(uint8(E), 'lena_closerec.png');

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
title('ASF by reconstruction')

imwrite(uint8(co3), 'lena_asf_rec.png');

%% morphological center by reconstruction
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
imwrite(uint8(co3), 'lena_center_rec.png');
