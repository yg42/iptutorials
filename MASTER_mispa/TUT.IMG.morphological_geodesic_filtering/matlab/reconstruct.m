function B=reconstruct(A,M)
%M=min(M,A);
se=strel('square',3);
bool=0;
while (bool ~= 1)
    temp=M;
    M=min(A, imdilate(M, se));
    bool=isequal(temp,M);
end
B=M;