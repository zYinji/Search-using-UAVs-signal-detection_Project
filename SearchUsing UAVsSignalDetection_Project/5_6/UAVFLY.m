% ----------------------------------------------------------------------------------------------------------
%  File: UAVFly.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
clear all;
Z = 1;
normXY = 10;
d = norm([Z,normXY]);
d = 200;
coff = 1; % cofficient to control converge
RSSI = (-96 - 21.35 * log10(d/10))/(1 - 2*exp(coff * log(1/2) - normXY));
RSSI = RSSI + 2 * normrnd(0,1,[6,1]);

%% 无人机飞行速度：18m/s
%% 
%Define total width, length and height of flight arena (metres)
spaceDim = 3000;
height = 150;
spaceLimits = [0 spaceDim 0 spaceDim 0 height];


%figure to display drone simulation
f1 = figure;
ax1 = gca; % gca:设置坐标轴范围
axis(spaceLimits)
grid ON
%minor grid, easier to see
grid MINOR
axis('manual')
caxis(ax1, [0 spaceDim]);
hold(ax1,'on')
% axis vis3d

signalPos = normrnd(spaceDim/2,spaceDim/6,[1,2]);
while signalPos(1)<=0||signalPos(2)<=0||signalPos(1)>=spaceDim||signalPos(2)>=spaceDim
    signalPos = normrnd(spaceDim/2,spaceDim/4,[1,2]);
end


signalPos = [8.572333478505722e+02,6.945502913207133e+02];

basePos = [spaceDim/2,spaceDim/2];
drones = [];
drones = [drones DroneSet(axis,basePos,signalPos)];


judge = 0;
while(judge~=1)
    %clear axis
%     cla(ax1);
    
    judge = update(drones(1));

    %apply fancy lighting (optional)
%     camlight
    
    %update figure
    drawnow
    pause(0.001)
end

% 1. [2.049955306139966e+03,1.710088453863793e+03] 806  83.071
% 2. [2.622325701529867e+03,2.336187593100416e+03] 1522 54.136
% 3. [1.130490267920872e+03,1.217665269625023e+03] 319  29.108
% 4. [7.139976694673470e+02,9.744601628054397e+02] 323  28.356
% 5. [1.902515583798830e+03,1.507110734108401e+03] 549  101.960
% 6. [1.158693214411086e+03,1.394646431160414e+03] 325  54.382
% 7. [9.961867100561499e+02,1.034300730447365e+03] 326  53.154
% 8. [2.549597644217983e+03,2.111902928496309e+03] 1563 74.355
% 9. [2.163085907012925e+03,1.179013980385172e+03] 916  21.794
% 10.[8.572333478505722e+02,6.945502913207133e+02] 408  58.733

