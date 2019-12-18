%% Tutorial topological description

%% 0 - Clean

clear all;close all;clc

%% 1 - Connexity number

% reading image
A=imread('test.bmp');
A=double(A(:,:,1));
A=A/255;
figure;
x=[2 5];
X=A(x(1)-1:x(1)+1,x(2)-1:x(2)+1);
subplot(1,2,1);viewImage(A);title('original image');
subplot(1,2,2);viewImage(X);title('3x3 window centered on the point (2,5)');
% connectivity numbers
[nc1,nc2,nc3]=nc(X)

%% 2 - Points classification

nc_type(X)
% for the whole image
[m,n]=size(A);
B=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        if A(i,j)> 0
            X=A(i-1:i+1,j-1:j+1);
            B(i,j)=nc_type(X);
        end
    end
end
disp('Point classification :');
disp('1 : isolated points');
disp('2 : 2-junction points');
disp('3 : 3-junction points');
disp('4 : 4-junction points');
disp('5 : border points');
disp('6 : end points');
disp('7 : interior points');

subplot(3,3,1);viewImage(A);title('original image');
subplot(3,3,2);viewImage(B);title('point classification');
subplot(3,3,3);viewImage(B==5);title('border points');
subplot(3,3,4);viewImage(B==7);title('interior points');
subplot(3,3,5);viewImage(B==1);title('isolated points');
subplot(3,3,6);viewImage(B==6);title('end points');
subplot(3,3,7);viewImage(B==2);title('2-junction points');
subplot(3,3,8);viewImage(B==3);title('3-junction points');
subplot(3,3,9);viewImage(B==4);title('4-junction points');

