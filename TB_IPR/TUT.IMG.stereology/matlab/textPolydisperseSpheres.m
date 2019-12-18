close all;
clear all;
clc;

nbSpheres = 100000;
%R = rand(1,nbSpheres);
R = 25 + 5.*randn(1,nbSpheres);
%R = 200*ones(1,nbSpheres);
Rmax = max(R);
nbClass = 15;
pas = Rmax/nbClass;
rbin = 0:pas:Rmax;

%% (simulated) PDF of the disk radii

pdfDiskRadii = cell(1,nbSpheres);

for j = 1:nbSpheres
    % real pdf of the disk radii
    prob = zeros(1,nbClass);
    id = find(R(j)<=rbin);
    RR = R(id(1));
    RR = R(j);
    for i = 1:nbClass
        prob(i) = 1/R(j)*( sqrt(RR^2-min(RR,rbin(i))^2)-sqrt(RR^2-min(RR,rbin(i+1))^2) );
    end
    prob = prob/sum(prob);
    %prob = prob==prob(randi(nbClass-10)+10);
    pdfDiskRadii{j} = prob;
end

% global pdf of disk radii
pdfAllDiskRadii = zeros(1,nbClass);
parfor j = 1:nbSpheres
    pdf = pdfDiskRadii{j};
    pdfAllDiskRadii = pdfAllDiskRadii+pdf;
end
pdfAllDiskRadii = pdfAllDiskRadii/nbSpheres;

figure
bar(pdfAllDiskRadii);

%% (real) PDF of the sphere radii

Rbin = 0:pas:Rmax; 
Rbin(end) = Rbin(end)+1;
pdfSphereRadii = zeros(1,nbClass);
parfor i = 1:nbClass
    temp = R>=Rbin(i) & R<Rbin(i+1);
    pdfSphereRadii(i) = sum(temp);
end
pdfSphereRadii = pdfSphereRadii/sum(pdfSphereRadii);

figure
bar(pdfSphereRadii)

%% (estimated) PDF of the sphere radii

% matrix Kij
K = zeros(nbClass,nbClass);
parfor i=1:nbClass
    for j=1:nbClass
        if j>=i
            K(i,j)=1/nbClass*(sqrt(j^2-(i-1)^2)-sqrt(j^2-i^2));
        end
    end
end

K=zeros(15,15);
K=[0.1857 -0.0750 -0.0261 -0.0132 -0.0080 -0.0054 -0.0039 -0.0028 -0.0022 -0.0016 -0.0013 -0.0009 -0.0007 -0.0004 -0.0001;
    0 0.1925 -0.0776 -0.0270 -0.0136 -0.0083 -0.0055 -0.0039 -0.0029 -0.0022 -0.0016 -0.0012 -0.0007 -0.0006 -0.0002;
    0 0 0.2000 -0.0804 -0.0280 -0.0140 -0.0085 -0.0056 -0.004 -0.0028 -0.0021 -0.0016 -0.0010 -0.0006 -0.0003;
    0 0 0 0.2085 -0.0836 -0.0290 -0.0146 -0.0088 -0.0057 -0.0041 -0.0028 -0.002 -0.0018 -0.0009 -0.0004;
    0 0 0 0 0.2182 -0.0872 -0.0301 -0.0151 -0.0090 -0.0058 -0.0040 -0.0027 -0.0018 -0.0010 -0.005;
    0 0 0 0 0 0.2294 -0.0913 -0.0319 -0.0155 -0.0091 -0.0059 -0.0038 -0.0026 -0.0015 -0.0006;
    0 0 0 0 0 0 0.2425 -0.0961 -0.0329 -0.0163 -0.0094 -0.0058 -0.0037 -0.0021 -0.0009;
    0 0 0 0 0 0 0 0.2582 -0.1016 -0.0346 -0.0168 -0.0095 -0.0057 -0.0031 -0.0013;
    0 0 0 0 0 0 0 0 0.2773 -0.1081 -0.0366 -0.0174 -0.0093 -0.0051 -0.0020;
    0 0 0 0 0 0 0 0 0 0.3015 -0.1161 -0.0386 -0.0178 -0.0087 -0.0033;
    0 0 0 0 0 0 0 0 0 0 0.3333 -0.1260 -0.0408 -0.0171 -0.0061;
    0 0 0 0 0 0 0 0 0 0 0 0.3779 -0.1382 -0.0420 -0.0130;
    0 0 0 0 0 0 0 0 0 0 0 0 0.4472 -0.1529 -0.0360;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0.5774 -0.1547;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];

% (estimated) probability density function of sphere radii
pdfSphereRadiiEstimated=1/(2*Rmax)*inv(K)*pdfAllDiskRadii';
pdfSphereRadiiEstimated = pdfSphereRadiiEstimated/sum(pdfSphereRadiiEstimated);

figure
% comparison
subplot(121)
bar([pdfSphereRadiiEstimated(1:end-1)';pdfSphereRadii(2:end)]')
legend('simulated','real');
subplot(122)
bar(abs(pdfSphereRadiiEstimated(1:end-1)'-pdfSphereRadii(2:end)))

figure
% comparison
subplot(121)
bar([pdfSphereRadiiEstimated';pdfSphereRadii]')
legend('simulated','real');
subplot(122)
bar(abs(pdfSphereRadiiEstimated'-pdfSphereRadii))

