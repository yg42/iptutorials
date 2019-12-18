function A=recadre(B);
A=uint8(255*(B-min(min(B)))/(max(max(B))-min(min(B))));