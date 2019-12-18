function f = amf(I, Smax)
% adaptive median filter
% I: original image
% Smax: size maxi of neighborhood

f = I;

sizes=1:2:Smax;
zmin = zeros([size(I) length(sizes)]);
zmax = zeros([size(I) length(sizes)]);
zmed = zeros([size(I) length(sizes)]);

for k=1:length(sizes),
    zmin(:,:,k) = ordfilt2(I, 1, ones(sizes(k)), 'symmetric');
    zmax(:,:,k) = ordfilt2(I, sizes(k)^2, ones(sizes(k)), 'symmetric');
    zmed(:,:,k) = medfilt2(I, [sizes(k) sizes(k)], 'symmetric');
end

% determines for all scales at the same time if zmed is an impulse noise.
% this enables the choice of the scale.
isMedImpulse = (zmin==zmed) | (zmax==zmed);

for i=1:size(I,1)
    for j=1:size(I,2)
        
        % finds the right scale
        % determines k (neighborhood size) where the median value is not an
        % impulse noise
        k=1;
        while isMedImpulse(i,j,k) && k<length(sizes)
            k = k+1;
        end
        
        % if the value of the pixel I(i,j) is an impulse noise, it is
        % replaced by the median value at scale k, if not, it is kept
        % untouched (already set)
        if I(i,j)==zmin(i,j,k) || I(i,j)==zmax(i,j,k) ||  k == length(sizes)
            f(i,j) = zmed(i,j,k);
        end

    end
end