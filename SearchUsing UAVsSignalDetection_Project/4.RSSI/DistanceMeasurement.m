% ----------------------------------------------------------------------------------------------------------
%  File: DistanceMeasurment.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function data = DistanceMeasurement(RSSI_ref_median,beta,d_ref)

% Add the library function
addpath(genpath('.\Data\Measuremet'));


% Calculate the number of subdirectory
DIR = dir('.\Data\Measuremet\');
fileNumber = size(DIR,1) - 2;

data = zeros(fileNumber,2);
for i = 1:fileNumber
    filename = [num2str(i) '_RSSI.txt'];
    RSSI = importdata(filename);
    RSSI = deleteMinMax(RSSI,3);
    estimateRSSI = mean(RSSI.data);
    data(i,1) = estimateRSSI;
end

data(:,2) = d_ref * 10 .^((RSSI_ref_median - data(:,1))/beta);



