function [Adec,Err]=decompose(A)
se=strel('Disk',1);
%Afilt=imopen(A,se);
%Afilt=imclose(Afilt,se); % filtrage

H = fspecial('gaussian');
Afilt=imfilter(A,H);

Adec=imresize(Afilt, 0.5, 'nearest'); % sous-échantillonnage
B=imresize(Adec,2,'nearest'); % sur-échantillonnage
Err=A-B; % erreur