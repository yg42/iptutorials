%% Tutorial VORONOI/DELAUNAY

%% 0 - Cleaning
clc;clear all;close all;

%% 1 - Delaunay/Voronoi/MST
% generate 15 random points (uniform distribution)
P = rand(15,2);

%% 2 - Quantification
[ ad, rfh, msigd, msigmst ] = analysis( P, 1);

% Display result
figure
axis([0 1 0 1]);
axis square
hold on;
l=msigd(1);
c=msigd(2);
plot(l,c,'r*');
text(l+.02,c, '(\sigma_d,\mu_d)');

plot(ad,rfh,'g*');
text(ad+.02,rfh,'(AD,RFH)');

l=msigmst(1);
c=msigmst(2);
plot(l,c,'b*');
text(l+.02,c,'(\sigma_{MST},\mu_{MST})');

legend({'Delaunay Characterization', 'Voronoi Characterization', 'MST Characterization'})

%% 3 - Characterizing different distributions
figure
[x,y]=disregular(150,4);subplot(231);plot(x,y,'b*');axis equal;title('Regular distribution');axis([-2 2 -2 2]);
[ ad, rfh, msigd, msigmst ] = analysis( [x y], 0);
subplot(234);
axis([0 1 0 1]);
plot(ad, rfh, 'b*');  xlabel('AD'); ylabel('RFH'); hold on
subplot(235);
axis([0 1 0 1]);
plot(msigd(1), msigd(2), 'b*');  xlabel('Mean DT edge length'); ylabel('std DT edge length'); hold on
subplot(236);
axis([0 1 0 1]);
plot(msigmst(1), msigmst(2), 'b*');  xlabel('Mean MST edge length'); ylabel('std MST edge length'); hold on

[x,y]=disalea(150,4);subplot(232);plot(x,y,'r*');axis equal;title('Uniform point process');axis([-2 2 -2 2]);
[x,y]=disgauss(150, 4);subplot(233);plot(x,y,'g*');axis equal;title('Gaussian point process');axis([-2 2 -2 2]);
hold on

for i=1:100
    % uniform distribution
    [x,y]=disalea(150,4);
    [ ad, rfh, msigd, msigmst ] = analysis( [x y], 0);
    subplot(234);
    plot(ad, rfh, 'r*');
    subplot(235);
    plot(msigd(1), msigd(2), 'r*');
    subplot(236);
    plot(msigmst(1), msigmst(2), 'r*');
    
    % gaussian distribution
    [x,y]=disgauss(150, 8);
    [ ad, rfh, msigd, msigmst ] = analysis( [x y], 0);
    subplot(234);
    plot(ad, rfh, 'g*');
    subplot(235);
    plot(msigd(1), msigd(2), 'g*');
    subplot(236);
    plot(msigmst(1), msigmst(2), 'g*');
end

