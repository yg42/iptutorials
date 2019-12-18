function S=simuProjection(I, theta)
% simulation of the generation of a sinogram
% I : original image (phantom for example)
% theta: angles of projection

taille=size(I);

S=zeros(taille(2),length(theta));


for i=1:length(theta)-1,
    image1=imrotate(I, theta(i), 'bilinear', 'crop');
  
    S(:,i)=sum(image1');
end
