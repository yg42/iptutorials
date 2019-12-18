%% CoLIP - Color Logarithmic Image Processing

% Load color matching functions, purple line, wavelengths
load 'cmf.mat'

%% Classical representation of cmf in xy space
% normalisation
xn = SpecXYZ(:,:,1)./sum(SpecXYZ, 3);
yn = SpecXYZ(:,:,2)./sum(SpecXYZ, 3);
zn = 1-xn-yn;

figure(1);
scatter(xn, yn, 30, cmap, 'filled');


%% chromaticity diagram in a, rg, yb hat
% converts cmf into a,rg,yb hat space
ARGYB_hat = LMStoARGYB_chapeau(SpecLMS);
figure(2),
hold on
scatter(ARGYB_hat(:,1,2), ARGYB_hat(:,1,3), 30, cmap, 'filled');

% purple line
purple_ARGYB_hat = LMStoARGYB_chapeau(pourpresLMS);
scatter(purple_ARGYB_hat(:,1,2), purple_ARGYB_hat(:,1,3), 30, 'black', 'filled');

% RGB cube
step=10;
[R, G, B] = ndgrid(0:step:255, 0:step:255, 0:step:255);

R = reshape(R, numel(R), 1);
G = reshape(G, numel(G), 1);
B = reshape(B, numel(B), 1);

cubeRGB = cat(2, R, G, B)/255;
cubeRGB = reshape(cubeRGB, size(cubeRGB, 1), 1, 3);
colCubeRGB = reshape(cubeRGB, size(cubeRGB,1), 3);

% conversion from RGB to a,rg,yb hat
cubeXYZ = rgb2xyz(cubeRGB, 'WhitePoint', 'e');
cubeLMS = xyz2lms(cubeXYZ, 'hpe');
cube_ARGYB_hat = LMStoARGYB_chapeau(cubeLMS);
% display result
scatter(cube_ARGYB_hat(:,1,2), cube_ARGYB_hat(:,1,3), 30, colCubeRGB, 'filled');

