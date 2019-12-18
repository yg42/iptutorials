function [ output_args ] = disamas( nbi,m1x, m1y,m2x, m2y,m3x, m3y,m4x, m4y,s1,s2,s3,s4,nbp )
%  calcule et affiche les parametres de nbi distributions formes de 4
%  distributions gausiennes de nbp chacune, centrees
%  en (mx,my)et d'ecart type si, sachant que les points hors [0,10] sont supprim�s
for i=1:nbi
    X=normrnd(m1x,s1,nbp,1);
 Y=normrnd(m1y,s1,nbp,1);
 X1=(0<X<10);
 X=X1.*X;
 Y1=(0<Y<10);
 Y=Y1.*Y;
 
 X2=normrnd(m2x,s2,nbp,1);
 Y2=normrnd(m2y,s2,nbp,1);
 X3=(0<X2<10);
 X2=X3.*X2;
 Y3=(0<Y2<10);
 Y2=Y3.*Y2;
 
 X4=normrnd(m3x,s3,nbp,1);
 Y4=normrnd(m3y,s3,nbp,1);
 X5=(0<X2<10);
 X4=X5.*X4;
 Y5=(0<Y2<10);
 Y4=Y5.*Y4;
 
 X6=normrnd(m4x,s4,nbp,1);
 Y6=normrnd(m4y,s4,nbp,1);
 X7=(0<X6<10);
 X6=X7.*X6;
 Y7=(0<Y6<10);
 Y6=Y7.*Y6;
 
 X=[X;X2;X4;X6];
 Y=[Y;Y2;Y4;Y6];
  %parametersxy(X,Y,4);
  test1(X,Y);
end
end