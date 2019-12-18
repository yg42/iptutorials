%% Tutorial Image Characterization

%% 0 - Cleaning

clear all;close all;clc

%% 1 - Perimeters
% load the images
I = imread('camel-5.png');
I=double(I)>0;
imshow(I)

% defines an orientation, computes the number of intercepts by convolution
h = [-1 1];
b = abs(conv2(double(I), h, 'same'));
n1 = sum(b(:))/2;

b = abs(conv2(double(I), h', 'same'));
n2 = sum(b(:))/2;

% diagonal orientations:
h = [1 0; 0 -1];
b = abs(conv2(double(I), h, 'same'));
n3 = sum(b(:))/2;
h = [0 1; -1 0];
b = abs(conv2(double(I), h, 'same'));
n4 = sum(b(:))/2;

% crofton evaluation and comparison
perim_Crofton = pi/4 * sum( [n1 n2 n3/sqrt(2) n4/sqrt(2)])

perim_usual = sum(sum(bwperim(I)))

%% 2 - Diameters

deg = 1:180;
for i = 1:length(deg)
   I2 = imrotate(I,deg(i),'nearest');
   I3 = sum(I2)>0;
   diameter(i) = sum(I3); 
end
diamFeret_min = min(diameter)
diamFeret_max = max(diameter)
diamFeret_mean = mean(diameter)

%% 3 - Circularity

I = zeros(1000,1000);
[X,Y] = meshgrid(1:1000,1:1000);
I = sqrt((X-500).^2+(Y-500).^2) < 400;

% defines an orientation, computes the number of intercepts by convolution
h = [-1 1];
b = abs(conv2(double(I), h, 'same'));
n1 = sum(b(:))/2;

b = abs(conv2(double(I), h', 'same'));
n2 = sum(b(:))/2;

% diagonal orientations:
h = [1 0; 0 -1];
b = abs(conv2(double(I), h, 'same'));
n3 = sum(b(:))/2;
h = [0 1; -1 0];
b = abs(conv2(double(I), h, 'same'));
n4 = sum(b(:))/2;

perim_Crofton = pi/4 * sum( [n1 n2 n3/sqrt(2) n4/sqrt(2)]);

perim_usual = sum(sum(bwperim(I)));

figure
imshow(I);

circ_Crofton = 4*pi*sum(I(:))/perim_Crofton^2
circ_usual = 4*pi*sum(I(:))/perim_usual^2

%% 4 - Convexity

I = imread('camel-5.png');
I = double(I)>0;

dim = size(I);
D1  = dim(1);
D2  = dim(2);

[Y,X] = find(I==1);
CH = convhull(X,Y);
XCH = X(CH);
YCH = Y(CH);
I_convhull = poly2mask(XCH,YCH,D1,D2);

figure
subplot(121);imshow(I);
subplot(122);imshow(I_convhull)

convexity = sum(I(:))/sum(I_convhull(:))
