function ARGYBtilde = ARGYBchaptoARGYBtilde(ARGYBchap)
% transformation vers ARGYB
%
M0 = getColipM0();

ARGYB = ARGYBchaptoARGYB(ARGYBchap);
ARGYBtilde = phi(ARGYB, M0);
end