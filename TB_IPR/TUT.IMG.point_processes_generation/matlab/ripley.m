function [K, L, vals]=ripley(x,y,xmin,xmax,ymin,ymax,edges)
% Ripley K function
% x and y define the points abscisses and ordinates
% xmin xmax ymin ymax define the domain
% edges is a vector containing the distances (typically, r=1:100 for example)
% K: K function
% L: L function
% vals: values of radius

% number of points
nb_points=length(x);

% area
area = (xmax-xmin)*(ymax-ymin);

% computes the distances between all pairs of points
d = pdist([x,y]);

h = histcounts(d, edges, 'Normalization', 'cumcount');
figure, plot(h);

% count mean number of points
% multiply by 2 because each distance is only counted once in g
K = 2*h/nb_points;

% estimates density
densite=nb_points/area;
K=K/densite;

L = sqrt(K/pi);

vals = edges(1:end-1)+diff(edges);
%figure, plot(vals, h); title('cumulative histogram')
end % of function