function I = regularimage( length )
%returns an binary image[length(+-),length(+-)] where 1 are espaced whith space(number) zeros 
temp0=[1,0];
temp01=temp0;
while (size(temp01)<length)
    temp01=[temp01,temp0];
end
temp1=[0,1];
temp11=temp1;
while (size(temp11)<length)
    temp11=[temp11,temp1];    
end
temp2=[temp11;temp01];
temp3=temp2;
for j=1:(floor((length)/2))
    temp3=[temp3;temp2];
end
I=temp3;
imshow(I,[]);
end
