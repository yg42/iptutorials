%% passage dans l'espace des cones
% utilise l'espace XYZ comme espace de départ
function LMS=xyz2lms(XYZ,MatPassage)
if ndims(XYZ) == 3
    s=3;
    [M,N]=size(XYZ(:,:,1)); 
    XYZ=reshape(XYZ,[M*N,3])';
else
    s=2;
end
switch (MatPassage)
    case('hpe')
    U=[0.38971,0.68898,-0.07869;-0.22981,1.18340,0.04641;0,0,1];
    case('hped65')
    U=[0.4002,0.7076,-0.0808;-0.2263,1.1653,0.0457;0,0,0.9182]; % 0.9812 
    case('bradford')
    U=[0.8951,0.2664,-0.1614;-0.7502,1.7135,0.0367;0.0389,-0.0685,1.0296];
    case('ciecam02')
    U=[.7328,0.4296,-0.1624;-0.7036,1.6975,0.0061;0.0030,0.0136,0.9834];
    case('vonkries')
        U=[.4 .708 -.081; -.266 1.165 0.046; 0.0 0.0 0.918];
    case('ciecam97')
        U=[0.8562 0.3372 -0.1934; -0.8360 1.8327 0.0033; 0.0357 -0.0469 1.0112];
end  

% conversion
LMS=U*XYZ;
if s==3
    LMS=reshape(LMS',[M,N,3]);
end