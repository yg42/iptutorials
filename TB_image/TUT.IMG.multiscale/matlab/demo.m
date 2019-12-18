%% CORRECTION Tutorial multiscale analysis


%% 1 - Decomposition et reconstruction

% 4 levels are used
A=imread('cerveau.bmp');
A=double(A);
[pyrG, pyrL] = LaplacianPyramidDecomposition(A, 3);
figure
subplot(4,2,1);viewImage(A);title('image originale : 0');
subplot(4,2,3);viewImage(pyrG{2});title('decomposition : 1');
subplot(4,2,2);viewImage(pyrL{1});title('erreur : 0');
subplot(4,2,5);viewImage(pyrG{3});title('decomposition : 2');
subplot(4,2,4);viewImage(pyrL{2});title('erreur : 1');
subplot(4,2,7);viewImage(pyrG{4});title('decomposition : 3');
subplot(4,2,6);viewImage(pyrL{3});title('erreur : 2');

% save images
for i=1:3
    imwrite(uint8(pyrG{i+1}), ['pyrG' num2str(i+1) '.png']);
    imwrite(uint8(pyrL{i}), ['pyrL' num2str(i) '.png']);
end

%% 2 - Pyramidal reconstruction

% with all the details
Arec= LaplacianPyramidReconstruction(pyrL);
figure
subplot(2,1,1);viewImage(Arec);title('reconstruction');
subplot(2,1,2);viewImage(A); title('original image');
erreur=abs(A-Arec);
disp('mean error per pixel:')
mean(erreur(:))

% without the details
for i=1:3
    pyrL{i} = zeros(size(pyrL{i}));
end
Arec2 = LaplacianPyramidReconstruction(pyrL);
imwrite(uint8(Arec2), 'nodetails.png');
figure
subplot(212);viewImage(Arec2);title('Reconstruction, no details');
subplot(211);viewImage(A);title('Original image');
erreur=abs(A-Arec2);
disp('mean error of the reconstruction without the details:')
mean(erreur(:))

%% 3 - Multiscale filtering

% scale-space decomposition
k=3;
ss=cell(2,k);
for i=1:k
    se = strel('disk',i);
    ss{1,i}=imdilate(A,se);
    ss{2,i}=imerode(A,se);
end
figure
subplot(241);viewImage(A);title('Original image');
subplot(242);viewImage(ss{1,1});title('dilatation : 1');
subplot(243);viewImage(ss{1,2});title('dilatation : 2');
subplot(244);viewImage(ss{1,3});title('dilatation : 3');

subplot(246);viewImage(ss{2,1});title('erosion : 1');
subplot(247);viewImage(ss{2,2});title('erosion : 2');
subplot(248);viewImage(ss{2,3});title('erosion : 3');

for i=1:3
    imwrite(uint8(ss{1,i}), ['pyrdil' num2str(i) '.png']);
    imwrite(uint8(ss{2,i}), ['pyrero' num2str(i) '.png']);
end

% KB

sskb=cell(1,k+1);
sskb{1, 1} = A;
r  = 5;
for i=2:k+1
   sskb{1,i}=kb(sskb{1,i-1}, r);
end

figure
subplot(142);viewImage(sskb{1,2});title('KB : 1');
subplot(143);viewImage(sskb{1,3});title('KB : 2');
subplot(144);viewImage(sskb{1,4});title('KB : 3');
subplot(141);viewImage(A);title('Original image');
for i=2:k+1
    imwrite(uint8(sskb{1,i}), ['mkb' num2str(i-1) '.png']);
end



