function I = imwrite_rf(R, name)
% function that write a random field in a color image
%
% R: random field
% name: name of the image
%
% I: color image rgb

R = R - min(R(:));
R = 255 * R / max(R(:));
I = ind2rgb(uint8(R), jet(256));
imwrite(I, name);