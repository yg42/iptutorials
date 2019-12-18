function [ad,rfh,vormoy,vorsigma,MSTmoy,MSTsigma] = parameters( I )
% renvoie les paramètres caractéristiques de la distribution d'une image
% binaire
%  I: imagee binaire


% initialisation des vecteurs x et y
k=1;
S=size(I);
for i=1:S(1)
    for j=1:S(2)
        if I(i,j)==1
            x(k)=i;
            y(k)=j;
            k=k+1;
        end
    end
end

%calcul des paramètres

ad=AD(x,y)
rfh=RFH(x,y)
msigd=msigmadelaunay(x,y)
msigmst=msigmaMST(x,y)

%% Affichage du résultat

subplot(1,3,1)
axis([0 2 0 2]);
axis square
hold on;
l=msigd(1);
c=msigd(2);
plot(l,c,'r*');
text(0,-2,'m ->')
text(0.75,-2,num2str(l))
text(0,-1,'mu ->')
text(0.75,-1,num2str(c))
xlabel('moyenne');
ylabel('Ecart-type');
hold on;
title('Delaunay parameters');
hold off

subplot(1,3,2)
axis([0 1 0 1]);
axis square
hold on;
plot(ad,rfh,'r*');
text(0,-1,'AD ->')
text(0.5,-1,num2str(ad))
text(0,-0.5,'RFH ->')
text(0.5,-0.5,num2str(rfh))
xlabel('AD');
ylabel('RFH');
hold on;
title('Voronoi parameters');
hold off

subplot(1,3,3)
axis([0 2 0 2]);
axis square
hold on;
l=msigmst(1);
c=msigmst(2);
plot(l,c,'r*');
text(0,-2,'m ->')
text(0.75,-2,num2str(l))
text(0,-1,'mu ->')
text(0.75,-1,num2str(c))
xlabel('moyenne');
ylabel('Ecart-type');
hold on;
title('MST');
hold off
end


