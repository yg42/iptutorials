function [Z, T]=varianceSFF(filename, N)
% Computes SFF reconstruction by evaluating the variance as a focus measure
% filename: name of the ile that contains the stack of images
% N: size (diameter) of the window
% Z: altitudes (indices)
% T: texture
%
info = imfinfo(filename);
num_images = numel(info);

stackV=zeros(info(1).Height, info(1).Width, num_images);
stack =double(stackV);
for k = 1:num_images
    stack(:,:,k)=imread(filename, k);
    %imshow(stack(:,:,k), []);
    
    % ... Do something with image A ...
    stackV(:,:,k) = variance(double(stack(:,:,k)), N);
end

% method for reconstructing the image and the texture from the stack of
% indices
[~, Z] = max(stackV, [], 3);
Z = uint8(Z);
T = double(zeros(size(stack,1), size(stack,2)));
for i=1:size(T, 1)
    for j=1:size(T,2)
        T(i,j) = stack(i,j,Z(i,j));
    end
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