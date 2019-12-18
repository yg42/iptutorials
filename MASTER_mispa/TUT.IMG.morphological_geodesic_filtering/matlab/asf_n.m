function F = asf_n(I, order)
%
% Alternate Sequential Filter beginning by a closing
% I: original image
% order: order of the filter (number of loops)
% 
F = I;
for i=1:order
    se = strel('disk', i);
    F = imclose(imopen(F, se), se);
end
