function RES = GAN(A,p,m)

RES = zeros(size(A));
RES(p(2),p(1)) = 1;
s = A(p(2),p(1));
thresh = (A >= s-m) & (A <= s+m);
RES = imreconstruct(logical(RES),thresh,8);
