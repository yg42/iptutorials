%% Nettoyage
clc;clear all;close all;

%% Points initiaux
rand('state',0);
x = rand(1,15);
y = rand(1,15);
subplot(221);
axis([0 1 0 1]);
plot(x,y,'r*');
axis square
for i=1:length(x)
text(x(i)+0.01,y(i)+0.01,int2str(i))
hold on;
end
title('initial points');

%% Triangulation de Delaunay
TRI = delaunay(x,y); % retourne les faces (triangles)
subplot(223),...
triplot(TRI,x,y)
axis([0 1 0 1]);
axis square
hold on;
plot(x,y,'r*');
for i=1:length(x)
text(x(i)+0.01,y(i)+0.01,int2str(i))
hold on;
end
title('Delaunay triangulation');
hold off

%% Diagramme de Vorono�
[vx, vy] = voronoi(x,y,TRI);
subplot(222),...
plot(x,y,'r*',vx,vy,'b-'),...
hold on;
for i=1:length(x)
text(x(i)+0.01,y(i)+0.01,int2str(i))
hold on;
end
axis([0 1 0 1]);
axis square
plot(x,y,'r*');
title('Voronoi diagram');

%% Minimum spanning tree
% identification des edges
EDGE=[];
for i=1:size(TRI,1)
    EDGE=[EDGE;TRI(i,1) TRI(i,2);TRI(i,2) TRI(i,3);TRI(i,1) TRI(i,3)];
end

% suppression des doublons
EDGE2=[EDGE(1,:)];
for i=2:size(EDGE,1)
    validite=1;
    v1=EDGE(i,:);
    for j=1:size(EDGE2,1)
        v2=[EDGE2(j,1),EDGE2(j,2)];
        [v1;v2];
        if (v1(1)==v2(1)) && (v1(2)==v2(2))
            validite=0;break;
        end
        if (v1(2)==v2(1)) && (v1(1)==v2(2))
            validite=0;break;
        end
    end
    if validite
        EDGE2=[EDGE2;v1];
    end
end

% poids des edges
PV=[EDGE2,zeros(size(EDGE2,1),1)];
for i=1:size(PV,1)
    PV(i,3)=norm([x(PV(i,1)),y(PV(i,1))]-[x(PV(i,2)),y(PV(i,2))]);
end
PV;

% construction minimum spanning tree
[w,T]=kruskal(PV);
for i=1:size(T,1)
    T(i,i:size(T,1))=0;
end

% edges du MST
[r,c]=find(T==1);
MST=[r,c];
subplot(224)
plot(x,y,'r*');
for i=1:size(MST,1)
   plot([x(r(i,1)),x(c(i,1))],[y(r(i,1)),y(c(i,1))]); 
   hold on;
end
hold on;
plot(x,y,'r*');
for i=1:length(x)
text(x(i)+0.01,y(i)+0.01,int2str(i))
hold on;
end  
title('Minimum spanning tree');
axis([0 1 0 1]);
axis square;