function [x,y] = disregular(n, length)
% Regular distribution of points
% n: number of points
% length: window size
c=floor(sqrt(n));
[x2,y2]=meshgrid(0:(length/c):length,0:(length/c):length);
x=x2(:)-length/2;
y=y2(:)-length/2;
end