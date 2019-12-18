function [Z, T]=tenengradSFF(fichier, N)
% fonction qui calcule le SFF par la méthode du laplacien modifié
% Z: contient les altitudes (indices)
% T: contient la texture
%
% fichier: nom du fichier image (stack tif)
info = imfinfo(fichier);
num_images = numel(info);

% pile représentant la mesure de focus
stackF=zeros(info(1).Height, info(1).Width, num_images);

% pile de l'image
stack =double(stackF);
for k = 1:num_images
    stack(:,:,k)=imread(fichier, k);
    % ... Do something with image A ...
    stackF(:,:,k) = tenengrad(double(stack(:,:,k)), N);
end

[~, Z] = max(stackF, [], 3);
Z = uint8(Z);
T = double(zeros(size(stack,1), size(stack,2)));
for i=1:size(T, 1)
    for j=1:size(T,2)
        T(i,j) = stack(i,j,Z(i,j));
    end
end

    function T=tenengrad(A, N)
        % A: single image
        Sx = fspecial('sobel');
        Gx = imfilter(double(A), Sx, 'replicate', 'conv');
        Gy = imfilter(double(A), Sx', 'replicate', 'conv');
        T = Gx.^2 + Gy.^2;
        
        h = ones(N)/N^2;
        T = imfilter(T, h);
    end

figure();
subplot(1,2,1); imshow(Z,[]); title('altitudes');
subplot(1,2,2); imshow(T,[]); title('textures');
end