function Image = LaplacianPyramidReconstruction(pyr, mode)
% Laplacian Pyramid Reconstruction
% pyr: laplacian pyramid
% mode: approximation mode for imresize

if ~exist('mode', 'var')
    mode = 'bilinear';
end

levels = size(pyr, 1)-1;

Image = pyr{levels+1};
for i=levels:-1:1
    Image = pyr{i} + imresize(Image, [size(pyr{i},1), size(pyr{i}, 2)], mode);
end
