function [ramlak] = RamLak(width)
% Ramlak filter of size width
% width must be odd
k=-width:1:width;
ramlak = zeros(size(k));

for indice = 1:length(k)
  if(k(indice)==0) % valeur du centre
     ramlak(indice)=pi/4;
  elseif(mod(k(indice),2)==1) % indices pairs
     ramlak(indice)=-1/(pi*k(indice)^2);
  else % indices impairs
     ramlak(indice)=0;
  end
end
