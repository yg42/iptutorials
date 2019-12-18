%% CORRECTION TP FILTERING - AXE IBIS

%% 0 - Nettoyage

clear all;close all;

%% 1 - Low-pass filters
A=imread('bloodCells.bmp');
A=double(A);
A=A/255;
figure;
subplot(231);imshow(A);title('originale');
Amin=ordfilt2(A,1,ones(5,5),'symmetric');
subplot(232);imshow(Amin);title('passe-bas : min');
Amax=ordfilt2(A,25,ones(5,5),'symmetric');
subplot(233);imshow(Amax);title('passe-bas : max');
Amoyen=imfilter(A,1/25*ones(5,5),'symmetric');
subplot(234);imshow(Amoyen);title('passe-bas : moyen');
Amedian=ordfilt2(A,13,ones(5,5),'symmetric');
subplot(235);imshow(Amedian);title('passe-bas : median');
hgauss=fspecial('gaussian',[5 5],1);
Agauss=imfilter(A,hgauss);
subplot(236);imshow(Agauss);title('passe-bas : gaussien');

%% 2 - High-pass filters
figure;
subplot(231);imshow(A);title('originale');
AminPH=A-Amin;
subplot(232);imshow(AminPH);title('passe-haut : min');
AmaxPH=Amax-A;
subplot(233);imshow(AmaxPH);title('passe-haut : max');
AmoyenPH=A-Amoyen;
subplot(234);imshow(AmoyenPH);title('passe-haut : moyen');
AmedianPH=A-Amedian;
subplot(235);imshow(AmedianPH);title('passe-haut : median');
AgaussPH=A-Agauss;
subplot(236);imshow(AgaussPH);title('passe-haut : gaussien');
% Laplacian filter
B=imread('osteoblaste.bmp');
B=double(B);
B=B/255;
hlaplacien=[-1 -1 -1; -1 8 -1;-1 -1 -1];
Blaplacien=imfilter(B,hlaplacien);
Alaplacien=imfilter(A,hlaplacien);
figure;
subplot(221);imshow(A);title('originale');
subplot(222);imshow(Alaplacien);title('passe-haut : laplacien');
subplot(223);imshow(B);title('originale');
subplot(224);imshow(Blaplacien);title('passe-haut : laplacien');

%% 3 - Filtrage d�rivateur

% prewitt
hprewittx=[-1 0 1;-1 0 1;-1 0 1];
hprewitty=[-1 -1 -1;0 0 0;1 1 1];
Aprewittx=imfilter(A,hprewittx);
Aprewitty=imfilter(A,hprewitty);
Aprewittxy=(Aprewittx.^2+Aprewitty.^2).^(0.5);
subplot(221);imshow(A);title('originale');
subplot(222);imshow(Aprewittxy);title('prewitt : x et y');
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
subplot(221);imshow(A);title('originale');
subplot(222);imshow(Asobelxy);title('sobel : x et y');
subplot(223);imshow(Asobelx);title('sobel : x');
subplot(224);imshow(Asobely);title('sobel : y');

imwrite(Asobelxy, 'bloodcells_sobel.png')
imwrite(Asobelx, 'bloodcells_sobel_x.png')
imwrite(Asobely, 'bloodcells_sobel_y.png')
%% 4 - Filtrage de r�haussement

figure
Brehauss1=B+Blaplacien;
Brehauss2=0.5*B+Blaplacien;
Brehauss3=2*B+Blaplacien;
subplot(221);imshow(B);title('originale');
subplot(222);imshow(Brehauss1);title('rehaussement : 1');
subplot(223);imshow(Brehauss2);title('rehaussement : 0.5');
subplot(224);imshow(Brehauss3);title('rehaussement : 2');

%% 5 - Question ouverte
figure
Bhisteq=histeq(B);
subplot(131);imshow(B);title('originale');
subplot(132);imshow(Brehauss3);title('rehaussement par laplacien');
subplot(133);imshow(Bhisteq);title('rehaussement par �galisation histogramme');
