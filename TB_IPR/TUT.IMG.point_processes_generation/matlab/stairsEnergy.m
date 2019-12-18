function e = stairsEnergy(distance, steps, energy)
% This function returns e with same size as distance.
% e takes the value given in variable energy according to the steps
% distance: vector of all distances between points
% steps   : steps for energy function (unit: distance)
% energy  : value of energy for each step
e = zeros(size(distance));

prev_step = 0;
for i=1:length(steps)
    e(distance>=prev_step & distance<steps(i)) = energy(i);
    prev_step=steps(i);
end