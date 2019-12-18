function f = invphi(x, M0)
% isomorphisme inverse

f = M0 * (1-exp(-x/M0));