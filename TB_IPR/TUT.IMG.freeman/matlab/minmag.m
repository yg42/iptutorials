function code=minmag(c)
% find the lowest number constituted among all the cyclic translations of 
% code c
L = length(c);
C = zeros(L);
for i=1:L
    C(i,:)=circshift(c, i);
end

% search for minimum number 
% evaluates the value of the number formed by the array, thus, use polyval
% in decimal basis for getting this number
D= zeros(L, 1);
for i=1:L
    D(i) = polyval(C(i,:), 10);
end

[~, ind]=min(D);
code=C(ind(1),:);
