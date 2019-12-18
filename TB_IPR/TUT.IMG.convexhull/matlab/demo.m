%% CORRECTION TUTORIAL CONVEX HULL
%% Graham Scan algorithm$

%% first test with 5 points
Points=[1 1 3 4 3;
    2 -4 0 1 -4];
Points=Points';

plot(Points(:,1),Points(:,2),'*')
axis equal
Q=conv_hull(Points);
hold on;
plot(Q(:,1),Q(:,2),'r')

%% 50 random points
n=50;
Points2=rand(n,2);

figure
plot(Points2(:,1),Points2(:,2),'*')
axis equal
Q=conv_hull(Points2);
hold on;
plot(Q(:,1),Q(:,2),'r')

