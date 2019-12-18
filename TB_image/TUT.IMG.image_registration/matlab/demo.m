%% Image Registration tutorial

%% 0 - Cleaning

clear all;close all; clc;

%% Reading and visualization of images

A = double(imread('brain1.bmp'));
B = double(imread('brain2.bmp'));

figure
subplot(131);viewImage(A);title('moving image');
subplot(132);viewImage(B);title('source image');
subplot(133),imshowpair(A,B);title('superimposition');

% for saving fusion image
figure; imshowpair(A,B);
frame = getframe();
imageFusion = frame2im(frame);
imwrite(imageFusion,'imageFusionReg.png');

%% Manual extraction of corner points
% the choice of the points with a manual selection gives the exact same
% number of points for the two images, and the precision is high.
[A_points, B_points] = cpselect(A/255,B/255, 'Wait', true);


%% Transformation estimation
% If coming from the previous cpselect method, the points will give an
% almost perfect transformation.
[R, t] = rigid_registration(A_points, B_points);

% if you want to evaluate the angle of rotation:
% angle_rotation = acos(R(1,1))*180/pi*sign(R(1,2))
xform = [R,[0;0];t',1];
tform_rigid = affine2d(xform);

% Matlab solution to evaluate the transformation. Notice that this is not
% exactly the same transformation, as the previous one is rigid, and this
% one allows a scaling factor.
%tform_rigid=fitgeotrans(A_points,B_points,'nonreflectivesimilarity');

% Transformation
[Atrans, Rtrans] = imwarp(A, imref2d(size(A)), tform_rigid);

% Transform of the control points
A_points_trans = R * flipud(A_points') + flipud(t);

% Display results
displayRegistration(A, B, Atrans, Rtrans, A_points, B_points, A_points_trans);
saveRegistration(B, Atrans, Rtrans, B_points, A_points_trans, 'imageFusionManual.png');

%% Same method, with random order in the points
% one could change the points in the cpselect window
% by chance it might work...
p = randperm(length(A_points));
A_points = A_points(p,:);
[R, t] = rigid_registration(A_points, B_points);
xform = [R,[0;0];t',1];
tform_rigid = affine2d(xform);
% Transformation
[Atrans, Rtrans] = imwarp(A, imref2d(size(A)), tform_rigid);
% Transform of the control points
A_points_trans = R * flipud(A_points') + flipud(t);
% Display results
displayRegistration(A, B, Atrans, Rtrans, A_points, B_points, A_points_trans);
saveRegistration(B, Atrans, Rtrans, B_points, A_points_trans, 'imageFusionRandomManual.png');

%% Automatic extraction of corner points
% Unfortunately, this is not possible to have an interactive selection of
% the control points.
% Harris corners detection does not ensure to give the same exact points,
% in the same order.
cornersA = detectHarrisFeatures(A,'FilterSize', 7);
cornersB = detectHarrisFeatures(B,'FilterSize', 7);

nb_points = 20;
figure
imshow(A,[]);
hold on; plot(cornersA.selectStrongest(nb_points))
%export_fig 'harris_A.png' % export_fig is a code available on matlab
%central
figure;imshow(B,[]);
hold on; 
plot(cornersB.selectStrongest(nb_points));
%export_fig 'harris_B.png'

%% Evaluate rigid registration with Harris points
[R, t] = rigid_registration(cornersA.selectStrongest(nb_points).Location, cornersB.selectStrongest(nb_points).Location);
xform = [R,[0;0];t',1];
tform_rigid = affine2d(xform);

% Transformation
[Atrans, Rtrans] = imwarp(A, imref2d(size(A)), tform_rigid);

% Transform of the control points
A_points_trans = R * flipud(cornersA.selectStrongest(nb_points).Location') + flipud(t);

% Display results
displayRegistration(A, B, Atrans, Rtrans, cornersA.selectStrongest(nb_points).Location, cornersB.selectStrongest(nb_points).Location, A_points_trans);

saveRegistration(B, Atrans, Rtrans, cornersB.selectStrongest(nb_points).Location, A_points_trans, 'imageFusionHarris.png');

%% ICP-based image registration
% uses iterative control points algorithm, with reorganisation of points
% case with manual selection of points
% remember that A_points have been shuffled randomly
tform = icp_transform(A_points, B_points);

[Atrans, Rtrans] = imwarp(A, imref2d(size(A)), tform);
[X,Y]=tform.transformPointsForward(A_points(:,1),A_points(:,2));
A_points_trans = [Y, X]';

% Display results
displayRegistration(A, B, Atrans, Rtrans, A_points, B_points, A_points_trans);
title('ICP on manually selected points')

saveRegistration(B, Atrans, Rtrans, B_points, A_points_trans, 'imageFusionICPManual.png');

% case with automatic selection of points
p = randperm(nb_points); % this proves that the method is robust after random organisation of the points
dataA = double(cornersA.selectStrongest(nb_points).Location(p,:));
dataB = double(cornersB.selectStrongest(nb_points).Location);

tform = icp_transform(dataA, dataB);

[Atrans, Rtrans] = imwarp(A, imref2d(size(A)), tform);
[X,Y]=tform.transformPointsForward( cornersA.selectStrongest(nb_points).Location(:,1),cornersA.selectStrongest(nb_points).Location(:,2));
A_points_trans = [Y, X]';
% Display results
displayRegistration(A, B, Atrans, Rtrans, cornersA.selectStrongest(nb_points).Location, cornersB.selectStrongest(nb_points).Location, A_points_trans);
title('ICP on random Harris points')

saveRegistration(B, Atrans, Rtrans, cornersB.selectStrongest(nb_points).Location, A_points_trans, 'imageFusionICPRandomHarris.png');
