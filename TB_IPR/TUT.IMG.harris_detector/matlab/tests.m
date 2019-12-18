% tests
% 
% imshow(I,[]);
% hold on
% scatter(pts(:,2), pts(:,1), 40, 'fill');
% hold off
% 
% figure;
% corners = detectHarrisFeatures(I);
% 
% imshow(I); hold on;
% plot(corners.selectStrongest(50));

I = imread('charlie.png');


charlie = imread('tete_charlie.png');

% search for image
XC = xcorr2(charlie(:,:,2), I(:,:,2));
imshow(XC,[]);

XC = normxcorr2(charlie(:,:,2), I(:,:,2));
imshow(XC,[]); hold on;

[~,indices] = max(XC(:));

[i,j] = ind2sub(size(XC),indices);
plot(i,j,'+')

figure, imshow(I); hold on
plot(j,i,'ro', 'linewidth', 5);

%% search for subimage
s=512;
cj=1473;
ci=2300;
charlie2 = I(ci:ci+s-1, cj:cj+s-1, :);
XC = normxcorr2(charlie2(:,:,2), I(:,:,2));
[~,indices] = max(XC(:));

[i,j] = ind2sub(size(XC),indices)
ioffSet = i-size(charlie2,1);
joffSet = j-size(charlie2,2);
figure, imshow(I); hold on
imrect(gca, [joffSet+1, ioffSet+1, size(charlie2,2), size(charlie2,1)]);
figure, imshow(charlie2);

%% search for rotation
% only 1 degree and detection is not performed
rot = imrotate(charlie2(:,:,2), 1, 'bilinear', 'crop');
% extract center part of template patch
charlie3 = rot(round(end/2)-128:round(end/2)+127, round(end/2)-128:round(end/2)+127);
figure, imshow(charlie3)
XC = normxcorr2(charlie3, I(:,:,2));
[~,indices] = max(XC(:));

[i,j] = ind2sub(size(XC),indices);
ioffSet = i-size(charlie3,1);
joffSet = j-size(charlie3,2);
figure, imshow(I); hold on
imrect(gca, [joffSet+1, ioffSet+1, size(charlie3,2), size(charlie3,1)]);

%% surf detector, multiscale, rotation
I20 = imread('db/dessin.png');
I2 = I20(:,:,2);

images={'db/VLC_Icon.svg.png', 'db/Sweden_road_sign_A19-7.svg.png', 'db/UnderCon_icon.svg.png', 'db/Orca.svg.png', 'db/Parrot_icon.svg.png'};
close all
for i = 1:length(images)
    
    I10=imread(images{i});
    I1 = I10(:,:,2);
    points = detectSURFFeatures(I1,'NumOctaves', 4);
    figure, imshow(I1); hold on;
    plot(points);
    
    points2 = detectSURFFeatures(I2,'NumOctaves', 4);
    
    [features1,valid_points1] = extractFeatures(I1,points);
    [features2,valid_points2] = extractFeatures(I2,points2);
    
    indexPairs = matchFeatures(features1,features2);
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);
    
    figure
    subplot(1,2,1)
    showMatchedFeatures(I10, I20, matchedPoints1, matchedPoints2, 'montage');
    [tform,inlierPtsDistorted,inlierPtsOriginal]  = estimateGeometricTransform(matchedPoints1,matchedPoints2,'affine', 'Confidence', 10);

    [fmat, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2, 'Method', 'RANSAC');
    %subplot(1,2,2); showMatchedFeatures(I10, I20, inlierPtsDistorted, inlierPtsOriginal, 'montage');
    subplot(1,2,2); showMatchedFeatures(I10, I20, matchedPoints1(inliers,:),matchedPoints2(inliers,:),'montage','PlotOptions',{'ro','go','y--'});
    title('Matched inlier points');
end