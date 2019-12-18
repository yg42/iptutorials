function testContiguousOnes(f)

r=0;
N=100;
for i=1:N
    x = randi(2, 16, 1)-1;
    n1 = countContiguousOnesYG(x');
    n2 = f(x);
    r = r + uint8(n1==n2);
end

if r==N
    disp('OK');
else
    disp([ num2str(r/N) '% correct']);
    
end