% ----------------------------------------------------------------------------------------------------------
%  File: deleteMinMax.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function RSSI_tem = deleteMinMax(RSSI_tem,loop)
%% Delete several max value and several min value

for i = 1:loop  
    [~,pos] = min(RSSI_tem.data);
    RSSI_tem.data(pos) = [];
    [~,pos] = max(RSSI_tem.data);
    RSSI_tem.data(pos) = [];
end