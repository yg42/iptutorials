function [res, n1, n2] = isFastCorner(I, i, j, W, t, nt)
% verifies if a point of coordinates (i,j) in image I is a FAST corner
% W is the window radius
% t is the threshold value
% nt is the minimum number of pixel to considere a corner, usually 12

w= I(i-W:i+W, j-W:j+W);
C1 = w > I(i,j)+t;
C2 = w < I(i,j)-t;

indices_x = [4, 5, 6, 7, 7, 7, 6, 5, 4, 3, 2, 1, 1, 1, 2, 3];
indices_y = [1, 1, 2, 3, 4, 5, 6, 7, 7, 7, 6, 5, 4, 3, 2, 1];

M = 2*W+1;
idx = M * (indices_x - 1) + indices_y;

n1 = countContiguousOnes(C1(idx));
n2 = countContiguousOnes(C2(idx));

if ((n1>=nt) || (n2>=nt))
    res = 1;
else
    res = 0;
end
end

