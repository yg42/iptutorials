
function K=Dilatation(I,iter,dt)

[Ny,Nx]=size(I);
K=cell(iter);
K{1}=I;

h=0.1;

for i=2:iter;
% calculate gradient in all directions (N,S,E,W)
    J=K{i-1};
	In=[J(1,:); J(1:Ny-1,:)]-J;     % -I_(x,-) w=w_(i,j)-w_(i-1,j)
	Is=[J(2:Ny,:); J(Ny,:)]-J;      %I_(x,+) w=w_(i+1,j)-w_(i,j)
	Ie=[J(:,2:Nx) J(:,Nx)]-J;       %I_(y,+) w=w_(i,j+1)-w_(i,j)
   Iw=[J(:,1) J(:,1:Nx-1)]-J;       %-I_(y,-) w=w_(i,j)-w_(i,j-1)

G=sqrt(power(min(0,-In),2)+power(max(0,Is),2)+power(min(0,-Iw),2)+power(max(0,Ie),2));

K{i}=K{i-1}+dt*G;
K{i}=(K{i}<256).*K{i};

end;




    


    
