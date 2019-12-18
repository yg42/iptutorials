function y=nc_type(X)
% evaluates the connectivity numbers

[a,b,c]=nc(X);
if (a==0) y=1;end % isoloated point
if ((a==1) && (b==1) && (c>1)) y=5;end  % border point
if (b==0) y=7;end % interior point
if ((a==1) && (b==1) && (c==1)) y=6;end % end point
if (a==2) y=2;end % 2-junction point
if (a==3) y=3;end % 3-junction point
if (a==4) y=4;end % 4-junction point