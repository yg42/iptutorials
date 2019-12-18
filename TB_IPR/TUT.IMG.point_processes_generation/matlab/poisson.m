function n=poisson(lambda)
% simulation d'une loi de Poisson
% il vaut mieux utiliser la fonction poissrnd de matlab

p=alea(9999);
n=0.0;

pp1=exp(-lambda); % loi de Poisson pour n=0
pp=pp1;
while (p>10000*pp)
    n=n+1; 
    pp1=pp1*lambda/n; % loi de Poisson pour n
    pp=pp+pp1; % 
end
%algorithm poisson random number (Knuth):
%   init:
%         Let L ← e−λ, k ← 0 and p ← 1.
%    do:
%         k ← k + 1.
%         Generate uniform random number u in [0,1] and let p ← p × u.
%    while p > L.
%    return k − 1.