function viewImageSpectre(I,S)
% display image
% I is the original image
% S is the Fourier Transform of I (complex image)

figure;
colormap gray;
subplot(1,3,1);
imshow(I,[]);
% visu spectre de phase
subplot(1,3,3);
Im=angle(S);
imshow(Im,[]);
% visu spectre d'amplitude
subplot(1,3,2);
Ia=abs(S);
Ia2=log(1+Ia);
imshow(Ia2,[]);