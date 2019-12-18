%% CORRECTION  follicles segmentation

%% 0 - Cleaning

clear all;close all;

%% 1 - Vascularisation

% read image
A = imread('follicule.bmp');
% visualisation image
figure;imagesc(A);title('Original image');
% Antrum segmentation 
B = A(:,:,3);
antrum = (B>220);
antrum = bwselect(antrum,300,300,8);
antrum = imfill(antrum,'holes');
figure;colormap gray;imagesc(antrum);title('Antrum');

% Theca segmentation
se = strel('disk',40);
theque = imdilate(antrum,se);
theque = theque - antrum;
figure;colormap gray;imagesc(theque);title('Thèque');
% extraction vascularisation
vascularisation = (B<140);
vascularisation = min(vascularisation,theque);
figure;colormap gray;imagesc(vascularisation);title('Vascularisation');

%% 2 - Granulosa cells

%%
% * non robust solution :
dil = 1-imclose(vascularisation,strel('disk',10));
dil = bwselect(dil, 300, 300, 4);
granulosa = dil - antrum;
figure;colormap gray;imagesc(granulosa);title('Cellules de granulosa');
%%
% * solution plus robuste : modèles déformables


%% 3 - Quantification

all = antrum + 2*granulosa + 3*vascularisation;
figure;colormap jet;imagesc(all);title('Antrum, vascularisation et cellules de granulosa');
follicule = antrum + theque;
q_vascularisation = bwarea(vascularisation)/bwarea(follicule)
q_granulosa = bwarea(granulosa)/bwarea(follicule)
