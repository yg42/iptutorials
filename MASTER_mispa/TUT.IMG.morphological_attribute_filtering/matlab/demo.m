%% CLEANING
clc;
clear all;
close all,

%% IMAGE READING
A = double(imread('toy.png'));
A = A(:,:,1);

%% IMAGE DECOMPOSITION
[m,n] = size(A);
levelSets_init = false(m,n,256);
for s=0:255
    levelSets_init(:,:,s+1) = A>=s;
end

%% ATTRIBUTE FILTERING
levelSets_res1 = zeros(m,n,256);
levelSets_res2 = zeros(m,n,256);
levelSets_res3 = zeros(m,n,256);
levelSets_res4 = zeros(m,n,256);
for s=0:255
    levelSets_res1(:,:,s+1) = s*(imreconstruct(imopen(levelSets_init(:,:,s+1),strel('square',25)),levelSets_init(:,:,s+1)));
    levelSets_res2(:,:,s+1) = s*bwareaopen(levelSets_init(:,:,s+1),1000);
    levelSets_res3(:,:,s+1) = s*bwpropfilt(levelSets_init(:,:,s+1),'eccentricity',[0.75 1]);
    levelSets_res4(:,:,s+1) = s*bwpropfilt(levelSets_init(:,:,s+1),'solidity',[0.75 1]);
end

%% IMAGE RECONSTRUCTION
B1 = max(levelSets_res1,[],3);
B2 = max(levelSets_res2,[],3);
B3 = max(levelSets_res3,[],3);
B4 = max(levelSets_res4,[],3);
figure
subplot(231);imshow(A,[]);title('original');
subplot(232);imshow(B1,[]);title('reconstruction opening / > square 25x25');
subplot(233);imshow(B2,[]);title('area opening / > 1000');
subplot(235);imshow(B3,[]);title('eccentricity thinning / [0.75, 1]');
subplot(236);imshow(B4,[]);title('convexity thinning / [0.75, 1]');

%% write results
imwrite(uint8(B1), 'toy_recOpening.png');
imwrite(uint8(B2), 'toy_areaOpening.png');
imwrite(uint8(B3), 'toy_elongThinning.png');
imwrite(uint8(B4), 'toy_convThinning.png');
