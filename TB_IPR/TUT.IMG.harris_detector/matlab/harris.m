function [C, pts] = harris(I, K, sigma, t)
%HARRIS corner detector
%     I     : original grayscale image
%     K     : coefficient
%     sigma : scale of observation (gaussian filter size)
%     t     : threshold value
%
% return values
%     C     : Cornerness measure
%     pts   : coordinates of the points


% first of all, compute gradient in x and y directions
% hx = [-1  0 1; -2 0 2; -1 0 1];
% Ix = conv2(I, hx,  'same');
% Iy = conv2(I, hx', 'same');
[Ix, Iy] = imgradientxy(I);

% compute the different coefficients of the Harris detector
M1 = Ix.^2;
M2 = Ix.*Iy;
M4 = Iy.^2;

% apply scale
M1 = imgaussfilt(M1, sigma);
M2 = imgaussfilt(M2, sigma);
M4 = imgaussfilt(M4, sigma);

% cornerness measure evaluation and display
C = (M1.*M4 - M2.^2) - K *(M1+M4).^2;

% keep only highest values
C2 = C;
C2(C2<t)=0;

% find local maxima
corners = imextendedmax(C2, 3);

% eliminates blobs touching the borders of the image
corners = imclearborder(corners, 8);

% subpixel detection
% display results
stats = regionprops(corners, 'Centroid');

if ~isempty(stats)
    pts = cat(1, stats.Centroid);
else
    pts = [];
end


end % end of function

