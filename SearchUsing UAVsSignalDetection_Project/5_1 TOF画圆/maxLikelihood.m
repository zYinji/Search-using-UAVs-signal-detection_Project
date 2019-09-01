% ----------------------------------------------------------------------------------------------------------
%  File: maxLikelihood.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
%% maxlikelihood estimation calculation for DroneSet.m 
function position = maxLikelihood(X,Y,distance)
A = [2 * (X(2:end) - X(1)) 2 * (Y(2:end) - Y(1))];
B = (X(2:end).^2 - X(1).^2) + (Y(2:end).^2 - Y(1).^2) - (distance(2:end).^2 - distance(1).^2);

position = inv(A'*A) * A' * B;