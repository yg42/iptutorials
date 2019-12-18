%% tutorial HISTO-BASED SEGMENTATION

%% 0 - Nettoyage

clear all;close all;clc

%% 1 - Manual threshold
% read image
A=imread('cells.bmp');
B=(A>80);
figure;
subplot(1,2,1);imshow(A);title('Original image');
subplot(1,2,2);imshow(B);title('Manual threshold');
imwrite(B, 'manual_threshold.png');

%% 2 - Automatic threshold
% read image
A=imread('cells.bmp');
% threshold determination
[s1,B]=autothresh(A);
s1
s2=graythresh(A);
s2=255*s2
C=(A>=s2);

% display results
figure;
subplot(2,2,1);imshow(A);title('Original image');
subplot(2,2,3);imshow(B);title('Automatic threshold');
subplot(2,2,4);imshow(C);title('Otsu threshold');

% write
imwrite(B, 'autotresh.png');
imwrite(C, 'otsu.png');

%% 3 - K-means clustering
% Generate 3 point clouds
n=100;
X=[generation(n,3,4); generation(n,0,0); generation(n,-5,-3)];

% Classification
[idx, ctrs] = kmeans(X, 3, 'replicates', 5);

% Display results
figure();
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b+','MarkerSize',12)
plot(X(idx==3,1),X(idx==3,2),'g*','MarkerSize',12)

legend('Cluster 1','Cluster 2','Cluster 3')


%% 4 - Color image segmentation
% Load image 
I=imread('Tv16.png');
I=double(I);
figure
imshow(I/255);

% Segmentation
nCouleurs = 3; % number of clusters
nLignes = size(I,1);
nCols   = size(I,2);

X = reshape(I, nLignes*nCols, 3);

[index centres] = kmeans(X, nCouleurs, 'distance', 'sqEuclidean', 'replicates', 3);

% 3D histogram (can be difficult to display, depending on machine)
id1=index==1;
id2=index==2;
id3=index==3;

figure
plot3(X(id1,1), X(id1,2), X(id1,3), 'r.')
hold on
plot3(X(id2,1), X(id2,2), X(id2,3), 'g.')
plot3(X(id3,1), X(id3,2), X(id3,3), 'b.')

% Label each pixel
labels = uint8(reshape(index, nLignes, nCols));
labels = imadjust(labels);

figure
subplot(121)
imshow(I/255);
subplot(122)
imshow(labels, []);

%% 5 - Useful functions
type generation.m;
type autothresh.m;
type viewImage.m;
