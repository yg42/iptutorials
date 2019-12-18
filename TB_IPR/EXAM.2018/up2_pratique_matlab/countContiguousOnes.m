function n = countContiguousOnes(x)
% Evaluates the number of contiguous 'ones'
% https://de.mathworks.com/matlabcentral/answers/317399-count-number-of-consecutive-1-s-within-a-block

nmax=0;

for i=1:length(x)
    x2 = circshift(x, i);
    f = find(diff([0,x2,0]==1));
    p = f(1:2:end-1);  % Start indices
    y = f(2:2:end)-p;  % Consecutive ones’ counts
    if (isempty(y))
        n=0;
    else
        n =max(y);
    end
    
    if n>nmax
        nmax=n;
    end
    
end

n = nmax;
end

