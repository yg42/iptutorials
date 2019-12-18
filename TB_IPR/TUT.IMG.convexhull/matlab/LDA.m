classdef LDA
%LDA-alpha-shapes.
%   LDA creates an LDA-alpha-shapes filtration for alpha in [1, infinity[
%
%   lda = LDA() or lda = LDA create an empty LDA
%
%   lda = LDA(x) creates an 2-D if x is a n-by-2-matrix of doubles where n is
%   the number of points
%
%   lda = LDA(x) creates an 3-D if x is a n-by-3-matrix of doubles where n is
%   the number of points 
%
%    lda = LDA(x,y) creates an 2-D if x,y are 1-column vectors
%
%    lda = LDA(x,y,z) creates an 3-D if x,y,z are 1-column vectors
%
%    lda = LDA(filename) creates a 2-D or a 3-D LDA if filename is the name
%    of a file containing a list of coordinates of 2-D or 3-D points.
%
%    Exemple : 
%    lda = LDA
%    lda = LDA(rand(10,2))
%    lda = LDA(rand(10,3))
%    lda = LDA(rand(20,1), rand(20,1))
%    lezard = LDA('lezard.txt')
%
%    ------------------------------------------------------------------
%    plot shows the LDA in an window
%
%    ------------------------------------------------------------------
%    LDA is re-calculated each time alpha is changed.
%    Exemple : 
%
%    lezard = LDA('lezard.txt')
%    lezard.plot
%    lezard.alpha = 2
%    lezard.plot
%    lezard.alpha = 1
%    lezard.plot
%    lezard.alpha = inf
%    lezard.plot
%
%    ------------------------------------------------------------------
%    LDA may be changed via its delaunay property
%    
%    Exemple
%
%    lda = LDA(rand(10,2)) % A 2-D LDA with 10 points
%    lda.plot;
%    lda.delaunay.X = [lda.delaunay.X ; rand(10,2)]; % Adding 10 points
%    more
%
%    ------------------------------------------------------------------
%    visible_simplices gives the visible simplices according to alpha.
%    visible_simplices are edges in 2D and faces (triangles) in 3D.
%    An edge is a pair of index in obj.delaunay.X
%    A face is a triplet of index in obj.delaunay.X
%
%       alpha = 1 => visible_simplices is empty
%       alpha = inf => visible_simplices is the convex hull


    
    properties
        delaunay
        alpha = inf
        debruitage = false
    end
    
    properties(SetAccess=private, GetAccess=public) 
    %DIMENSION dimension : 2 => 2D, 3 => 3D, 0 => empty        
        dimension
        visible_simplices
    end
    
    properties(Access=private)
        
        edges
        face_values
        circumcenters
        
        min_circumradius
        faces
        tetra_incident_to_faces
        faces_on_boundary
        tetra_incident_to_faces_on_boundary        
        circumradius
    end
    
    methods
        
        
        function obj = LDA(x,y,z)
            if nargin == 0 
                obj.delaunay = DelaunayTri;
            elseif nargin == 1
                if isa(x, 'char')
                    M = load(x);
                    if size(M,2) == 2
                        obj.delaunay = DelaunayTri(M(:,1),M(:,2));                        
                    elseif size(M,2) == 3
                        obj.delaunay = DelaunayTri(M(:,1),M(:,2),M(:,3));                        
                    end
                else
                    obj.delaunay = DelaunayTri(x);
                end
            elseif nargin == 2
                if size(x,2) ~= 1 || size(y,2) ~= 1
                    error('wrong dimension : must be 2 or 3');
                end
                obj.delaunay = DelaunayTri(x,y);
            elseif nargin == 3
                if size(x,2) ~= 1 || size(y,2) ~= 1 || size(z,2) ~= 1
                    error('wrong dimension : must be 2 or 3');
                end
                obj.delaunay = DelaunayTri(x,y,z);
            end
        end
        
        function plot(obj)
            %PLOT plot show the LDA in a window
            newplot;
            if obj.dimension == 2
                ne = size(obj.visible_simplices,1);
                for i = 1:ne
                    a = [obj.delaunay.X(obj.visible_simplices(i,2),:); obj.delaunay.X(obj.visible_simplices(i,1),:)];
                    plot(a(:,1),a(:,2));
                    hold on;
                end
                hold off;                                
            else
                %trisurf([obj.visible_faces ; obj.visible_faces_boundary], obj.delaunay.X(:,1), obj.delaunay.X(:,2), obj.delaunay.X(:,3));
                trisurf(obj.visible_simplices, obj.delaunay.X(:,1), obj.delaunay.X(:,2), obj.delaunay.X(:,3));
            end
        end
        
        function obj = calculateAll(obj)
            d = cputime;
            disp 'Calcul des centres des cercles circonscrits et de leur rayon';
            [obj.circumcenters, obj.circumradius] = obj.delaunay.circumcenters;
            cputime-d
            d = cputime;
            disp 'Affectation des valeurs de comparaison aux sommets';
            obj.min_circumradius = obj.valueToVertices();
            cputime-d
            d = cputime;
            disp 'Affectation des valeurs de comparaison aux faces';
            obj.face_values = obj.faceValues();
            cputime-d
            d = cputime;
            if obj.dimension == 2
                disp 'Calcul des côtés visibles en fonction de alpha';
                obj.visible_simplices = obj.visibleEdges();
                cputime-d
                d = cputime;
            else
                disp 'obj.faces_on_boundary = obj.delaunay.freeBoundary';
                obj.faces_on_boundary = obj.delaunay.freeBoundary;
                cputime-d
                d = cputime;
                disp 'Calcul des faces';
                [obj.faces obj.tetra_incident_to_faces obj.tetra_incident_to_faces_on_boundary] = obj.computesFaces();
                cputime-d
                d = cputime;
                disp 'Calcul des faces visibles en fonction de alpha';
                obj.visible_simplices = obj.visibleFaces();
                cputime-d
            end            
        end
       
        
        function obj = set.delaunay(obj, delaunay)
            if size(delaunay.X,1) == 0
                obj.dimension = 0;
            else
                obj.dimension = size(delaunay.X,2);
            end
            
            obj.delaunay = delaunay;

            obj.edges = delaunay.edges;
            
            if obj.dimension == 0
                return
            end
            
            obj = obj.calculateAll();
            

        end
        
%         function alpha = get.alpha(obj)
%             alpha = obj.alpha;
%         end
        
        function obj = set.alpha(obj, alpha)
            obj.alpha = alpha;
            if obj.dimension == 2
                obj.visible_simplices = obj.visibleEdges();
            else
                obj.visible_simplices = obj.visibleFaces();
            end
        end
        
        function obj = set.debruitage(obj, d) 
            
            obj.debruitage = d;
            
            obj = obj.calculateAll();
        end
    end
    
    methods(Access=private)
        
        function [Faces, SI, SIFB] = computesFaces(obj)
            
            Neighbors = obj.delaunay.neighbors;
            Tr = obj.delaunay.Triangulation;
            nl = size(Neighbors,1);
            nc = size(Neighbors,2);
            
            nf = sum(isnan(Neighbors(:)));
            
            Faces = zeros(nf,3);
            SI = zeros(nf,2);
            
            fcount = 1;
            for i = 1:nl
                for j = 1:nc
                    if ~isnan(Neighbors(i,j))
                        k = Neighbors(i,j);                        
                        Faces(fcount,:) = intersect(Tr(i,:), Tr(k,:));
                        SI(fcount,:) = [i k];
                        fcount = fcount + 1;
                    end
                end
                Neighbors(Neighbors==i) = NaN;
                
            end
            
            SIFB = zeros(size(obj.faces_on_boundary,1),1);
            
            for i = 1:size(obj.faces_on_boundary,1)
                for j = 1:size(obj.delaunay.Triangulation,1)
                    f = intersect(obj.faces_on_boundary(i,:), obj.delaunay.Triangulation(j,:));
                    if size(f,2) == 3
                        SIFB(i) = j;
                        break;
                    end
                end
            end
            
        end
        
        function facevalue = faceValues(obj)
            nf = size(obj.delaunay.Triangulation, 1);
            facevalue = zeros(nf,1);
            for i = 1:nf
                
                facevalue(i) = max(obj.min_circumradius(obj.delaunay.Triangulation(i,:)));
            end
            
            
        end
        
                
        %function [inside on_boundary] = visibleFaces(obj)
        function visible_simplices = visibleFaces(obj)
            ne = size(obj.faces,1);
            visible_simplices = [];
            for i = 1:ne
                cf = obj.tetra_incident_to_faces(i,:);
                
                f1 = cf(1);
                f2 = cf(2);

                if xor(obj.circumradius(f1) < obj.alpha*obj.face_values(f1), obj.circumradius(f2) < obj.alpha*obj.face_values(f2))
                    visible_simplices = [visible_simplices; obj.faces(i,:)];
                end
            end
            
            ne = size(obj.faces_on_boundary,1);
            %on_boundary = [];
            for i = 1:ne
                f1 = obj.tetra_incident_to_faces_on_boundary(i);
                
                if obj.circumradius(f1) < obj.alpha*obj.face_values(f1)
                    visible_simplices = [visible_simplices ; obj.faces_on_boundary(i,:)];
                end
                                
            end
            
        end
        
        function d = visibleEdges(obj)
            ne = size(obj.edges,1);
            %d = zeros(ne,1);
            d = [];
            for i = 1:ne
                cf = obj.delaunay.edgeAttachments(obj.edges(i,:));
                if numel(cf{1}) == 1
                    f1 = cf{1}(1);

                    %d(i) = obj.circumradius(f1) < obj.alpha*obj.face_values(f1);
                    if obj.circumradius(f1) < obj.alpha*obj.face_values(f1)
                        d = [d; obj.edges(i,:)];
                    end
                    
                else
                    f1 = cf{1}(1);
                    f2 = cf{1}(2);
                    
                    %d(i) = xor(obj.circumradius(f1) < obj.alpha*obj.face_values(f1), obj.circumradius(f2) < obj.alpha*obj.face_values(f2));
                    if xor(obj.circumradius(f1) < obj.alpha*obj.face_values(f1), obj.circumradius(f2) < obj.alpha*obj.face_values(f2))
                        d = [d; obj.edges(i,:)];
                    end
                end
            end
        end
        
        function d = valueToVertices(obj)
            %             if obj.dimension == 2
            %                 nv = size(obj.delaunay.X,1);
            %                 d = ones(nv, 1)*inf;
            %                 nf = size(obj.delaunay.Triangulation, 1);
            %                 for i = 1 : nf
            %                     face = obj.delaunay.Triangulation(i,:);
            %                     d(face(1)) = min(d(face(1)), obj.circumradius(i));
            %                     d(face(2)) = min(d(face(2)), obj.circumradius(i));
            %                     d(face(3)) = min(d(face(3)), obj.circumradius(i));
            %                 end
            %             else
            nv = size(obj.delaunay.X,1);
            d = ones(nv, 1)*inf;
            for i = 1 : nv
                d(i) = min(obj.circumradius(obj.delaunay.vertexAttachments{i}));
                if obj.debruitage
                    for j = 1 : size(obj.delaunay.vertexAttachments{i},2)
                        
                        for k = 1 : 3
                            d(i) = min(d(i),  min(obj.circumradius(obj.delaunay.vertexAttachments{obj.delaunay.Triangulation(obj.delaunay.vertexAttachments{i}(j),k)})));
                        end
                        
                        
                    end
                end
            end
            
            %             end
        end
        
        
        % Distance au carré entre deux vertex
        %   a et b les numéros de deux vertex
        % ou entre un vertex et un point
        %   a le numéro d'un vertex et b et c les coordonnées du point
        function d = squared_dist(obj, a, b, c)
            if nargin == 3
                v1x = obj.delaunay.X(a, 1);
                v1y = obj.delaunay.X(a, 2);
                v2x = obj.delaunay.X(b, 1);
                v2y = obj.delaunay.X(b, 2);
            elseif nargin == 4
                v1x = obj.delaunay.X(a, 1);
                v1y = obj.delaunay.X(a, 2);
                v2x = b;
                v2y = c;
            end
            d = LDA.squared_dist_two_coords(v1x, v1y, v2x, v2y);
        end
        
    end
    
    methods(Static, Access=private)
        
        function d = squared_dist_two_points(p1,p2)
            d = LDA.squared_dist_two_coords(p1(1), p1(2), p2(1), p2(2));
        end
        
        function d = squared_dist_two_coords(x1,y1,x2,y2)
            d = (x1-x2)^2+(y2-y1)^2;
        end
    end
end

