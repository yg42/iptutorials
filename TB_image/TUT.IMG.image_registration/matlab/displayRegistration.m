function displayRegistration(A, B, Atrans, Rtrans, A_points, B_points, A_points_trans)
% Display results
% A: moving Image
% B: source image
% Atrans: transformed A image
% Rtrans: relative transformation
% A_points: control points in A
% B_points: control points in B
% A_points_trans: transformed control points of A
figure
subplot(221);viewImage(A);title('moving image'); hold on 
plot(A_points(:,1), A_points(:,2), '*r');
subplot(222);viewImage(B);title('source image'); hold on
plot(B_points(:,1), B_points(:,2), 'ob');

subplot(223);imshowpair(A,B);title('without registration')
subplot(224),imshowpair(Atrans,Rtrans, B, imref2d(size(B)));title('with registration'); hold on
plot(B_points(:,1), B_points(:,2), 'ob');
plot(A_points_trans(2,:), A_points_trans(1,:), '*r');
hold off