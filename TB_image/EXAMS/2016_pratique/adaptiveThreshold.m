function B=adaptiveThreshold(I, h, percent)
% function adaptive thresholding, from bradley
% I: image
% h: size of neighborhood
% percent: percentage of threshold (<=1)

% compute integral image
intImg = int_image(I);

B = zeros(size(I));
LA = zeros(size(I));
LA = filtre_moyenneur(I, h);
for i=1:size(I,1)
    for j=1:size(I,2)
        %LA(i,j) = localAverage(intImg, i, j, h);
        if (I(i,j)>= LA(i,j)*(1-percent))
            B(i,j) = 0;
        else
            B(i,j) = 255;
        end
    end
end
%figure
%imshow(LA,[])

    function M = filtre_moyenneur(I, h)
        H = fspecial('average', h);
        M = imfilter(I, H);
    end


end
