%% tutorial mathematical morphology and morphological reconstruction

%% 0 - Clear

clear all; close all;clc

%% 1 - Basic morphological operations

% read image;
B=imread('B.bmp');
% display image
figure;viewImage(B);title('original image');
% erosion, dilation, opening, closing with different structuring elements
se1 = strel('square',11) ;     % 15-by-15 square
se2 = strel('line',11,45);     % line, length 15, angle 45 degrees
se3 = strel('disk',5);        % disk, radius 15
figure;
% dilation
dilateSquare = imdilate(B, se1);
dilateLine = imdilate(B, se2);
dilateDisk = imdilate(B, se3);
subplot(4,3,1); viewImage(dilateSquare);title('dilatation, square');
subplot(4,3,2); viewImage(dilateLine);title('dilatation, segment');
subplot(4,3,3); viewImage(dilateDisk);title('dilatation, disk');
imwrite(dilateSquare, 'dilate_square.png');
imwrite(dilateLine, 'dilate_line.png');
imwrite(dilateDisk, 'dilate_disk.png');
% erosion
erodeSquare = imerode(B, se1);
erodeLine = imerode(B, se2);
erodeDisk = imerode(B, se3);
subplot(4,3,4); viewImage(erodeSquare);title('erosion, square');
subplot(4,3,5); viewImage(erodeLine);title('erosion, segment');
subplot(4,3,6); viewImage(erodeDisk);title('erosion, disque');
imwrite(erodeSquare, 'erode_square.png');
imwrite(erodeLine, 'erode_line.png');
imwrite(erodeDisk, 'erode_disk.png');
% open
openSquare = imopen(B, se1);
openLine = imopen(B, se2);
openDisk = imopen(B, se3);
subplot(4,3,7); viewImage(openSquare);title('opening, square');
subplot(4,3,8); viewImage(openLine);title('opening, segment');
subplot(4,3,9); viewImage(openDisk);title('opening, disk');
imwrite(openSquare, 'opening_square.png');
imwrite(openLine, 'opening_line.png');
imwrite(openDisk, 'opening_disk.png');
% close
closeSquare = imclose(B, se1);
closeLine = imclose(B, se2);
closeDisk = imclose(B, se3);
subplot(4,3,10); viewImage(closeSquare);title('closing, square');
subplot(4,3,11); viewImage(closeLine);title('closing, segment');
subplot(4,3,12); viewImage(closeDisk);title('closing, disk');
imwrite(closeSquare, 'closing_square.png');
imwrite(closeLine, 'closing_line.png');
imwrite(closeDisk, 'closing_disk.png');
% opening with varying size
figure;
for i=1:12
    sedisk(i)=strel('disk',i);
    openDisk = imopen(B, sedisk(i));
    subplot(4,3,i); viewImage(openDisk);title(strcat('opening, ',int2str(i)));
end

%% 2 - Reconstruction by mask

% read images
A=imread('A.bmp');
M=imread('M.bmp');
% reconstruction of A by M
AM=reconstruct(A,M);
figure;
subplot(1,3,1); viewImage(A);title('original image');
subplot(1,3,2); viewImage(M);title('marker');
subplot(1,3,3); viewImage(AM);title('reconstructed image');
imwrite(AM, 'reconstruction.png');
%% 3 - Operations by reconstruction

% suppress objects touching the borders
figure;
A=imread('B.bmp');
B=killBorders(A);
subplot(2,2,1); viewImage(A);title('original image');
subplot(2,2,2); viewImage(B);title('suppress border objects');
imwrite(B, 'killborders.png');
% fermeture des trous
B=closeHoles(A);
subplot(2,2,3); viewImage(B);title('close holes');
imwrite(B, 'closeholes.png');
% suppression des petits objets
B=killSmall(A,8);
subplot(2,2,4); viewImage(B);title('suppress small objects');
imwrite(B, 'killsmall.png');

%% 4 - Clean image cells

figure;
A=imread('cells.bmp');
C=(A<98);
B=closeHoles(C);
B=killBorders(B);
B=killSmall(B,5);
subplot(1,2,1); viewImage(A);title('original image');
subplot(1,2,2); viewImage(B);title('cleaned image');
imwrite(B, 'cleancells.png');
