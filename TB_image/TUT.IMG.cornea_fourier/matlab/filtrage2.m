 % pour faire un filtrage sur la TF
[X,Y]=meshgrid(1:size(F,1), 1:size(F,2));
Z=(X-size(F,1)).^2+(Y-size(F,2).^2);
F(Z<r^2)=0; % filtrage passe haut