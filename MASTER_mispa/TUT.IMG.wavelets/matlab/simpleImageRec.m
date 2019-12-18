function A = simpleImageRec(C)
% wavelet reconstruction of an image described by the wavelet coefficients C 

% The Haar wavelet is used
ld = [1 1];
hd = [-1 1];
lr = ld/2;
hr = -hd/2;

nb_scales = length(C)-1;
A = C{nb_scales+1};
for i=nb_scales:-1:1
    A = recWave2D(A, C{i}{1}, C{i}{2}, C{i}{3}, lr, hr);
end
