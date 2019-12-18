function BMshow(xy)

x=xy(1,:);
y=xy(2,:);
[xcells,ycells] = polysplit(x,y);
n = length(xcells);

cc = zeros(n,1);
for i=1:n
   cc(i) = ispolycw(xcells{i},ycells{i});
end

color=[0.5 0.5 0.5];
for i=1:n
   if cc(i)==1
       p = patch(xcells{i},ycells{i},color);
       set(p,'EdgeColor','k','LineWidth',1);
   else
       p = patch(xcells{i},ycells{i},'w');
       set(p,'EdgeColor','k','LineWidth',1);
   end
end

axis square;axis equal;



