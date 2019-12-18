function [BM] = BMgenerationRectangle(Wsize,Gamma,WidthLaw,LengthLaw)
% Simulation of an isotropic boolean model with rectangular grains

% INPUT:
    % Wsize: dimensions of the observation window in which the model is generated
    % Gamma: intensity of the germ process
    % WidthLaw: parameters of the Gaussian law governing the width of the grains.
    % LengthLaw: parameters of the Gaussian law governing the length of the grains.

% OUTPUT: a structure BM
    % BM.Polygons: set of polygons as a realization of the boolean model observed in a window of size Wsize
    % BM.GrainNumber: number of grains
    % BM.GrainLocation: location of germs
    % BM.GrainSize: size of grains
    % BM.GrainOrientation: orientations of grains

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXAMPLE:
    % Wsize = [512 512];
    % Gamma = 100/Wsize(1)/Wsize(2);
    % WidthLaw = [30 10]; 
    % LengthLaw = [50 20];
    % [BM] = BMgenerationRectangle(Wsize,Lambda,WidthLaw,LengthLaw);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate the observation window as polygon
Wx = [0 Wsize(1) Wsize(1) 0 0];
Wy = [0 0 Wsize(1) Wsize(1) 0];

% generate edge correction
widthEdgeEffect = WidthLaw(1)+2*WidthLaw(2);
lengthEdgeEffect = LengthLaw(1)+2*LengthLaw(2);
edgeEffect = round(sqrt(widthEdgeEffect^2 + lengthEdgeEffect^2));

% generate the germs of the grains
grainLocation = BMgrainLocation(Wsize, edgeEffect, Gamma);
nbGrain = size(grainLocation,1);

% generate the width/length of the grains
grainWidth = BMgrainSize(nbGrain,WidthLaw);
grainLength = BMgrainSize(nbGrain,LengthLaw);

% generate the orientation of the grains
grainOrientation =  unifrnd(0,180,1,nbGrain);

% generate the frame with the grains
l = [];
L = [];
x = [];
y = [];
ang = [];
nb = 0;

X=[];
Y=[];

for i = 1:nbGrain 

    [X0,Y0] = generationRectanglePolygon(grainLocation(i,1),grainLocation(i,2),grainWidth(i),grainLength(i),grainOrientation(i));
          
    % does the grain intersect Wo?
    [Xtemp,Ytemp] = polybool('intersection',X0,Y0,Wx,Wy);
    
    if ~isempty(Xtemp)
        [X,Y] = polybool('union',X,Y,Xtemp,Ytemp);
        l = [l grainLength(i)];
        L = [L grainWidth(i)];
        x = [x grainLocation(i,1)];
        y = [y grainLocation(i,2)];
        ang = [ang grainOrientation(i)];
        nb = nb+1;
        
    end

end
    
BM = struct('GrainSize',{[l;L]},'GrainLocation',{[x;y]},'Polygons',{[X;Y]},...
'GrainOrientation',{ang},'GrainNumber',{nb});

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [locationGrain] = BMgrainLocation(Wsize, edgeEffect, gamma)

nf = Wsize(1) + edgeEffect;
nc = Wsize(2) + edgeEffect;
areaW = nf*nc;
n = poissrnd(gamma*areaW);

xn = rand(1,n)*nf - edgeEffect/2;
yn = rand(1,n)*nc - edgeEffect/2;
locationGrain = [xn',yn'];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  [sizeGrain] = BMgrainSize(nbGrain, paramGrain_size)

sizeGrain = normrnd(paramGrain_size(1),paramGrain_size(2),1,nbGrain); %mu, std
%ignoring values less or equal to 0
indices = find(sizeGrain<=0);
while isempty(indices)==0
    temp = normrnd(paramGrain_size(1),paramGrain_size(2),length(indices),1);
    sizeGrain(indices) = temp;
    indices = find(sizeGrain<=0);
end;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x,y] = generationRectanglePolygon(x0,y0,a,b,theta)

% INPUT
% (x0,y0): center coordinates of the rectangle
% (a,b): width and length of the rectnagle
% theta: orientation of the rectange
%
% OUTPUT
% (x,y): coordinates of the polygon / corners of the polygon

thetaRadians = theta*pi/180;
R = [cos(thetaRadians) -sin(thetaRadians);sin(thetaRadians) cos(thetaRadians)];
t = [x0;y0];
z1 = R*[a/2;-b/2] + t;
z2 = R*[a/2;b/2] + t;
z3 = R*[-a/2;+b/2] + t;
z4 = R*[-a/2;-b/2] + t;

z = [z1,z2,z3,z4,z1];
x = z(1,:);
y = z(2,:);

end
