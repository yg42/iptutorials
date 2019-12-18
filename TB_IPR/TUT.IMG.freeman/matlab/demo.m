%% Tutorial - Freeman code

%% 0 - Clean

clear all;close all;clc

%% 1 - Contours detection

% create an object
A=zeros(20,20);
A(5:14,10:17)=1;A(2:18,12:16)=1;%A(9,9)=1; % probleme dans ce cas en V4
%A(12:14,12:14)=1;
figure;
subplot(131);imshow(A)

% compute the contours
contours8 = bwperim(A, 4);
contours4 = bwperim(A, 8);

% % do not use the edge function in order to get a 4 or 8 connectivity
se4=strel('disk',1);
% contours8=A-imerode(A,se4);
se8=strel('square',3);
% contours4=A-imerode(A,se8);
% subplot(132);
% imshow(contours8); title('8 connectivity')
% subplot(133);
% imshow(contours4); title('4 connectivity')

%% 2 - Freeman code
[r0,c0]=firstPoint(A)
z4=freeman(contours4,r0,c0,4);
z8=freeman(contours8,r0,c0,8);

%% 3 - Normalization

d8=codediff(z8,8);
shapenumber8=minmag(d8);

% checking result for a different starting point
r0=9;c0=10;
z8=freeman(contours8,r0,c0,8);
d8=codediff(z8,8);
shapenumber8_startchanged=minmag(d8);
disp('* validation test for starting point changed')
if sum(abs(shapenumber8-shapenumber8_startchanged))
    disp('   error: different freeman code')
else
    disp('   OK: same freeman code')
end

% checking for a rotation of 270 deg
contours8rot=contours8';
figure;imshow(contours8rot);

[r0,c0]=firstPoint(contours8rot);
z8=freeman(contours8rot,r0,c0,8);
d8=codediff(z8,8);
shapenumber8_rotated=minmag(d8);
disp('* validation test after rotation')
if sum(abs(shapenumber8-shapenumber8_startchanged))
    disp('   error: different freeman code')
else
    disp('   OK: same freeman code')
end

%% 4 - Geometric Description

% Perimeter for connectivity 8
% evaluates the number of diagonals
nb_diag=mod(z8, 2);
nb_diag=sum(nb_diag(:));
nb = length(z8)-nb_diag;
perimeter = nb_diag * sqrt(2) + nb
stats = regionprops(A,'Perimeter')

% area for connectivity 8
area=0;
B=0;   
lutB=[0 1 1 1 0 -1 -1 -1];
for i=1:length(z8)
   lutArea=[-B -(B+0.5) 0 (B+0.5) B (B-0.5) 0 -(B-0.5)];
   area=area+lutArea(z8(i)+1);
   B=B+lutB(z8(i)+1);
end
disp(['Area by freeman code: ' num2str(area)]);
disp(['Number of pixels: ' num2str(sum(A(:)))])
