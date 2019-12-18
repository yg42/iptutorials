function [Z, T]=varianceTenengradSFF(fichier, N)
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
    stackF(:,:,k) = varianceTenengrad(double(stack(:,:,k)), N);
end

[~, Z] = max(stackF, [], 3);
Z = uint8(Z);
T = double(zeros(size(stack,1), size(stack,2)));
for i=1:size(T, 1)
    for j=1:size(T,2)
        T(i,j) = stack(i,j,Z(i,j));
    end
end


    function vt=varianceTenengrad(A, N)
        h1 = [1 2 1; 0 0 0; -1 -2 -1];
        h2 = h1';
        ML = sqrt(conv2(A, h1, 'same').^2 + conv2(A, h2, 'same').^2);
        
        vt=variance(ML, N);
    end

    function V=variance(A, N)
        % A: single image
        % N: size of the window
        h = ones(N);
        
        moyenne = (1/N^2) * conv2(A, h, 'same');
        D2=(A-moyenne).^2;
        % variance
        V = conv2(D2, h, 'same');
    end

figure();
subplot(1,2,1); imshow(Z,[]); title('altitudes');
subplot(1,2,2); imshow(T,[]); title('textures');
end