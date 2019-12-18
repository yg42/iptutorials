function [X,Y] = disgauss(n, length)
% generate a gaussian point process, centered in 0,0, with sigma=1;
% n: number of points
% length: window size

X=0 + randn(n,1);
Y=0 + randn(n,1);
% cut on window
X1=(-length/2<X<length/2);
X=X1.*X;
Y1=(-length/2<Y<length/2);
Y=Y1.*Y;
end