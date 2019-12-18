function tform = icp_transform(dataA, dataB)
% Find a transform between A and B points
% with an ICP (Iterative Closest Point) method.
% dataA and dataB are of size nx2, with the same number of points n 
% returns a tform affine2d object

data2A = dataA;
data2B = zeros(size(data2A));
tform=affine2d(eye(3));

nb_loops=10;
data_loop = cell(nb_loops,1);
data_loop{1} = data2A;

for loop =2: nb_loops
    % search for closest points and reorganise array of points accordingly
    [corr,~] = dsearchn(dataB, data2A);
    for j = 1:length(corr)
        data2B(j,:) = dataB(corr(j),:);
    end
    
    % find rigid registration with reordered points
    [R_loop, t_loop] = rigid_registration(data2A, data2B);
    tform_loop = affine2d([R_loop,[0;0];t_loop',1]);
    
    [X,Y]=tform_loop.transformPointsForward(data2A(:,1),data2A(:,2));
    data2A=[X,Y];
    tform = affine2d(tform_loop.T * tform.T);

    data_loop{loop} = data2A;
end

% figure
% %imshowpair(Atrans,Rtrans, B, imref2d(size(B))); hold on
% imshow(A,[]), hold on
% for i = 1:length(data_loop)-1
%     origin = data_loop{i};
%     destination=data_loop{i+1};
%     quiver(origin(:,1), origin(:,2), destination(:,1)-origin(:,1), destination(:,2)-origin(:,2), 0); 
%     
% end
% hold off