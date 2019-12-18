%% lines detection by Hough transform
close all

% Load an image
I  = double(imread('TestPR46.png'));
I = I(:,:,2); % keep grayscale image

%% performs contour detection
BW = edge(I,'canny');


%% Hough transform
angular_sampling = 0.002; % angles in radians                                             
[x, y] = size(BW);

rho_max = norm([x y]);                                                
rho = -rho_max:1:rho_max;
theta = 0:angular_sampling:pi;
H = zeros(length(rho), length(theta));

cosTheta = cos(theta);
sinTheta = sin(theta);

% performs Hough transform
tic
for i = 1:x
    for j = 1:y
         if BW(i, j)
%             R = i*cosTheta + j*sinTheta;
%             R = round(R + length(rho)/2);
%             H(R, 1:length(theta)) = H(R,1:length(theta)) + 1;
            for theta_index = 1:length(theta)
                th = theta(theta_index);
                r  = i * cos(th) + j * sin(th);
                rho_index = round(r + length(rho)/2);                      
                H(rho_index, theta_index) = H(rho_index, theta_index) + 1;
           end
        end
    end
end
toc

%% detection des maxima
difference = 50;
M = max(H(:));
maxima = H>(M-difference);


%figure, imshow(maxima);

% recuperation des pics
%[indices_rho_peaks, indices_theta_peaks] = find(maxima)
peaks = houghpeaks(H, 5);
indices_rho_peaks = peaks(:,1);
indices_theta_peaks=peaks(:,2);

rho_peaks   = rho(indices_rho_peaks);
theta_peaks = theta(indices_theta_peaks);

%rho_peaks = rho(peaks(:,1));
%theta_peaks = theta(peaks(:,2));

imshow(H,[]), hold on
title('Hough Transform');
xlabel('\theta (radians)');
ylabel('\rho (pixels)');
plot(indices_theta_peaks, indices_rho_peaks, 'r*');

%% Find rough lines
x= 1:size(I, 2);
figure, imshow(I,[]), hold on
for i=1:length(rho_peaks)
    y = (rho_peaks(i) - x* cos(theta_peaks(i)) )/ sin(theta_peaks(i));
    plot(y, x);
end
title('detected lines')
