function M = localAverage(intImg, i, j, h)
% sums the pixels on a square window of size 2h+1
% around (i,j)
% intImg: integral image
% i,j: center pixel
% h: radius of window (square)

% deal with borders
x1=max(2,i-h+1);
x2=min(size(intImg,1), i+h+1);

y1=max(2,j-h+1);
y2=min(size(intImg,2), j+h+1);

% size of domain
normalization = (x2-x1+1) * (y2-y1+1);
M = 1/normalization*(intImg(x2, y2) - intImg(i+1, y1) - intImg(x1, j+1) + intImg(x1, y1));
end