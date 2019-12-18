%% SOLUTION TUTORIAL PDEs

%% 0 - Cleaning
clc; clear all; close all;

%% 1 - Linear diffusion

% reading image
I = imread('cerveau.bmp');
I = double(I)/255;

% linear diffusion process
dt = 0.05;
Ildiff10 = linearDiffusion(I,10,dt);
Ildiff50 = linearDiffusion(I,50,dt);

imwrite(Ildiff10, 'ld_10.png');
imwrite(Ildiff50, 'ld_50.png');

% visualization
figure
title('Linear diffusion')
subplot(131);imshow(I);
subplot(132);imshow(Ildiff10, []);
subplot(133);imshow(Ildiff50, []);

%% 2 - Nonlinear diffusion

% nonlinear diffusion process
dt = 0.05;
Inldiff10 = nonlinearDiffusion(I,10,0.1,dt);
Inldiff100 = nonlinearDiffusion(I,100,0.1,dt);

imwrite(Inldiff10, 'nld_10.png');
imwrite(Inldiff100, 'nld_100.png');

% visualization
figure
subplot(131);imshow(I);
subplot(132);imshow(Inldiff10);
subplot(133);imshow(Inldiff100);

%% 3 - Degenerate diffusion

% illustrates shock problems
dt = 0.02;
[Ieroshock20,Idilshock20] = morphologicalDiffusion2(I,20,dt);
[Ieroshock50,Idilshock50] = morphologicalDiffusion2(I,50,dt);
imwrite(Ieroshock50, 'Ieroshock50.png');
imwrite(Idilshock50, 'Idilshock50.png');
imwrite(Ieroshock20, 'Ieroshock20.png');
imwrite(Idilshock20, 'Idilshock20.png');

% morphological diffusion process
dt = 0.02;
[Ierodiff20,Idildiff20] = morphologicalDiffusion(I,20,dt);
[Ierodiff50,Idildiff50] = morphologicalDiffusion(I,50,dt);

imwrite(Ierodiff50, 'Ierodiff50.png');
imwrite(Idildiff50, 'Idildiff50.png');
imwrite(Ierodiff20, 'Ierodiff20.png');
imwrite(Idildiff20, 'Idildiff20.png');

% visualization
figure
subplot(231);imshow(I);
subplot(232);imshow(Idildiff20);
subplot(233);imshow(Idildiff50);
subplot(235);imshow(Ierodiff20);
subplot(236);imshow(Ierodiff50);

% tests
figure
SE = strel('disk', 1);
imshow(imdilate(I, SE), []);
imwrite(imdilate(I, SE), 'dilation.png');
