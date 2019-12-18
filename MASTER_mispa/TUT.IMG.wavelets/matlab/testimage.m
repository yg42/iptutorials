% test sur une image
I = imread('lena256.png');
%I = imread('Couche_18.png');
lvl = 7;

[C, S] = wavedec2(I, lvl, 'db4');

newC = wthcoef2('a', C, S);

I2 = waverec2(newC, S, 'db4');
imshow(I,[]);

figure(); imshow(I2,[]);

