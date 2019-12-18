function [R, t] = rigid_registration(data1, data2)
% Rigid transformation estimation between n pairs of points
% This method finds a rotation R and a translation t
% data1 : array of size nx2
% data2 : array of size nx2

% Convert pixels coordinates into x,y coordinates
data1_inv = fliplr(data1);
data2_inv = fliplr(data2);

% computes barycenters, and recenters the points
m1 = mean(data1_inv);
m2 = mean(data2_inv);
data1_inv_shifted = data1_inv-m1;
data2_inv_shifted = data2_inv-m2;

% Evaluates SVD
K = data2_inv_shifted'*data1_inv_shifted;
[U,~,V] = svd(K);

% Computes Rotation
S = eye(2);
S(2,2) = det(U)*det(V);
R = U*S*V';

% Computes Translation
t = flipud( m2' - R*m1');