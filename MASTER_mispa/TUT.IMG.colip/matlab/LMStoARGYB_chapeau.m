function ARGYB_chap=LMStoARGYB_chapeau(LMS)
% LMS: values in ]0;M0]

ARGYBtilde = LMStoARGYBtilde(LMS);

% vérifications
% figure(); hold on
% for i=1:3
%     plot(ARGYBtilde(:,:,i));
% end

% conversion valeur absolue
ARGYB_chap = ARGYBtildetoARGYBchap(ARGYBtilde);
