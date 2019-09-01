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
spaceDim = 1000;
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


basPos = [500,500];
drones = [];
drones = [drones DroneSet(axis,basPos)];

while(drones.time < 1000.0)
%     %clear axis
%     cla(ax1);
    
    update(drones(1));

    %apply fancy lighting (optional)
%     camlight
    
    %update figure
    drawnow
    pause(0.1)
end