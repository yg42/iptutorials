R = .1:.1:1.5;
e = zeros(length(R), 1);
h = waitbar(0, 'please wait');
for i=1:length(R)
    e(i) = covariogram(R(i), false);
    waitbar(i/length(R));
end
close (h)
plot(R, e); title('mean square error');
