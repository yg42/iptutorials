%% Tomographic reconstruction simulation

% phantom image generation
I = phantom();

%% Projection with an angular step of 1 degree 
%
angle = 1;
theta = 0:angle:180;
S=simuProjection(I, theta);
imshow(S, []);

%% reconstruction: simple back-projection
R1=backprojection(S, theta, 0);

imshow(R1, []);

%% Filtered back-projection
R2=backprojection(S, theta, 1);
imshow(R2, []);

%% matlab built-in functions
s=radon(I, theta);
imshow(s, []);

r=iradon(s, theta);
figure();
imshow(r, []);
