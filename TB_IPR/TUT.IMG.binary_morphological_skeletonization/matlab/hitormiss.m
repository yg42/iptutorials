function B=hitormiss(A,T)

T1=(T == 1);
T2=(T == -1);
B=min(imerode(A,T1),imerode(1-A,T2));