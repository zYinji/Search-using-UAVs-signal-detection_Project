% ----------------------------------------------------------------------------------------------------------
%  File: UAVFly_Signal.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
Z = 1;
normXY = 10;
d = norm([Z,normXY]);
coff = 1; % cofficient to control converge
RSSI = (-96 - 21.35 * log10(d/10))/(1 - 2*exp(coff * log(1/2) - normXY));
RSSI = RSSI + 2 * normrnd(0,1,[6,1]);