% ----------------------------------------------------------------------------------------------------------
%  File: main.m (For 2D)
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
clear all;
%% Obtain the current RSSI model
[RSSI_ref_median,beta,d_ref] = BetaCalculation(); %a-b*log10(x/10)

beta = 21.35;

%% Distance measurement
data = DistanceMeasurement(RSSI_ref_median,beta,d_ref);

%% Trilateration1 (Maximum Likelihood Estimation)
[position,X,Y] = Trilateration(data);

%% Error Analysis (Maximum Likelihood Estimation)
errorMean = triError(X,Y,data,500);

%% Trilateration2 (Average of Connected Points)
bias1 = 1; bias2 = 1;
[position1,position2] = Trilateration2(data,bias1,bias2);
errorWithoutbias = norm(position1);
errorWithbias = norm(position2);