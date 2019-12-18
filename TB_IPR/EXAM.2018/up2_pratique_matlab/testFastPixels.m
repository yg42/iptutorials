function testFastPixels(f)

W = randi(10, 7, 7);

indices_x = [4, 5, 6, 7, 7, 7, 6, 5, 4, 3, 2, 1, 1, 1, 2, 3];
indices_y = [1, 1, 2, 3, 4, 5, 6, 7, 7, 7, 6, 5, 4, 3, 2, 1];

M = 7;
idx = M * (indices_x - 1) + indices_y;

w0=W(idx);

w = f(W);
if size(w,1)==16
    w = w';
end
if w == w0
    disp('OK')
else
    disp('ERREUR');
    w
    w0
    w(end:-1:1)
end