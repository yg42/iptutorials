function h = LBP(A)
% Local Binary Pattern of image A
% construct descriptor for each pixel, then evaluate histogram
% A: grayscale image
[m,n] = size(A);

B = zeros(m,n);

% binary code for pixel description
code = [1 2 4; 8 0 16; 32 64 128];

% loop over all pixels
parfor i=2:m-1
    for j=2:n-1
        w = A(i-1:i+1,j-1:j+1);
        w = (w >= A(i,j));
        w = w.*code;
        B(i,j) = sum(w(:));
    end
end

B = B(2:end-1,2:end-1);
h = histcounts(B(:), 256, 'normalization', 'probability');