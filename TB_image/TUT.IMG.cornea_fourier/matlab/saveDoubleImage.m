function saveDoubleImage(I, filename)
% save an image into uint8 format from double data
I = I - min(I(:));
I = I / max(I(:)) * 255;
imwrite(uint8(I), filename);