% classic measurements
%% cleaning
clc;
clear all;
close all;

%% classical measurements

%% Point probes
A=double(imread('disks.bmp')/255);

% Points where the measures are performed
nbPoints=1000;
x = randi(size(A,1), nbPoints, 1);
y = randi(size(A,2), nbPoints, 2);

% Do the measures
probes=0;
for i=1:nbPoints
    if A(x(i), y(i)) == 1
        probes = probes + 1;
    end
end

% the area of the objects can be measured by the ratio of probes/nbPoints
c = probes/nbPoints;
disp(['ratio probes/nbPoints PP: ' num2str(c)])

r = bwarea(A)/(size(A,1) * size(A,2));
disp(['real measurement AA: ' num2str(r)])

%% Line probes
% create an image with lines
probe=zeros(512,512);
probe(20:50:end-20,20:end-20)=1;
imshow(probe);
lines=probe.*A;

% detect number of segments
% couldnt we use bwlabel ?
points=abs(conv2(lines,[1 -1 0], 'same'));

% this value is highly dependant on the value of the perimeter, which vary
% a lot depending on implementations.
lpa=[sum(points(:))/sum(lines(:))*pi/2, sum(sum(bwperim(A)))/bwarea(A)];

disp(['pi*PL/2: ' num2str(lpa(1))]);
disp(['LA: ' num2str(lpa(2))]);

%% 3D spheres 
% Area fraction
spheres = load('spheres.mat');
VV = sum(spheres.A(:)) / (size(spheres.A,1) * size(spheres.A,2) * size(spheres.A,3));
probe = zeros(size(spheres.A));
probe(10:50:end-10, 10:end, 10:end) = 1;

s = sum(probe(:));
probe = probe .* spheres.A;
AA= sum(probe(:)) / s;
disp(['VV=' num2str(VV)])
disp(['AA=' num2str(AA)])
