function I2 = histo_eq(I)
%
%    histogram equalization, version with look-up-table
%    I: original image, with values in 8 bits integer
%
[hist, edges] = histcounts(I, 0:256);
cdf = cumsum(hist);
cdf = cdf / cdf(end);

% the LUT could be applied by this function:
%I2 = intlut(I, uint8(255*cdf));

I2 = interp1(edges(1:end-1), cdf, double(I(:)));
I2 = uint8(255 * I2);
I2 = reshape(I2, size(I));