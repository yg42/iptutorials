%% CORRECTION Tutorial POINTS PROCESSES
% This is a proposition of correction.

%% 0 - Nettoyage
clc; clear all; close all;

%% 1 - Conditional Poisson Process
n=100;
[x, y] = semi_alea(n, 0, 100, 0, 100);
plot(x,y,'*');title('Conditional Poisson process');
axis square

% Normal distribution, centered around (0,0)
x = 0 + 50 * randn(200,1);
y = 0 + 50 * randn(200,1);
figure();
plot(x, y, '*');title('Std normal distribution');
axis square


%% 2 - Processus de Neyman-Scott
figure
subplot(121)
[x,y]=semi_NS(3,0,100,0,100,20,10);
plot(x,y,'*');title('Neyman-Scott point process');
axis square
subplot(122)
[x,y]=semi_NS(10,0,100,0,100,20,10);
plot(x,y,'*');title('Neyman-Scott point process');
axis square

%% 3 - Processus de Gibbs
figure
subplot(241)
rng(0)
[x1,y1]=semi_alea(100,0,100,0,100);
plot(x1,y1,'*');title('Poisson point process');
axis square

subplot(242)
rng(0)
steps = [0,5,10];
energy= [10,0,0];
functionEnergy = @(x)stairsEnergy(x,steps, energy);
[x2,y2]=semis_inter(100,0,100,0,100,2000, functionEnergy);
plot(x2,y2,'*');title('Gibbs point process: regular');
axis square
subplot(246)
plot(0:10,zeros(1,11),'r','linewidth',2);hold on; 
stairs(steps, energy,'*-','linewidth',2);title('Energy function')
axis square

subplot(243)
rng(0)
steps = [0,2,5,10];
energy= [-10,10,0,0];
functionEnergy = @(x)stairsEnergy(x,steps, energy);
[x3,y3]=semis_inter(200,0,100,0,100,200, functionEnergy);
plot(x3,y3,'*');title('Gibbs point process: separated');
axis square
subplot(247)
plot(0:10,zeros(1,11),'r','linewidth',2);hold on;
stairs(steps,energy,'*-','linewidth',2); title('Energy function')
axis square

subplot(244)
rng(0)
steps = [0,2,5,10,15];
energy= [50,-10,5,0,0];
functionEnergy = @(x)stairsEnergy(x,steps, energy);
[x4,y4]=semis_inter(100,0,100,0,100,200, functionEnergy);
plot(x4,y4,'*');title('Gibbs point process: agregated');
axis square
subplot(248)
plot(0:10,zeros(1,11),'r','linewidth',2);hold on;
stairs(steps, energy,'*-','linewidth',2); title('Energy function')
axis square

%% 4 - Ripley function
r=1:100;
xmin=0; xmax=100; ymin=0; ymax=100;
nb_points=2000;
[x,y] = semi_alea(nb_points, xmin, xmax, ymin, ymax);
[k1,l1, vals]=ripley(x,y,xmin, xmax, ymin, ymax, r);

steps = [0,5,10];
energy= [10,0,0]; % regular distribution
functionEnergy = @(x)stairsEnergy(x,steps, energy);
[x2,y2]=semis_inter(nb_points, xmin, xmax, ymin, ymax, 2000, functionEnergy);
[k2,l2, vals]=ripley(x2,y2, xmin, xmax, ymin, ymax, r);


steps = [0,2,5,10];
energy= [-10,10,0,0]; % agregated distribution
functionEnergy = @(x)stairsEnergy(x,steps, energy);
[x3,y3]=semis_inter(nb_points, xmin, xmax, ymin, ymax, 2000, functionEnergy);
[k3,l3, vals]=ripley(x3,y3, xmin, xmax, ymin, ymax, r);

% figures
figure
plot(vals,l1-vals,'k-');hold on;
plot(vals,l2-vals,'r-');hold on;
plot(vals,l3-vals,'b-');hold on;
legend('Poisson','regular','agregated');
title('Ripley L functions');

figure
plot(vals, k1, 'k-'); hold on
plot(vals, k2, 'r-'); 
plot(vals, k3, 'b-');

legend('Poisson','regular','agregated');
title('Ripley K function');
%% 5 - Marked point processes
figure
subplot(121)
% generates Poisson process
nb_points=50;
xmin=0;
xmax=100;
ymin=0;
ymax=100;
[x,y]=semi_alea(nb_points,xmin, xmax, ymin, ymax);
plot(x,y,'*');title('Poisson process');
axis square
axis([-20,120,-20,120]);

% Generates radii with mean mu and stddev sigma
sigma=1;
mu = 5;
r = sigma*randn(length(x), 1) + mu;

% generates plot with disks
subplot(122)
plot(x,y,'*'); 
hold on
theta=0:0.01:2*pi;
xx = zeros(length(theta), 1);
yy = xx;

% the second mark (color) can be generated as this
nb_colors = 10;
m2 = randi(nb_colors, nb_points, 1);
cmap =  hsv(nb_colors);

for i=1:length(x)
    xx=x(i)+r(i)*cos(theta);
    yy=y(i)+r(i)*sin(theta);
    plot(xx,yy,'LineWidth', 2, 'Color', cmap(m2(i),:));
end

axis square
axis([-20,120,-20,120]);



