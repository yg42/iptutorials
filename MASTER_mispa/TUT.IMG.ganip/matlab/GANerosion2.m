function RES = GANerosion2(A,h,m)

RES = 255*ones(size(A));

parfor s = 0:255
    thresh = (h >= s-m) & (h <= s+m);
    seed = (h == s);
    thresh = imreconstruct(seed,thresh,8);
    label = bwlabeln(thresh,8);
    nbLabel = max(label(:));
    for n = 1:nbLabel
        currentLabel = (label == n);
        values = A(currentLabel);
        values = sort(values);
        result = double(values(1))*currentLabel+255*(~currentLabel);
        RES = min(RES,result);
    end
end
