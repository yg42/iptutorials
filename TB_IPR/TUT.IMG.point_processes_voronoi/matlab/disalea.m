function [x,y] = disalea( n, length )
% uniform distribution of nbp points
% n: number of points
% length: window size
x1=rand(n,1);
y1=rand(n,1);
x=x1.*length-length/2;
y=y1.*length-length/2;
end