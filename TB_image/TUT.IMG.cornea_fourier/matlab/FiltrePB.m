function Sr=FiltrePB(S, fC)
% low pass filtering
% S: spectrum (Fourier Transform)
% fC: cut-off frequency

fC=floor(fC);
if(fC<=0 | 2*fC >= size(S,2) | 2*fC >= size(S,1) )
   disp('Taille de coupure incorrecte');
   Sr=0;
   return;
end

So=zeros(size(S));
So((size(S,1)/2-fC):(size(S,1)/2+fC), (size(S,2)/2-fC):(size(S,2)/2+fC))=1;
Sr=S.*So;
