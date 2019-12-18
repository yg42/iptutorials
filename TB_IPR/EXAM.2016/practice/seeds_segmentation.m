close all

%% segmentation of 3 classes of image seeds
I = imread('seeds.png');
bw = I > 125;
bw = imfill(bw, 'holes');
imshow(bw);

[L, n] = bwlabel(bw, 8);
figure, imshow(L,[]);
stats = regionprops(L, 'Eccentricity', 'Area');
ecc = extractfield(stats, 'Eccentricity');
figure, histogram(ecc,20);
area = extractfield(stats, 'Area');
figure, histogram(area, 30); title('Area');

rondes = ecc > .7;
grosses = area > 1900;
petites = area < 20;

%% segmentation
R = zeros(size(L));
for i=1:length(ecc)
    if grosses(i)
        R(L==i) = 1;
    elseif rondes(i)
        R(L==i) = 2;
    else
        R(L==i) = 3;
    end
    if petites(i)
        R(L==i) = 0;
    end
end
figure
imshow(R,[])
resultat = ind2rgb(uint8(R), lines(4));
%imshow(resultat);
imwrite(resultat, 'segmentation.png');

%% count the number of grains of each type
for i=1:3
    [~,n] = bwlabel(R==i, 8);
    disp(n)
end
% resultats: 24, 30, 38