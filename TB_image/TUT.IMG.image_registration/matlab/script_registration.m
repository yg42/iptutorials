%% Image Registration tutorial

%% 0 - Cleaning

clear all;close all; clc;

%% 1 - Reading and visualization of images

A = double(imread('brain1.bmp'));
B = double(imread('brain2.bmp'));

figure
subplot(131);viewImage(A);title('moving image');
subplot(132);viewImage(B);title('source image');
subplot(133),imshowpair(A,B);title('superimposition');

%% for saving fusion image
figure; imshowpair(A,B);
frame = getframe();
imageFusion = frame2im(frame);
imwrite(imageFusion,'imageFusionReg.png');

%% 2 - Manual extraction of corner points

[A_points, B_points] = cpselect(A/255,B/255, 'Wait', true);

%% 3 - Transformation estimation

[R, t] = reg(A_points,B_points);
angle_rotation = acos(R(1,1))*180/pi*sign(R(1,2));
xform = [R,[0;0];t',1];
tform_rigid = maketform('affine',xform);
%(Matlab solution)
%tform_rigid=cp2tform(A_points,B_points,'nonreflective similarity');

Atrans = imtransform(A,tform_rigid,'nearest','XData',[1,size(A,2)],'YData',[1,size(A,1)]);

figure
subplot(221);viewImage(A);title('moving image');
subplot(222);viewImage(B);title('source image');
subplot(223);imshowpair(A,B);title('without registration')
subplot(224),imshowpair(Atrans,B);title('with registration');

%% 3 - Automatic extraction of corner points

A_coins = Harris(A,5);
[rA,cA] = find(A_coins);
B_coins = Harris(B,5);
[rB,cB] = find(B_coins);

figure
subplot(121);viewImage(A);title('moving image');
hold on; plot(cA,rA,'xr')
subplot(122);viewImage(B);title('source image');
hold on; plot(cB,rB,'ob');

%% 4 - ICP-based image registration

dataA = [cA,rA];
dataB = [cB,rB];

loop = 0;
data2A = dataA;
data2B = zeros(size(data2A));
tform=maketform('affine',[1 0 0;0 1 0;0 0 1]);

while loop < 3
    [corr,D] = dsearchn(dataB, data2A);
    for j = 1:length(corr)
        data2B(j,:) = dataB(corr(j),:);
    end
    
    [R_loop, t_loop] = reg(data2A, data2B);
    tform_loop = maketform('affine',[R_loop,[0;0];t_loop',1]);
    %(Matlab solution)
    %tform_loop=cp2tform(data2A,data2B,'nonreflective similarity');
    [X,Y]=tformfwd(tform_loop,data2A(:,1),data2A(:,2));
    data2A=[X,Y];
               
    tform=maketform('composite',tform_loop,tform);

    loop=loop+1;
end

Atrans = imtransform(A,tform,'nearest','XData',[1,size(A,2)],'YData',[1,size(A,1)]);

figure
subplot(221);viewImage(A);title('moving image');
hold on; plot(cA,rA,'xr')
subplot(222);viewImage(B);title('source image');
hold on; plot(cB,rB,'ob');
subplot(223),imshowpair(A,B);title('without registration')
hold on; plot(cB,rB,'ob');
hold on; plot(cA,rA,'xr')
subplot(224),imshowpair(Atrans,B);title('with registration')
hold on; plot(cB,rB,'ob');
hold on; plot(data2A(:,1),data2A(:,2),'xr')


