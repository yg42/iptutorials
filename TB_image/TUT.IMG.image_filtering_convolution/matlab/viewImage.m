function viewImage(A)
%B=double(A);
%mmax=max(max(B));
%mmin=min(min(B));
%if (mmax == mmin) B=0;
%else B=uint8(255*(B-min(min(B)))/(max(max(B))-min(min(B))));
%end
colormap gray;axis image;
imshow(A);