function RES = GANmean(A,m)

RES = zeros(size(A));

parfor s = 0:255
    thresh = (A >= s-m) & (A <= s+m);
    seed = (A == s);
    thresh = imreconstruct(seed,thresh,8);
    label = bwlabeln(thresh,8);
    nbLabel = max(label(:));
    for n = 1:nbLabel;
        currentLabel = (label == n);
        values = A(currentLabel);
        meanValue = mean(values);
        result = meanValue.*currentLabel.*seed;
        RES = RES + result;
    end
end

