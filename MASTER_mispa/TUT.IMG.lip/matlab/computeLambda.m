function lambda=computeLambda(AA)
A=double(AA);
mini=min(min(A));
maxi=max(max(A));

if maxi==255 || maxi==mini
    lambda=1;
    return
end

c=log(1-maxi/255);
d=log(1-mini/255);
e=255-mini;
f=255-maxi;

lambda=( log(c/d) ) / ( log(e/f) );