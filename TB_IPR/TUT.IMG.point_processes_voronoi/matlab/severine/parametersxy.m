function [ad,rfh,vormoy,vorsigma,MSTmoy,MSTsigma] = parametersxy( x,y,couleur )
% contrairement à test1 cette fonction ne retourne pas les différents
% diagramme intermédiare, elle affiche directement les  paramètres
% caractéristiques de la distribution entrée en paramètre via les
% coordonnées de ses points
figure(6)
ad=AD(x,y);
rfh=RFH(x,y);
msigd=msigmadelaunay(x,y);
msigmst=msigmaMST(x,y);

%% Affichage du résultat

subplot(2,3,4)
axis([0 1 0 1]);
axis square;
hold on;
l=msigd(1);
c=msigd(2);
if couleur==1 
    plot(l,c,'r*');
end
if couleur==0
    plot(l,c,'b*');
end
if couleur==2
     plot(l,c,'g*');
end
if couleur==3
     plot(l,c,'y*');
end
if couleur==4
     plot(l,c,'black*');
end


xlabel('moyenne');
ylabel('Ecart-type');
hold on;
title('Delaunay parameters');
hold off

subplot(2,3,5)
axis([0 1 0 1]);
axis square;
hold on;

if couleur==1
   plot(ad,rfh,'r*');
end
if couleur==0
    plot(ad,rfh,'b*');
end
if couleur==2
    plot(ad,rfh,'g*');
end
if couleur==3
    plot(ad,rfh,'y*');
end
if couleur==4
    plot(ad,rfh,'black*');
end

xlabel('AD');
ylabel('RFH');
hold on;
title('Voronoi parameters');
hold off

subplot(2,3,6)
axis([0 1 0 1]);
axis square;
hold on;
l=msigmst(1);
c=msigmst(2);
if couleur==1  
    plot(l,c,'r*');
end
if couleur==4  
    plot(l,c,'black*');
end
if couleur==0
    plot(l,c,'b*');
end
if couleur==2
     plot(l,c,'g*');
end
if couleur==3
     plot(l,c,'y*');
end

xlabel('moyenne');
ylabel('Ecart-type');
hold on;
title('MST');
hold off
end


