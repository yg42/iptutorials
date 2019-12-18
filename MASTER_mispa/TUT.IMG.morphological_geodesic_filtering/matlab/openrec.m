function D=openrec(A,n)
B=imerode(A,strel('disk',n));
D=reconstruct(A,B);
