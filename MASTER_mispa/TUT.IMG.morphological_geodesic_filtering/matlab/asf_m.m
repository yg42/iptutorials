function F = asf_m(I, order)
%
% Alternate Sequential Filter beginning by an opening
% I: original image
% order: order of the filter (number of loops)
% 
F = I;
for i=1:order
    se = strel('disk', i);
    F = imopen(imclose(F, se), se);
end
