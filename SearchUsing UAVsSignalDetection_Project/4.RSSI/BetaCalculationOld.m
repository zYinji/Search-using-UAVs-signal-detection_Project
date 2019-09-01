% ----------------------------------------------------------------------------------------------------------
%  File: BetaCalculation.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------

%% Data Measurement
% Ask for the first measured distance
question1 = 'What is the first measured distance(m)? ';
d_ref = input(question1); % d_ref: d0

% Measured to obtain the median value (abandon large noise)
RSSI_ref = SignalRead(d_ref);

RSSI_ref_median = median(RSSI_ref.data); % RSSI_ref: RSSI(d0)

% Ask for the second measured distance
question2 = 'What is the second measured distance(m)? ';
d = input(question2); 

% Measured to obtain the median value (abandon large noise)
RSSI = SignalRead(d);
RSSI_median = median(RSSI.data);


%% Beta Calculation
beta = (RSSI_ref_median - RSSI_median) / log10(d / d_ref);

fileID = fopen('betaValue.txt','w');
fprintf(fileID,'%f',beta); % save beta
fclose(fileID);

%% Show the equation
fprintf('The final equation is: RSSI = %.1f - %f*lg(d/%d) \n',RSSI_ref_median,beta,d_ref);