function [s,B]=autothresh(A)
% Automatic threshold of image A
% return values:
%  s: threshold value
%  B: thresholded (binary) image

% initialization of s
s=0.5*(min(A(:)) + max(A(:)));
done = false;

% iterate until convergence of s
while ~done
    B=(A>=s);
    sNext=0.5*(mean(A(B))+mean(A(~B)));
    done=abs(s-sNext)<0.5; % convergence ?
    s=sNext;
end
  