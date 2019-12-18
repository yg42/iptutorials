function [T8,T8c,TT8]=nc(A)
% A : block 3x3, binary

% complementary set of A
invA=1-A;

% neighborhoods
V8=ones(3,3);
V8_star=[1 1 1;1 0 1;1 1 1];
V4=[0 1 0;1 1 1;0 1 0];

% intersection is done by the min operation
X1=min(V8_star,A);
TT8=sum(X1(:));
[~, T8] = bwlabeln(X1,8);

% The C-ajd-4 might introduce some problems if a pixel is not 4-connected
% to the central pixel
X2=min(V8,invA);
Y=min(X2,V4);
X=imreconstruct(Y,X2,4);
[~, T8c]=bwlabeln(X,4);

