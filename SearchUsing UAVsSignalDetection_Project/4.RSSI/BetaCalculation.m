% ----------------------------------------------------------------------------------------------------------
%  File: BetaCalculation.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function [RSSI_ref_median,beta,d_ref] = BetaCalculation()

% Add the library function
addpath('.\Data\Adjust');

%% Data Measurement
% Ask for the first measured distance
d_ref = 10; % d_ref: d0

% Measured to obtain the median value (abandon large noise)
filename = [num2str(d_ref) 'mRSSI.txt'];
RSSI_ref = importdata(filename);

RSSI_ref_median = mean(RSSI_ref.data); % RSSI_ref: RSSI(d0)

% Ask for the second measured distance
d = 40; 

% Measured to obtain the median value (abandon large noise)
filename = [num2str(d) 'mRSSI.txt'];
RSSI = importdata(filename);

RSSI_median = mean(RSSI.data);

%% plot
d_plot = [10 20 30 40];
x_axis = [];
y_axis = [];
for i = 1:size(d_plot,2)
    filename = [num2str(d_plot(i)) 'mRSSI.txt'];
    RSSI_tem = importdata(filename);
    RSSI_tem = deleteMinMax(RSSI_tem,3);
    x_axis = [x_axis;d_plot(i) * ones(size(RSSI_tem.data,1),1)];
    y_axis = [y_axis;RSSI_tem.data];
end

scatter(x_axis,y_axis,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
xlabel('Distance(m)');
ylabel('Signal Strength(RSSI)');

%% Beta Calculation
beta = (RSSI_ref_median - RSSI_median) / log10(d / d_ref);

fileID = fopen('betaValue.txt','w');
fprintf(fileID,'%f',beta); % save beta
fclose(fileID);

%% Show the equation
fprintf('The final equation is: RSSI = %.1f - %f*lg(d/%d) \n',RSSI_ref_median,beta,d_ref);