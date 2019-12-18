function [area, per, chi] = BMminkowskiDensities(xy, Wsize)

% INPUT:
  % BM: boolean model in a bounded observation window

% OUTPUT:
  % per: density of perimeter 
  % area: density of area 
  % chi: density of euler characteristic
  
Warea = Wsize(1)*Wsize(2);
Wperimeter = 2*(Wsize(1)+Wsize(2));

x=xy(1,:);
y=xy(2,:);
[xcells,ycells] = polysplit(x,y);
n = length(xcells);

cc = zeros(n,1);
for i=1:n
   cc(i) = ispolycw(xcells{i},ycells{i});
end
  
% Compute Minkowski densities (Weil's formulae)
area = PolyArea(xcells,ycells,cc)/Warea;

per = (PolyPerimeter(xcells,ycells)/Warea) - (Wperimeter*area/Warea);

chi = (PolyEuler(cc)/Warea) - (1/2/pi)*(Wperimeter*PolyPerimeter(xcells,ycells)/Warea/Warea) + ...
  ((1/2/pi)*((Wperimeter^2)/(Warea^3) )- 1/Warea/Warea)*area*Warea;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [area] = PolyArea(xcells,ycells,cc)

n = length(xcells);
area=0;

%axis square;axis equal;
for i=1:n
   if cc(i)==1 % true polygon
       area = area + polyarea(xcells{i},ycells{i});
   else % hole
       area = area - polyarea(xcells{i},ycells{i});
   end
end 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [per] = PolyPerimeter(xcells,ycells)
% compute perimeter of polygons
n = length(xcells);

for i=1:n
    x=xcells{i};
    y=ycells{i};
    j=1;
    z(i)=0;
    while j<length(x)
        z(i)=z(i)+ norm([(x(j+1)-x(j)),(y(j+1)-y(j))],2);
        j=j+1;
    end
end

per = sum(z);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [chi] = PolyEuler(cc)
% compute Euler characteristic of polygons
chi = 2*sum(cc)-length(cc);

end


