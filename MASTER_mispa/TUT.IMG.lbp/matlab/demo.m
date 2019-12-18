%% CORRECTION TUTORIAL "Local Binary Patterns"

%% 0 - Cleaning

clear all;
close all;
clc;

%% 1 - LBP construction

A = imread('images/Sand.1.bmp');
A = rgb2gray(A);
h = LBP(A);
bar(h);

%% 2 - Classification
% read all images by type of texture, and display their LBP
% they should look really similar
rep='images/';

name_image = 'Terrain';
LBP_Terrain = cell(1,4);

for i = 1:4
    A = imread(strcat(rep, name_image,'.',num2str(i),'.bmp'));
    A = rgb2gray(A);
    LBP_Terrain{i} = LBP(A);
end

figure
subplot(131)
hold on;
cblue = {[0 0 1],[0 0.2 1], [0 0.4 1], [0 0.6 1]};
for i=1:4
    plot(LBP_Terrain{i},'color',cblue{i});
end

%

name_image = 'Metal';
LBP_Metal = cell(1,4);

for i = 1:4
    A = imread(strcat(rep, name_image,'.',num2str(i),'.bmp'));
    A = rgb2gray(A);
    LBP_Metal{i} = LBP(A);
end

subplot(132)
hold on;
cpink = {[1 0 1],[1 0.2 1], [1 0.4 1], [1 0.6 1]};
for i=1:4
    plot(LBP_Metal{i},'color',cpink{i});
end

%

name_image = 'Sand';
LBP_Sand = cell(1,4);

for i = 1:4
    A = imread(strcat(rep, name_image,'.',num2str(i),'.bmp'));
    A = rgb2gray(A);
    LBP_Sand{i} = LBP(A);
end

subplot(133)
hold on;
corange = {[1 0 0],[1 0.2 0], [1 0.4 0], [1 0.6 0]};
for i=1:4
    plot(LBP_Sand{i},'color',corange{i});
end

% distance computation
% SAD: sum of absolute differences
LBP = [LBP_Terrain,LBP_Metal,LBP_Sand];
dist = zeros(12,12);
parfor i=1:12
    X(i,:) = LBP{i}'; % for later K-means computation
    for j=1:12
        dist(i,j) = sum(abs(LBP{i}-LBP{j}));
    end
end

figure;
imagesc(dist);
colormap('gray');

% for confirmation, perform kmeans clustering
% labels 1-4, 5-8, 9-12 should be equal, respectively
label = kmeans(X,3,'replicates',5)'