function [R, t] = reg(data1, data2)
data1_inv(:,1)=data1(:,2);
data1_inv(:,2)=data1(:,1);
data2_inv(:,1)=data2(:,2);
data2_inv(:,2)=data2(:,1);

m1 = mean(data1_inv,1);
m2 = mean(data2_inv,1);
data1_inv_shifted = [data1_inv(:,1)-m1(1), data1_inv(:,2)-m1(2)];
data2_inv_shifted = [data2_inv(:,1)-m2(1), data2_inv(:,2)-m2(2)];

K = data2_inv_shifted'*data1_inv_shifted;
[U,~,V] = svd(K);
S = eye(2);
S(2,2) = det(U)*det(V);
R = U*S*V';
t_inv = m2' - R*m1';
t(1) = t_inv(2);
t(2) = t_inv(1);
t = t';