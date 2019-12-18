function [Z, T]=modifiedLaplacianSFF(fichier, N)
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
    stackF(:,:,k) = modifiedLaplacian(double(stack(:,:,k)), N);
end

[~, Z] = max(stackF, [], 3);
Z = uint8(Z);
T = double(zeros(size(stack,1), size(stack,2)));
for i=1:size(T, 1)
    for j=1:size(T,2)
        T(i,j) = stack(i,j,Z(i,j));
    end
end


    function SML=modifiedLaplacian(A, N)
        h1 = [0 0 0; -1 2 -1; 0 0 0];
        h2 = h1';
        ML = abs(conv2(A, h1, 'same')) + abs(conv2(A, h2, 'same'));
        
        h = ones(N);
        SML = conv2(ML, h, 'same');
    end

figure();
subplot(1,2,1); imshow(Z,[]); title('altitudes');
subplot(1,2,2); imshow(T,[]); title('textures');
end