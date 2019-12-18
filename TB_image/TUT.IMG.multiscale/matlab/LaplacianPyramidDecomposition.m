function [pyrG, pyrL] = LaplacianPyramidDecomposition(Image, levels, mode)
% Gaussian and Laplacian Pyramid decomposition
% Image must be either 2D (grayscale) or 3D (color)
% levels: number of levels of decomposition
% mode: approximation mode 'bilinear', 'nearest', etc. for use in imresize
% pyrG: Gaussian pyramid
% pyrL: Laplacian pyramid
%
% The Laplacian pyramid is of size levels+1. The last image pyrL{levels+1}
% is the approximation image of the last level. The original image is
% exactly reconstructed by the LaplacianPyramidReconstruction function.

% pyramids
pyrL = cell(levels+1, 1);
pyrG = cell(levels+1, 1);

% gaussian filter
H = fspecial('gaussian');

if ~exist('mode', 'var')
    mode = 'bilinear';
end

for i=1:levels
    ImagePrec = Image; % previous image
    g=imfilter(Image,H,'same');
    
    Image = imresize(g, .5, mode);
    ImagePrime = imresize(Image, [size(g,1), size(g,2)], mode);
    
    pyrL{i} =  ImagePrec - ImagePrime;
    pyrG{i} =  ImagePrec;

end
pyrL{levels+1} = Image;
pyrG{levels+1} = Image;