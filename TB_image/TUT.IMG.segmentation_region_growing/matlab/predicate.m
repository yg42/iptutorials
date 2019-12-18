% predicate function
% for use with the region growing segmentation process
function r = predicate(I, p, seed, visited)
% this predicate function returns true or false if it verifies a condition
% between the seed pixel and the pixel p on image I
% I: Image
% p: candidate pixel
% seed: origin pixel
% visited: matrix of visited pixels (not used)

% threshold parameter
t = 10;

v = calcul(I(p(1), p(2)), I(seed(1), seed(2)));
if v <= t
    r = true;
else
    r = false;
end


%--------------------------------------------------------------------------
    function v = calcul(f,g)
        % condition of pixel belonging to the region
        v=abs(f-g);
    end

end



