function granulometry(fileName)
% fileName: name of the image file

I = imread(fileName);

SE = strel('disk', 10);
E = imerode(I, SE);
imshow(E);

% compute number of elements
[L, n] = bwlabel(E);
disp([num2str(n) ' disks found']);

% perform some granulometry
T = 10:50;
nb=zeros(length(T), 1);
for t=1:length(T)
    SE = strel('disk', T(t));
    E = imerode(I, SE);
    [~, nn] = bwlabel(E);
    nb(t) = nn;
end
plot(T, nb);
title('Granulometry: number of objects')
xlabel('Size of element')

% 2 classes
% take the finite difference
d = diff(nb);
hold on
plot(T(1:end-1), abs(d));

% result: for t=20, we count the number of objects in the second class
% corresponding to the total number minus the number of objects in the
% first class
index = find(T==20, 1);
disp([num2str(nb(index)) ' objects in the 2nd class'])
disp([num2str(n-nb(index)) ' objects in the 1st class'])

