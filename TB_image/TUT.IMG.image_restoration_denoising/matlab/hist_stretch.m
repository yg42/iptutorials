function A=hist_stretch(B)
% histogram stretching.
% ensure the range is [0; 255]
A = B - min(B(:));
A = 255 * A / max(A(:));
A = uint8(A);