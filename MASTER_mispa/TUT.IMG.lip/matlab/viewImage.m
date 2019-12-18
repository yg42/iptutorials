function viewImage(A)
B=double(A);
mmax=max(B(:));
mmin=min(B(:));

if (mmax == mmin) 
    B=0;
else
    B=uint8(255*(B-mmin)/(mmax-mmin));
end
colormap gray;axis image;
imshow(B);