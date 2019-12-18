function [ lms ] = lmstone( LMS )
% convert LMS values to color tones
% each LMS channel is normalized
M0 = getColipM0();
lms = (M0-eps(M0))*(1-LMS/M0);  

end

