function RES = GANclosing2(A,h,m)

temp = GANdilation2(A,h,m);
RES = GANerosion2(temp,h,m);