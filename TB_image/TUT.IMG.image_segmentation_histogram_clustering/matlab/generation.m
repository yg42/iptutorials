function Y=generation(n, x, y)
% Generates n random points (normal law) around point
% of coordinates (x,y) 

Y = randn(n,2)+ones(n,2)*[x 0; 0 y];
