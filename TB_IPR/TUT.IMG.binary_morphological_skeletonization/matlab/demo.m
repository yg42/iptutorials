%% Tutorial morphological skeletonization

%% Cleaning and reading image
clear all; close all; clc;

A=imread('mickey.bmp');

%% Hit-or-miss transformation
T=[1,1,1;0,1,0;-1,-1,-1];
B=hitormiss(A,T);
imwrite(~B,'hitormiss.png'); % inversion of intensities
figure;colormap gray;
subplot(121);imshow(A);
subplot(122);imshow(B);

%% Thinning and thickening
TT=cell(1,8);
TT{1}=[-1,-1,-1;0,1,0;1,1,1];
TT{2}=[0,-1,-1;1,1,-1;0,1,0];
TT{3}=[1,0,-1;1,1,-1;1,0,-1];
TT{4}=[0,1,0;1,1,-1;0,-1,-1];
TT{5}=[1,1,1;0,1,0;-1,-1,-1];
TT{6}=[0,1,0;-1,1,1;-1,-1,0];
TT{7}=[-1,0,1;-1,1,1;-1,0,1];
TT{8}=[-1,-1,0;-1,1,1;0,1,0];
% figure;colormap gray
% for i=1:8
% 	subplot(2,4,i);imagesc(TT{i});
% end

B=thinning(A,TT);
B=thinning(B,TT);
imwrite(B,'thinning.png');

C=1-thinning(1-A,TT);
C=1-thinning(1-C,TT);
imwrite(C,'thickening.png');

figure;colormap gray;
subplot(131);imshow(A);
subplot(132);imshow(B);
subplot(133);imshow(C);

%% Topological skeleton
B2=A;
B=~B2;
while (isequal(B,B2)~=1)
    B=B2;
    B2=thinning(B,TT);
end

figure
subplot(121);imshow(A);colormap gray
subplot(122);imshow(B);colormap gray
imwrite(~B, 'topological_skeleton.png'); % invert intensities

%% Morphological skeleton
S=zeros(size(A));
r=-1;
pred=true;
X = A;
se = strel('disk',1);
while pred
    r=r+1;
    XX = imerode(X,se);
    if sum(XX(:))==0
        pred=false;
    end
    S = max(S,(r+1)*(X-imdilate(XX,se)));
    X = XX;
end
imwrite(S<=0,'morphological_skeleton.png'); % invert intensities
figure
subplot(121);imshow(A);colormap gray
subplot(122);imshow(S>0,[]);colormap gray

% reconstruction
X = zeros(size(S));
n = max(S(:));
for r=0:n-1
    SS = S==(r+1);
    %in order to satisfy the property of homothetic structuring elements
    for k=1:r
        SS = imdilate(SS,se);
    end 
    X = max(X,SS);
end
figure;
subplot(121);imshow(A)
subplot(122);imshow(X);
isequal(A,X)

