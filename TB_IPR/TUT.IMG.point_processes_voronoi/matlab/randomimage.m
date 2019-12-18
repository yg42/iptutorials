function I = randomimage( length )
%returns a random binary image
%I = randsrc(length,length,[1,0; .5,.5]);
I=rand(length,length);
I=(I>0.15);
imshow(I);
end
