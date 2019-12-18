function z=timesLIP(alpha,x)
a=double(x);
z=255-255*(1-a/255).^alpha;