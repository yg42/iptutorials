function g=regiongrow(f,S,s)
% S : seeds
% s : seuil
g=false(size(f));
J=find(S);% search indices of gray tones != 0
S1=f(J);% vector of gray tones of seed values
for K=1:length(S1)
    masque=abs(double(S1(K))-double(f))<=s; % image of the gray tones in the good range
    TI=imreconstruct((f==S1(K)),masque);
    g=max(g,TI);
end

