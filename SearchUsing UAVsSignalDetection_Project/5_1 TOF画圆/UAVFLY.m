% ----------------------------------------------------------------------------------------------------------
%  File: UAVFly.m (Fusion)
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
clear all;

%% Define area
spaceDim = 3000;
height = 150;
spaceLimits = [0 spaceDim 0 spaceDim 0 height];


%figure to display drone simulation
f1 = figure;
ax1 = gca; % gca:set the range of axes
axis(spaceLimits)
grid ON
%minor grid, easier to see
grid MINOR
axis('manual')
caxis(ax1, [0 spaceDim]);
hold(ax1,'on')
% axis vis3d

% Set Gaussian distrbution to the area
signalPos = normrnd(spaceDim/2,spaceDim/6,[1,2]);
while signalPos(1)<=0||signalPos(2)<=0
    signalPos = normrnd(spaceDim/2,spaceDim/4,[1,2]);
end

%% Constructor to define default values
basePos = [spaceDim/2,spaceDim/2];
drones = [];
drones = [drones DroneSet(axis,basePos,signalPos)];

%% Update positions
judge = 0;
while(judge~=1)
     %clear axis
%     cla(ax1);
    
    judge = update(drones(1));
    
    %update figure
    drawnow
    pause(0.01)
end

%% ten positions with their cost time and error(For Modified Fusion Flight Simulation(6.2.4))
% 1. [2.049955306139966e+03,1.710088453863793e+03] 502  1.053 m 
% 2. [2.622325701529867e+03,2.336187593100416e+03] 1402 3.166 m 
% 3. [1.130490267920872e+03,1.217665269625023e+03] 356  2.694 m
% 4. [7.139976694673470e+02,9.744601628054397e+02] 166  1.753 m 
% 5. [1.902515583798830e+03,1.507110734108401e+03] 322  2.183 m 
% 6. [1.158693214411086e+03,1.394646431160414e+03] 412  1.252 m 
% 7. [9.961867100561499e+02,1.034300730447365e+03] 211  2.977 m 
% 8. [2.549597644217983e+03,2.111902928496309e+03] 1429 2.451 m 
% 9. [2.163085907012925e+03,1.179013980385172e+03] 716  1.153 m 
% 10.[8.572333478505722e+02,6.945502913207133e+02] 146  1.654 m 