function [coins]=Harris(A,max_N)
max_N;
thr=0;
sigma=2;
[m,n]=size(A);
dx = [-1 0 1; -2 0 2; -1 0 1]; % The Mask 
dy = dx';
%%%%%% 
Ix = conv2(A, dx, 'same');   
Iy = conv2(A, dy, 'same');
g = fspecial('gaussian',6*sigma, sigma); %%%%%% Gaussien Filter
%g=ones(5,5);
%g=g/(sum(g(:)));
%%%%% 
Ix2 = conv2(Ix.^2, g, 'same');  
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g,'same');
%%%%%%%%%%%%%%
k = 0.04;
R11 = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
R11 = int16(100 *( R11-min(R11(:)) ) / ( max(R11(:))-min(R11(:)) ));
sze = 2*6+1; 
MX = ordfilt2(R11,sze^2,ones(sze));
coins = (R11>thr)&(R11==MX);
count=sum(coins(:));
loop=0;
%while ( ( (count<min_N)|(count>max_N) )&(loop<101) )
while ( (count>max_N) & (loop<100) )
    thr;
%     if (count > max_N)
%         thr=thr+1;
%     elseif (count < min_N)
%         thr=thr-1;
%     end
    if (count > max_N)
        thr=thr+1;
    end
    coins = (R11>thr)&(R11==MX);
    count=sum(coins(:));
    loop=loop+1;
end
if (loop==101)
    disp('pas de solution : vous devez changer le nombre de points caractéristiques')
end
