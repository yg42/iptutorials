function B=reconstruct(A,M)
M=min(M,A);
r=bwarea(M);
s=0;
se=strel('disk',1);
while (r ~= s)
    s=r;
    M=min(A, imdilate(M, se));
    r=bwarea(M);
end
B=M;