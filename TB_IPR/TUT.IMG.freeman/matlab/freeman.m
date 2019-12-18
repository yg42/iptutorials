function code=freeman(A,r0,c0,conn)
% freeman code of a contour.
% A : contour
% r0, c0 : coordinates of 1st point
% conn: connectivity, 4 or 8

B=A;
stop=0; % stop condition
point0=[r0,c0];
if (conn==8)
    lut=[1 2 3;8 0 4; 7 6 5];
else
    lut=[0 2 0;8 0 4;0 6 0];
end

% be careful that these LUTs consider
%  0
% 0+------- y
%  |
%  |
%  |
% x|
%
lutx=[-1 -1 -1 0 1 1 1 0];
luty=[-1 0 1 1 1 0 -1 -1];
lutcode=[3 2 1 0 7 6 5 4];

nbrepoints=sum(B(:));
code=zeros(nbrepoints, 1);
point=point0;


for indice = 1:nbrepoints
    B(point(1),point(2))=0;
    window=B(point(1)-1:point(1)+1,point(2)-1:point(2)+1);
    window=window.*lut;
    index=max(window(:));
    if (index==0) % no more points ? should link to first point
        B(point0(1),point0(2))=1;
        window=B(point(1)-1:point(1)+1,point(2)-1:point(2)+1);
        window=window.*lut;
        index=max(window(:));
        B(point0(1),point0(2))=0;
    end
    
    % compute coordinates of new point
    point=[point(1)+lutx(index),point(2)+luty(index)];
    
    % add code 
    code(indice) = lutcode(index);
    
end
