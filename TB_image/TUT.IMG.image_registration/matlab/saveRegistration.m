function saveRegistration(B, Atrans, Rtrans, B_points, A_points_trans, filename)
% Display results
% B: source image
% Atrans: transformed A image
% Rtrans: relative transformation
% B_points: control points in B
% A_points_trans: transformed control points of moving image
figure();
imshowpair(Atrans,Rtrans, B, imref2d(size(B)));title('with registration'); hold on
plot(B_points(:,1), B_points(:,2), 'ob');
plot(A_points_trans(2,:), A_points_trans(1,:), '*r');

% save result
frame = getframe();
imageFusion = frame2im(frame);
imwrite(imageFusion, filename);