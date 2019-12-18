function sol = RFH( x,y )
% calcule le paramatre RFH des zones de voronoi il ne prend pas en compte
% les zones ouvertes


r=[];
 [v,c] = voronoin([x(:) y(:)]);
 for i = 1:length(c) 
     
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region 
    l=length(c{i});
    surface=polyarea(v(c{i},1),v(c{i},2));
    
    xv=v(c{i},1);
    yv=v(c{i},2);
    perimetre=norm([xv(1),yv(1)]-[xv(l),yv(l)]);
    for k = 1:(l-1)
    perimetre=perimetre+norm([xv(k),yv(k)]-[xv(k+1),yv(k+1)]);%%ordre des sommets à verifier
    end
    r=[r;4*pi*surface/(perimetre*perimetre)];
    
    end
 end
 
  sol=1-(std(r)/mean(r));

end