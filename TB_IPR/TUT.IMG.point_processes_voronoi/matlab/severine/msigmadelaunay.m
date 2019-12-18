function sol = msigmadelaunay( x,y )
%calcule la moyenne et l'écart type des aretes d'un graphe de delaunay
%  Detailed explanation goes here
TRI=delaunay(x,y);
d=[];
for i=1:length(TRI)
    d=[d;norm([x(TRI(i,1)),y(TRI(i,1))]-[x(TRI(i,2)),y(TRI(i,2))]); norm([x(TRI(i,1)),y(TRI(i,1))]-[x(TRI(i,3)),y(TRI(i,3))]) ;norm([x(TRI(i,2)),y(TRI(i,2))]-[x(TRI(i,3)),y(TRI(i,3))])];
end
mu=mean(d);
sigma=std(d);
sol=[mu,sigma];

end

