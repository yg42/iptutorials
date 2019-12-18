function K = kb(I, r)
% Kramer and Bruckner iterative filter
% I: originale image
% r: size of neighborhood
%
% return filtered image
se = strel('disk', r);
D = imdilate(I, se);
E = imerode(I, se);
difbool=double((D-I)<(I-E));

K = D.*difbool+E.*(1-difbool); 