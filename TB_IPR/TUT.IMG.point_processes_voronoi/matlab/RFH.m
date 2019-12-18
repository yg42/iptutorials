function sol = RFH( V, R)
% compute RFH parameter (Round Factor Homogeneity)
% V: Vertices from Voronoi
% R: Regions of Voronoi diagram

r=[];
for i = 1:length(R)
    
    if all(R{i}~=1)   % If at least one of the indices is 1,
        % then it is an open region
        l=length(R{i});
        surface=polyarea(V(R{i},1),V(R{i},2));
        
        xv=V(R{i},1);
        yv=V(R{i},2);
        perimetre=norm([xv(1),yv(1)]-[xv(l),yv(l)]);
        for k = 1:(l-1)
            perimetre=perimetre+norm([xv(k),yv(k)]-[xv(k+1),yv(k+1)]);
        end
        r=[r;4*pi*surface/(perimetre*perimetre)];
        
    end
end

sol=1-(std(r)/mean(r));

end