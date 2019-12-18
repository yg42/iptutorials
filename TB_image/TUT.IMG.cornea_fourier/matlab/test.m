close all

% calcul de la TF d'un pavage carré

N = 11;
C = ones(2^N);
T = 1:2^N;
C (mod(T,25)==0, :) =0 ;
C (:, mod(T,25)==0) = 0;

C = imrotate(C, 45, 'nearest');

imshow(C);
figure()

TFC = fftshift(fft2(C));
imshow(log(1+abs(TFC)), []);
figure();
t = -2^(N-1):2^(N-1)-1;
f = 1./t;
plot(log(1+abs(TFC(2^(N-1), :))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lignes

N = 11;
L = zeros(2^N);
T = 1:2^N;
L (mod(T,25)==0, :) = 1 ;
imshow(L)

figure()
TFL = fftshift(fft2(L));
imshow(abs(TFL), []);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hexagones
% Generate hexagonal grid
N=43;
a = 25;
Rad3Over2 = sqrt(3) / 2;
[X Y] = meshgrid(1:a:1+a*N);
n = size(X,1);
X = round(Rad3Over2 * X);
Y = round(Y + repmat([0 a/2],[n,n/2]));


I = zeros(a*N/1.8);
[m, n] = size(I);
x = X(:);
y = Y(:);
for i = 1:length(x)
    if x(i) < m && y(i) < n
        %x(i)
        %y(i)
        I(x(i), y(i)) = 1;
    end
end

dm = bwdist(I);
L = watershed(dm);
W = L==0;

W = W(20:end-20, 20:end-20);
figure(); imshow(W,[]);

figure()
TFH = fftshift(fft2(W));
imshow(abs(TFH), []); title('TF hexagones')
imwrite(TFH, 'TFhexagons.png');

[L, n] = bwlabel(~W);
imwrite(~W, 'hexagonalGrid.png')

disp('mean density:')
n / (size(W,1) * size(W,2))

disp('frequency analysis')
fstar= sqrt(22^2+13^2) / size(W,1);
fstar^2
STATS = regionprops(L);

alpha = 2/(sqrt(3))
disp('fstar^2 / alpha')
fstar^2/alpha

disp('mean area (regionprops)')
1/mean([STATS.Area])

figure()
hist([STATS.Area], 200);
% Plot the hexagonal mesh, including cell borders
%[XV YV] = voronoi(X(:),Y(:)); 
%plot(XV,YV,'b-')
%axis equal, axis([0 400 0 400]), zoom on
