% ----------------------------------------------------------------------------------------------------------
%  File: UAVFly.m (Multi-UAVs)
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
clear all;

%% Define area
%Define total width, length and height of flight arena (metres)
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

% set reference nodes
basePos = [3*spaceDim/8,3*spaceDim/8;3*spaceDim/8,5*spaceDim/8;3*spaceDim/8,7*spaceDim/8;1*spaceDim/8,7*spaceDim/8;...
           1*spaceDim/8,5*spaceDim/8;1*spaceDim/8,3*spaceDim/8;1*spaceDim/8,1*spaceDim/8;3*spaceDim/8,1*spaceDim/8];
basePosPlus = [5*spaceDim/8,3*spaceDim/8;5*spaceDim/8,5*spaceDim/8;5*spaceDim/8,7*spaceDim/8;7*spaceDim/8,7*spaceDim/8;...
               7*spaceDim/8,5*spaceDim/8;7*spaceDim/8,3*spaceDim/8;7*spaceDim/8,1*spaceDim/8;5*spaceDim/8,1*spaceDim/8];
drones = [];
drones = [drones DroneSet(axis,basePos,basePosPlus,signalPos)];

judge = 0;
while(judge~=1)
%     %clear axis
    cla(ax1);
    
    judge = update(drones(1));

    %update figure
    drawnow
    pause(0.01)
end

%% ten positions with their cost time and error(For Modified Fusion Flight Simulation(6.3.2))
% 1. [2.049955306139966e+03,1.710088453863793e+03] 546  1.043 m 
% 2. [2.622325701529867e+03,2.336187593100416e+03] 999  0.616 m 
% 3. [1.130490267920872e+03,1.217665269625023e+03] 280  3.077 m
% 4. [7.139976694673470e+02,9.744601628054397e+02] 321  3.482 m 
% 5. [1.902515583798830e+03,1.507110734108401e+03] 397  2.489 m 
% 6. [1.158693214411086e+03,1.394646431160414e+03] 295  2.449 m 
% 7. [9.961867100561499e+02,1.034300730447365e+03] 394  1.168 m 
% 8. [2.549597644217983e+03,2.111902928496309e+03] 1083 0.525 m 
% 9. [2.163085907012925e+03,1.179013980385172e+03] 746  1.047 m 
% 10.[8.572333478505722e+02,6.945502913207133e+02] 226  1.743 m 

