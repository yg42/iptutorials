function B=killSmall(A,n)
se=strel('disk',n);
M=imerode(A,se);
B=reconstruct(A,M);