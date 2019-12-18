function sol = msigmaMST( x,y )
%retourne la moyenne et l'écart type des longueurs des aretes de l'arbre MST

TRI=delaunay(x,y);
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

d=[];
for i=1:length(MST)
    d=[d;norm([x(MST(i,1)),y(MST(i,1))]-[x(MST(i,2)),y(MST(i,2))])];
end
m=mean(d);
Sigma=std(d);
sol=[m,Sigma];

end
