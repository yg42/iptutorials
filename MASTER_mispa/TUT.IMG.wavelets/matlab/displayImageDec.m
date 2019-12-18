function [ A ] = displayImageDec( C )
% Construct a single image from a wavelet decomposition
% C: the decomposition

n_scales = length(C)-1;
[n, m] = size(C{1}{1});
A = zeros(2*n, 2*m);

prev = C{n_scales+1};
for s=n_scales:-1:1
    ns = n / 2^(s-2);
    ms = m / 2^(s-2);
    A(1:ns, 1:ms) = imdec2im(prev, C{s});
    prev = A(1:ns, 1:ms);
end

end

