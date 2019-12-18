function D=closerec(A,n)
% closerec and openrec are dual operators
D = 255-openrec(255-A, n);
