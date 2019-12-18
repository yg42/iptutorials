function LMS=ARGYBtildetoLMS(argyb_tilde)
% conversion vers LMS


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maximal values definition
M0 = getColipM0();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = double(argyb_tilde);
[m,n,~] = size(I); % image size

% conversion to (L~,M~,S~)
P = [40/61,20/61,1/61;1,-12/11,1/11;1/9,1/9,-2/9 ]; % antagonist matrix
invP=inv(P);
TonColor=reshape(I,[m*n,3]);
TonColor=TonColor';
TonColor=P\TonColor;
TonColor=TonColor';
LMStilde=reshape(TonColor,[m,n,3]);

% applying LIP inverse isomorphism -> conversion dans les tons (L,M,S)
LMStones=invphi(LMStilde, M0);
LMS=lmstone(LMStones);
