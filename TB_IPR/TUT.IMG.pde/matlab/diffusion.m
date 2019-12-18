function Jd=diffusion(I,method,N,dt,K,sigma2)

% Simulates N iterations of diffusion, parameters:
% J =  source image (2D gray-level matrix) for diffusion
% method =  'lin':  Linear diffusion (constant c=1).
%           'pm1': perona-malik, c=exp{-(|grad(J)|/K)^2} [PM90]
%           'pm2': perona-malik, c=1/{1+(|grad(J)|/K)^2} [PM90]
%           
% K    edge threshold parameter
% N    number of iterations
% dt   time increment (0 < dt <= 0.25, default 0.2)
% sigma2 - if present, calculates gradients of diffusion coefficient
%          convolved with gaussian of var sigma2 (Catte et al [CLMC92])

if ~exist('N')
   N=1;
end
if ~exist('K')
   K=1;
end
if ~exist('dt')
   dt=0.2;
end
if ~exist('sigma2')
   sigma2=0;
end

[Ny,Nx]=size(I); 
J=cell(N);
J{1}=I;

if (nargin<3) 
   error('not enough arguments (at least 3 should be given)');
end

for i=1:N;   
   % gaussian filter with kernel 5x5 (Catte et al)
   if (sigma2>0) 
      Jo = J{i};   % save J original
      J{i}=gauss(J{i},5,sigma2);  
   end

	% calculate gradient in all directions (N,S,E,W)
	In=[J{i}(1,:); J{i}(1:Ny-1,:)]-J{i};     % -I_(x,-) w=w_(i,j)-w_(i-1,j)
	Is=[J{i}(2:Ny,:); J{i}(Ny,:)]-J{i};      %I_(x,+) w=w_(i+1,j)-w_(i,j)
	Ie=[J{i}(:,2:Nx) J{i}(:,Nx)]-J{i};       %I_(y,+) w=w_(i,j+1)-w_(i,j)
    Iw=[J{i}(:,1) J{i}(:,1:Nx-1)]-J{i};       %-I_(y,-) w=w_(i,j)-w_(i,j-1)


	% calculate diffusion coefficients in all directions according to method
   if (method == 'lin')
	    Cn=K; Cs=K; Ce=K; Cw=K;
   elseif (method == 'pm1')
        Cn=exp(-(abs(In)/K).^2);
		Cs=exp(-(abs(Is)/K).^2);
		Ce=exp(-(abs(Ie)/K).^2);
		Cw=exp(-(abs(Iw)/K).^2);
   elseif (method == 'pm2')
 	    Cn=1./(1+(abs(In)/K).^2);
		Cs=1./(1+(abs(Is)/K).^2);
		Ce=1./(1+(abs(Ie)/K).^2);
        Cw=1./(1+(abs(Iw)/K).^2); 
   else
        error(['Unknown method "' method '"']);
   end
   
   if (sigma2>0)   % calculate real gradiants (not smoothed)
   	    In=[Jo(1,:); Jo(1:Ny-1,:)]-Jo;
		Is=[Jo(2:Ny,:); Jo(Ny,:)]-Jo;
		Ie=[Jo(:,2:Nx) Jo(:,Nx)]-Jo;
        Iw=[Jo(:,1) Jo(:,1:Nx-1)]-Jo;
      J{i}=Jo;
	end

   % Next Image J
   J{i+1}=J{i}+dt*(Cn.*In + Cs.*Is + Ce.*Ie + Cw.*Iw);
end;

Jd = J;

