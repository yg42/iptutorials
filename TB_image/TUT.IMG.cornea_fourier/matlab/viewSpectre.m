function viewSpectre(S)

figure;
colormap gray;
subplot(1,2,2);
Im=angle(S);

viewImage(Im);

subplot(1,2,1);
Ia=abs(S);
Ia2=log(1+Ia); 
viewImage(Ia); 