function XYZ=lms2xyz(LMS,MatPassage)
% conversion lms vers xyz
% LMS: données sous la forme [m, n, 3]
% MatPassage: string 'hpe', 'hped64', 'bradford', 'ciecam02'

[M,N]=size(LMS(:,:,1)); 
LMS=reshape(LMS,[M*N,3])';
switch (MatPassage)
    case('hpe')
    U=[0.38971,0.68898,-0.07869;-0.22981,1.18340,0.04641;0,0,1];
    case('hped65')
    U=[0.4002,0.7076,-0.0808;-0.2263,1.1653,0.0457;0,0,0.9182]; % ??? erreur sur le dernier coef
    case('bradford')
    U=[0.8951,0.2664,-0.1614;-0.7502,1.7135,0.0367;0.0389,-0.0685,1.0296];
    case('ciecam02')
    U=[.7328,0.4296,-0.1624;-0.7036,1.6975,0.0061;0.0030,0.0136,0.9834];
end

XYZ=U\LMS; % inv(U)*LMS
XYZ=reshape(XYZ',[M,N,3]);