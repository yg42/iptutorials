function [Area, Perimeter, EulerNb4, EulerNb8] = minkowski_functionals(I)
% Minkowski functionals
% First computes a neighborhood configuration, then evaluates the
% functionals with a specific coefficient for each configuration.
%
F = [0 0 0; 0 1 4; 0 2 8];
X = padarray(I, [1,1]); % ensures no pixel touches the border
XF = conv2(double(X),F,'same');
h = hist(XF(:),16);
bar(0:15,h);

%% Computation of the functionals
f_intra = [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
e_intra = [0 2 1 2 1 2 2 2 0 2 1 2 1 2 2 2];
v_intra = [0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
EulerNb8 = sum(h.*v_intra - h.*e_intra + h.*f_intra);
f_inter = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
e_inter = [0 0 0 1 0 1 0 2 0 0 0 1 0 1 0 2];
v_inter = [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
EulerNb4 = sum(h.*v_inter - h.*e_inter + h.*f_inter);
Area = sum(h.*f_intra);
Perimeter = sum(-4*h.*f_intra + 2*h.*e_intra);
end

