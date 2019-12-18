%% Affichage de 4 images sur la même fenêtre
%
% Prend en argument 4 images
function affichePar4(A, B, C, D)
figure();
subplot(2,2,1);
imshow(A);

subplot(2,2,2);
imshow(B);

subplot(2,2,3);
imshow(C);

subplot(2,2,4);
imshow(D);