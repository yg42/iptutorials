function B=thinning(A,TT)

B=A;
for i=1:length(TT)
    B=B-hitormiss(B,TT{i});
end