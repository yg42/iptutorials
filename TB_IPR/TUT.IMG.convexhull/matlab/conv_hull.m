function Q=conv_hull(PointsOri)
% Graham scan for convex hull
% algorithm:
% 1 - find lowest y-axis point
% 2 - sort points by angle
% 3 - proceed in this order and check left or right turn

% display steps of the algorithm
figure; 

% precision
Points=round(PointsOri.*1000)/1000;

% get points with minimal y-coordinate
PP = sortrows(Points, [2 1]);
P = PP(1,:);

% list of the other points
Points=PP(2:end, :);

% sort by cosinus of angle
adj_side=Points(:,1)-P(1);
opp_side=Points(:,2)-P(2);
hypothenuse=sqrt(adj_side.^2+opp_side.^2);
cosinus=adj_side./hypothenuse;
[~,ind]=sort(-cosinus); % cos is decreasing
Points=[P;Points(ind,:);P];


% compute convex hull in this order
Q=[];
Q=push(Q,Points(1,:));
Q=push(Q,Points(2,:));
for i=3:size(Points,1)
    while (length(Q)>=2 && CrossProduct(Q,Points(i,:)) < 0)
        Q=pop(Q);
    end
    Q=push(Q,Points(i,:));
    
    
    % display star-like shape just after sort
    plot(Points(:,1), Points(:,2), 'b');
    hold on
    % display hull construction at each step
    plot(Q(:,1), Q(:,2), 'r');
    pause(.2)
    hold off
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% useful functions
    function Z=push(Q,point)
        % push point into the list Q
        Z=[Q;point];
    end

    function Z=pop(Q)
        % pop last element
        Z=Q(1:end-1,:);
    end

    function p=CrossProduct(Q, p3)
        % cross product 
        % Q  :list of points
        % p3 :point
        p1=Q(length(Q)-1,:);
        p2=Q(length(Q),:);
        p=(p2(1) - p1(1))*(p3(2) - p1(2)) - (p3(1) - p1(1))*(p2(2) - p1(2));
    end

end