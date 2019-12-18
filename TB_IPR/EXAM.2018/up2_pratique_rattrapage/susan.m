%% SUSAN corner detector

%I = imread('square.png'); I = double(I(:,:,1));
I = double(imread('sweden_road.png'));
I = 255*double(I>100);
W = 3;
t = 3;
g = 20;
N = 255*ones(size(I));
for i=1+W:size(I, 1)-W
    for j=1+W:size(I,2)-W
        w = I(i-W:i+W, j-W:j+W);
        
        N(i,j) = sum(sum(exp(-((w-I(i,j))/t).^6)));
    end
end
imshow(N, []);
corners = max(zeros(size(I)), g-N);
figure
imshow(corners);