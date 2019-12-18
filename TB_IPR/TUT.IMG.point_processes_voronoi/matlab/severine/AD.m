function sol = AD( x,y )
%AD calcule le parametre AD des zones de voronoi il ne calcule pas la
%surface de la zone ouverte

s=[];
 [v,c] = voronoin([x(:) y(:)]);
 for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region 
    s=[s;polyarea(v(c{i},1),v(c{i},2))];
    end
 end
 sol=1-(1/(1+(std(s)/mean(s))));
end