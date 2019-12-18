function [crofton, p]=perimetres(I)
% Crofton perimeter and classical perimeter
%
% I : binary image
% crofton : Crofton perimeter
% p       : classical perimeter, regionprops

% classical perimeter
if (~islogical(I))
    perim = regionprops(I>100, 'Perimeter');
else
    perim = regionprops(I, 'Perimeter');
end
p = perim.Perimeter;

% crofton perimeter
% evaluated in 4 directions
% another method is presented in the tutorial on integral geometry
I=double(I);
inter = zeros(4,1);
for i=1:4
    I2=imrotate(I, 45*(i-1));
    h=[1 -1];
    I3=conv2(I2, h, 'same')>0;
    inter(i) = sum(I3(:));
end

% approximation of crofton perimeter in 4 directions of intercepts
crofton = pi/4*(inter(1)+inter(3) + (inter(2)+inter(4))/sqrt(2));
