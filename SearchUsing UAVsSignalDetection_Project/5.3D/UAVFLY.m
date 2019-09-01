% ----------------------------------------------------------------------------------------------------------
%  File: UAVFly.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------

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
while signalPos(1)<=0||signalPos(2)<=0
    signalPos = normrnd(spaceDim/2,spaceDim/4,[1,2]);
end

basePos = [spaceDim/2,spaceDim/2];
drones = [];
drones = [drones DroneSet(axis,basePos,signalPos)];

judge = 0;
while(judge~=1)
%     %clear axis
%     cla(ax1);
    
    judge = update(drones(1));

    %apply fancy lighting (optional)
%     camlight
    
    %update figure
    drawnow
    pause(0.01)
end

