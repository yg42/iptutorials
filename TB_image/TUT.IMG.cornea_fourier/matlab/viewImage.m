function viewImage(A)
B=double(A);
mmax=max(max(B));
mmin=min(min(B));
if (mmax == mmin) 
    B=0;
else
    B=uint8(255*(B-mmin)/(mmax-mmin));
end
colormap gray;axis image;
imshow(B,[]);