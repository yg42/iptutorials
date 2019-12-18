function A=stretch_hist(B)
% histogram stretching.
% ensure the range is [0; 255]
A = B - min(B(:));
A = 255 * A / max(A(:));