function C=cercle(fs,f)
% Generates an image with aliasing effect
% fs: sample frequency
% f : signal frequency

% time sampling
t=0:1/fs:1;

C=zeros(size(t,2));
for i=1:size(t,2);
    for j=1:size(t,2);
        C(i,j)=sin(2*pi*f*sqrt(t(i)^2+t(j)^2));
    end
end
