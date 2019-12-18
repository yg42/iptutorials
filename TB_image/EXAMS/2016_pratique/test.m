% test adaptive threshold
close all
%G = imread('sonet.png');
%G = imread('cameraman.tif');
G = imread('image.bmp');
imshow(G,[]);
G = double(G);

h = round(size(G,1)/8);
B = adaptiveThreshold(G, h, 0.15);
figure
imshow(B,[]);
