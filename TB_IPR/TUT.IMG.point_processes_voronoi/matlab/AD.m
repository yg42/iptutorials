function sol = AD(V, R )
% computes AD (Area Disorder) parameter
% V: Vertices from Voronoi
% R: Regions of Voronoi

s=[];
 for i = 1:length(R) 
    if all(R{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region 
    s=[s;polyarea(V(R{i},1),V(R{i},2))];
    end
 end
 sol=1-(1/(1+(std(s)/mean(s))));
end