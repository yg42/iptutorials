function [x,y]=semis_inter(point_nb, xmin,xmax, ymin,ymax, nbiter, energyFunction)
% simulation of a Gibbs point process
% point_nb is the number of points to plot
% xmin and xmax define the X domain of points
% ymin and ymax define the Y domain of points
% nbiter is the number of iterations, i.e. the number of times a point will
% be given a try to move
%
% energyFunction is an optional argument defining a function that takes a
% distance as a parameter and returns an energy (see example at the end of
% this code, with the default value of this function).
if nargin < 7
    energyFunction = @exampleEnergyFunction;
end

rng(0)

% Start with a poisson point process
[x,y]=semi_alea(point_nb,xmin,xmax,ymin,ymax);
%plot(x, y, 'b*'); hold on
% The variable indices is used to select a point
indices = 1:length(x);

for i=1:nbiter
    % choose a random point among previous process
    j=randi(length(x));
        
    % all points except jth
    x2 = x(indices~=j);
    y2 = y(indices~=j);
    
    % compute the energy associated to the point j
    e1 = energyFromPoint(energyFunction, x, y, x(j), y(j));
    
    % try to minimize energy with new points
    for m=1:10
        % new point 
        [xx,yy] = semi_alea(1, xmin, xmax, ymin, ymax);
        
        e2 = energyFromPoint(energyFunction, x2, y2, xx, yy);
        
        % the new point is kept if energy is less than previous
        % configuration
        if e2<e1
            x(j)=xx;
            y(j)=yy;
            e1=e2;
            
        end
        
    end
    
end

%plot(x, y, 'ro');
end
%==========================================================================
function e = energy(energyFunction, D, k)
% compute the energy between all the distances D and the point k
%
% if xx and yy are provided, this new point tries to replace the jth point
dist = sqrt(D(k,:).^2); % Euclidean distance

ee = energyFunction(dist);
e = sum(ee);

end

%==========================================================================
% compute the energy between all points and the new point
function e = energyFromPoint(energyFunction, x, y, xx, yy)
dist = sqrt((x-xx).^2+(y-yy).^2);
ee = energyFunction(dist);
e = sum(ee);
end

%==========================================================================
function e = exampleEnergyFunction(distance)
% Example of energy function
% Takes a distance as a parameter
% Returns value of energy.
%
% A negative energy means that the points are attracted.
% A positive energy means a repulsion of the points.
e=zeros(size(distance));
e(distance<10) = 10;
e(distance<20) = -50;
end
