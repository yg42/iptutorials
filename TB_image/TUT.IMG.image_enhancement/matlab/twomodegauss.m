function p =twomodegauss(m1, sig1, m2, sig2, A1, A2,k)
c1 = A1*(1/((2*pi)^.5*sig1));
k1 =2*(sig1^2);
c2 = A2*(1/((2*pi)^.5*sig2));
k2 = 2*(sig2^2);
z = linspace(0,1,256);
p = k+c1*exp(-((z-m1).^ 2)./ k1)+ c2 *exp(-((z-m2).^2)./k2);
p = p./ sum(p(:));