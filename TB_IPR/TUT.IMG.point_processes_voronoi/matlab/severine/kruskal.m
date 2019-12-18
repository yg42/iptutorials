%
%---------------------kruskal.m---------------------   
%
% Kruskal algorithm for finding minimum spanning tree
%
% Input:  PV = nx3 martix. 1st and 2nd row's define the edge (2 vertices) and
% the 3rd is the edge's weight
% Output: w = Minimum spanning tree's weight
%         T = Minimum spanning tree's adjacency matrix
% 
%Fonkwe Edwin & Fouda Cedric; Ecole Nationale Superieure Polytechnique,
%Yaounde; January 2009 with credits to N.Cheilakos,2006
%----------------------------------------------------
function [w,T] = kruskal(PV)
row = size(PV,1);
X = [];
% create graph's adjacency matrix
for i = 1 : row
    X(PV(i,1),PV(i,2)) = 1;
    X(PV(i,2),PV(i,1)) = 1;
end
n = size(X,1);
% Check if graph is connected
%con = connected(X);
%if con == 1
%   error('Graph is not connected');
%end
% sort PV by ascending weights order. (we use bubble sort)
PV = fysalida(PV,3);
korif = zeros(1,n);
T = zeros(n);
for i = 1 : row
% control if we insert edge[i,j] in the graphic. Then the graphic has
% circle
    akmi = PV(i,[1 2]);
    [korif,c] = iscycle(korif,akmi);
    if c == 1
       PV(i,:) = [0 0 0];
   end
end
% Calculate Minimum spanning tree's weight
w = sum(PV(:,3)');
% Create minimum spanning tree's adjacency matrix
for i = 1 : row
    if PV(i,[1 2]) ~= [0 0]
        T(PV(i,1),PV(i,2)) = 1;
        T(PV(i,2),PV(i,1)) = 1;
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%--------------------iscycle.m---------------------------
%
% input: korif = set of vertices in the graph
%       akmi = edge we insert in graph
% output: korif = The "new: set of vertices
%        c = 1 if we have circle, else c = 0
%
%Fonkwe Edwin & Fouda Cedric; Ecole Nationale Superieure Polytechnique,
%Yaounde; January 2009 with credits to N.Cheilakos,2006
%---------------------------------------------------------
function [korif,c]=iscycle(korif,akmi)
g=max(korif)+1;
c=0;
n=length(korif);
if korif(akmi(1))==0 & korif(akmi(2))==0
    korif(akmi(1))=g;
    korif(akmi(2))=g;
elseif korif(akmi(1))==0
    korif(akmi(1))=korif(akmi(2));
elseif korif(akmi(2))==0
    korif(akmi(2))=korif(akmi(1));
elseif korif(akmi(1))==korif(akmi(2))
    c=1;
    return
else
    m=max(korif(akmi(1)),korif(akmi(2)));
    for i=1:n
        if korif(i)==m
           korif(i)=min(korif(akmi(1)),korif(akmi(2)));
       end
   end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%------------------------------fysalida.m-----------------------------
% swap matrix's rows, because we sort column (col) by ascending order 
% 
% input: A =  matrix
%        col = column we want to sort
% output:A = sorted matrix
%
% %Fonkwe Edwin & Fouda Cedric; Ecole Nationale Superieure Polytechnique,
%Yaounde; January 2009 with credit to N.Cheilakos,2006
%----------------------------------------------------------------------
function A = fysalida(A,col)
[r c] = size(A);
%******************Error checking****************************************
if col < 1 | col > c | fix(col) ~= col
   uiwait(msgbox([' error input value second argumment takes only integer values between 1 & ' num2str(c)],'ERROR','error'));
   error;
end
%**************************************************************************
for i = 1 : r - 1
    d = r + 1 - i;
    for j = 1 : d - 1
        if A(j,col) > A(j + 1,col)
% row swap j <--> j + 1            
            A([j j + 1],:) = A([j + 1 j],:);
        end
    end
end
end