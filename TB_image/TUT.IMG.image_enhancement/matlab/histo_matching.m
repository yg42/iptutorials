function I2 = histo_matching(I, cdf_target)
%
%    histogram matching, version with look-up-table
%    I: original image, with values in 8 bits integer
%
[hist, edges] = histcounts(I, 0:256);
cdf = cumsum(hist);
cdf = cdf / cdf(end);

% 1st apply histogram equalization
LUT = interp1(edges(1:end-1), cdf, double(I(:)));

% the apply inverse transformation to match target cdf
im2 = interp1(cdf_target, edges(1:end-1), LUT);

% finally, reshape and convert to uint8
I2 = reshape(im2, size(I,1), size(I,2));
I2 = uint8(I2);
