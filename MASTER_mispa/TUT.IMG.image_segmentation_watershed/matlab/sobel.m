function B=sobel(A)
C=double(A);
h1=[1 2 1;0 0 0;-1 -2 -1];
h2=h1';
C1=filter2(h1,C,'same');
C2=filter2(h2,C,'same');
B=sqrt(C1.^2+C2.^2);