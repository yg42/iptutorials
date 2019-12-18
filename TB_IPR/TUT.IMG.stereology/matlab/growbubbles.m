function ptRads = growbubbles(ptsIn)
%GROWBUBBLES packs maximum radius circles at given central locations
%
%   PTRADS = GROWBUBBLES(PTS) returns the radius of circles at coordinates in PTS with all radii
%   maximised but without any circles overlapping. PTS is a P-by-N matrix of P "N-dimensional"
%   points.
%
%   If no output argument is given, PTSIN will be plotted as circles (2D) or spheres (3D) to the
%   current figure.
%
%   Example:
%
%     % Find the maximum packed radius of 20 random points
%     x = rand(20, 2);
%     ptRads = growbubbles(x);
%
%   See also DELAUNAYTRI

% Copyright 2011 Sven Holcombe. This code may be freely used and distributed, so long as it
% maintains this copyright line

[nPts, nDims] = size(ptsIn);

% Make a distance map from each point to all others, making sure pt A to A is infinite
distMap = sqrt(cell2mat(arrayfun(@(i)sum(bsxfun(@minus,ptsIn(i,:), ptsIn).^2,2),1:nPts,'UniformOutput',false)));
distMap(logical(eye(size(distMap)))) = inf;

% Measure the initial nearest neighbours, setting point radii to half that distance
[nnDists, nn] = min(distMap,[],1);
ptRads = nnDists/2;

% Any pairs of points that are each their nearest neighbour are "finalised" and cannot expand
finalisedMask = arrayfun(@(i)nn(nn(i))==i, 1:nPts);

% Other "open" points can expand one by one
while ~all(finalisedMask)
    openPtIds = find(~finalisedMask);
    % Find the distance from these points' circles to all other circles, and get that smallest gap
    openDistMap = bsxfun(@minus, bsxfun(@minus, distMap(:, openPtIds), ptRads(openPtIds)), ptRads');
    openPtMinGap = min(openDistMap,[],1);
    % Take the smallest gap, expand that point's circle to close that gap, finalise that point.
    [~,idx] = min(openPtMinGap);
    ptRads(openPtIds(idx)) = ptRads(openPtIds(idx)) + openPtMinGap(idx);
    finalisedMask(openPtIds(idx)) = true;
end

% If no output given, plot into current figure!
if ~nargout
    switch nDims
        case 2
            hold on
            plot(ptsIn(:,1),ptsIn(:,2),'.')
            cnrPts = bsxfun(@minus, ptsIn, ptRads(:));
            for i = find(ptRads(:)'>0)
                rectangle('Position', [ cnrPts(i,:) [2 2]*ptRads(i)], 'Curvature',[1 1])
                text(ptsIn(i,1), ptsIn(i,2), num2str(i))
            end
            axis equal
        case 3
            hold on
            [X,Y,Z] = ellipsoid(0,0,0,1,1,1,50);
            cols = interp1(0:6, lines(7), rand(nPts,1)*6);
            for i = 1:nPts
                surface(X*ptRads(i) + ptsIn(i,1),...
                    Y*ptRads(i) + ptsIn(i,2),...
                    Z*ptRads(i) + ptsIn(i,3),...
                    'FaceColor',cols(i,:), 'EdgeColor','none');
            end
        otherwise
            disp('Only 2 or 3 dimensional data can be displayed...')
    end
    
end