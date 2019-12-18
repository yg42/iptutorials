function [ ad, rfh, delaunay_parameter, mst_parameter ] = analysis( P, varargin)
% Analysis of a point process P
% P: Point process (nx2 elements)
% fig: true if it displays figure, false otherwise
% 
% ad: Area Disorder
% frh: round factor homogeneity
% delaunay_parameter:
% mst_parameter: minimum spanning tree, mean and std edges values

if nargin <=1
    fig = 0; % default value: no fig
else
    fig = varargin{1};
end


if fig
    scatter(P(:,1), P(:,2));
    hold on
    axis square
end

% Delaunay Triangulation 
DT = delaunayTriangulation(P);
if fig
    triplot(DT)
end

% Voronoi Diagramme 
[V, R] = DT.voronoiDiagram();
% display
if fig
    voronoi(DT);
end

% Minimum spanning tree
% compute distances
edges = DT.edges;
P1 = P(edges(:,1), :);
P2 = P(edges(:,2), :);
d = sqrt(sum((P1-P2).^2,2));

% directed graph as a sparse matrix
DG = sparse(edges(:,1), edges(:,2), d, size(P,1), size(P,1));
ST = graphminspantree(DG');
[i, j, s] = find(ST);

if fig
% Display minimum spanning tree
    for k = 1:length(i)
        plot([P(i(k),1); P(j(k),1)], [P(i(k),2); P(j(k),2)], 'r', 'linewidth', 2);
    end
    axis square
end

%% Analysis
ad=AD(V,R);
rfh=RFH(V,R);
delaunay_parameter=[mean(d) std(d)];
mst_parameter=[mean(s) std(s)];
end

