%% Tutorial granulometry analysis

%% 0 - Clean up

clear all;close all;

%% 2 - Granulometry by morphological operations

% read image
A=imread('simulation.bmp');
A=logical(double(A)/255);
% visualisation image
figure;imshow(A);
title('Original simulated image');
% maximal size of structuring element
N=35;
% declaration of arrays
surface=zeros(N, 1);
nombre=zeros(N, 1);
% Openings and granulometry analysis
area0=sum(A(:));
nbre0=bweuler(A);
for i=0:N
   se = strel('disk', i, 0);
   C = imopen(A, se);
   C=imreconstruct(C,A);
   aire=sum(C(:))/area0*100;
   nbre=bweuler(C)/nbre0*100;
   surface(i+1)=aire;
   nombre(i+1)=nbre;
end
figure;
subplot(121);plot(0:N,surface,'-xr');title('Granulometry');%legend('en aire');
hold on; plot(0:N,nombre,'-xb');legend('area analysis','number analysis');
% finite differences
diff_surface = -diff(surface);
diff_nombre = -diff(nombre);
subplot(122);plot(0:N-1,diff_surface,'-xr');title('Finite differences');
hold on; plot(0:N-1,diff_nombre,'-xb');
legend('area analysis','number analysis');

%% 2 - Real applications
tic
% read image
B=imread('poudre.bmp');
% threshold
imSeuil=(B>74);
% holes filling
imHoles=imfill(imSeuil,'holes');
% small objects removal
se = strel('disk',1);
C = imopen(imHoles,se);
imBinaire=imreconstruct(C,imHoles);
% display results
figure;
subplot(121);imshow(B,[]);colormap('gray');title('Original image of sillicium');
subplot(122);imshow(imBinaire);colormap('gray');title('Segmented image');
imwrite(imBinaire, 'poudre_segmentation.png');

% granulometry
% maximal size
N=15;
% tableau des aires et des nombres
surface=zeros(N, 1);
nombre=zeros(N, 1);
% Openings and granulometry analysis
area0=sum(imBinaire(:));
nbre0=bweuler(imBinaire);
for i=0:N
   se = strel('disk', i, 0);
   C = imopen(imBinaire, se);
   C = imreconstruct(C,imBinaire);
   aire=sum(C(:))/area0*100;
   nbre=bweuler(C)/nbre0*100;
   surface(i+1)=aire;
   nombre(i+1)=nbre;

end
figure;
subplot(121);plot(0:N,surface,'-xr');title('Granulometry of silicium image');%legend('en aire');
hold on; plot(0:N,nombre,'-xb');legend('area analysis','number analysis');


% analysis of finite differences
diff_surface = -diff(surface);
diff_nombre = -diff(nombre);
subplot(122);plot(0:N-1,diff_surface,'-xr');title('Finite differences');
hold on; plot(0:N-1,diff_nombre,'-xb');
legend('area analysis','number analysis');
toc