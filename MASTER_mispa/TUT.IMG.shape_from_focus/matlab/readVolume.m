fname = 'volume.tif';
info = imfinfo(fname);
num_images = numel(info);

stack=zeros(info(1).Width, info(1).Height, num_images);
for k = 1:num_images
    A=imread(fname, k);
    % ... Do something with image A ...
    stack(:,:,k) = variance(A, 3);
end


function V=variance(A, N)
% size of the window
N = 3;
h = ones(N);

moyenne = 1/sum(N(:)) * conv2(A, h, 'same');
D2=(A-moyenne).^2;
% variance
V = conv2(D2, h, 'same');
end

