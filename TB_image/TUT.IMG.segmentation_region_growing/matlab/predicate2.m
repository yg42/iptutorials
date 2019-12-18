% predicate function
% for use with the region growing segmentation process
function r = predicate2(I, p, seed, visited)
% this predicate function returns true or false if it verifies a condition
% between the pixel candidate pixel p and the mean value of the segment
% I: Image
% p: candidate pixel
% seed: origin pixel
% visited: matrix of visited pixels (not used)

% threshold parameter
t = 10;

m = mean(I(visited==1));
if abs(I(p(1), p(2)) - m) <= t
    r = true;
else
    r = false;
end



end



