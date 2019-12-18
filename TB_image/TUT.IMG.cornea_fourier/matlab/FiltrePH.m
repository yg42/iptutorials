function Sr=FiltrePH(S, fC)
% High pass filter
% S: spectrum (fourier transform)
% fC: cut-off frequency

fC=floor(fC);
if(fC<=0 | 2*fC >= size(S,2) | 2*fC >= size(S,1) )
   disp('Taille de coupure incorrecte');
   Sr=0;
   return;
end

So=ones(size(S));
So((size(S,1)/2-fC):(size(S,1)/2+fC), (size(S,2)/2-fC):(size(S,2)/2+fC))=0;
Sr=S.*So;
