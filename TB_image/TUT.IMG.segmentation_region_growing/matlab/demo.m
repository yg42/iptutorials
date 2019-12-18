%% TUTORIAL - SEGMENTATION BY REGION GROWING

% needs an image I, gray level
% double is needed to perform comparison

I = double(imread('cameraman.tif'));

[Sx, Sy] = size(I);
imshow(I,[]);

% seed
disp('Pick up a pixel with the mouse - left click on image');
[x, y]=ginput(1);
seed = round([y;x]); % beware of inversion of coordinates


% create the queue structure by a Java object
queue = java.util.LinkedList;

% compute with the following predicate functions
myfunctions={'predicate', 'predicate2', 'predicate3'};

for f= 1:length(myfunctions)
    % Visited matrix : result of segmentation
    % this matrix will contain 1 if in the region, -1 if visited but not in the
    % region, 0 if not visited
    visited = zeros(size(I));
    
    %--------------------------------------------------------------------------
    % Start of algorithm
    queue.add(seed);
    visited(seed(1), seed(2)) = 1;
    tic
    while ~queue.isEmpty()
        p = queue.remove();
        
        % look at the pixel in a 8-neighborhood
        r = p(1); % row
        c = p(2); % col
        for i=max(1,r-1):min(Sx,r+1)
            for j=max(1,c-1):min(Sy,c+1)
                if (visited(i,j)==0) % not visited yet
                    if (feval(myfunctions{f}, I, [i j], seed, visited)) % condition is fulfilled
                        visited(i, j) = 1;
                        queue.add([i;j]); % add to visiting queue
                    else
                        visited(i, j) = -1;
                    end
                end
            end
        end
    end
    toc
    
    figure(); imshow(visited==1,[]);
    imwrite(visited==1, [myfunctions{f} '_seg.png']);
end
% end of the algorithm: the visited matrix contains the segmentation result
%--------------------------------------------------------------------------
