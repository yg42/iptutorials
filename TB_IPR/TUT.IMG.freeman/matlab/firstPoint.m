function [x,y]=firstPoint(A)
% locates first non zero point of A (of the contour)
[r,c]=find(A);
x=r(1); y=c(1);