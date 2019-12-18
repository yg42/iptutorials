function R=backprojection(P, theta, filtre)
% Backprojection of a projected image P,
% at all angles 'theta'
% filtre: bool, applies filtering if True
N = size(P,1);
R =zeros(N);

% in case of filtered back-projection
if filtre==1
    h = RamLak(31);
end

figure()
% loops over all angles
for i=1:length(theta)
    proj = P(:,i);
  
    plot(proj); hold on
    % filtered back-projection
    if filtre==1
        proj = conv(proj, h, 'same');
        plot(proj);
    end
    hold off
    pause(.1)
    proj2 = repmat(proj, 1, N);
    proj2 = imrotate(proj2, -theta(i), 'bilinear', 'crop');
    
    R = R + proj2;
end
