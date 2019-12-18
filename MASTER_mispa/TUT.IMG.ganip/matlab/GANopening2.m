function RES = GANopening2(A,h,m)

temp = GANerosion2(A,h,m);
RES = GANdilation2(temp,h,m);