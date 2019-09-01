% ----------------------------------------------------------------------------------------------------------
%  File: signal_modelling.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------

clear all
clc

deg_rad = 3.14159265/180;
a = [0.15*sin(90*deg_rad) 0.23*sin(70*deg_rad) 0.30*sin(57*deg_rad) 0.45*sin(50*deg_rad)...
     0.56*sin(45*deg_rad) 1.00*sin(30*deg_rad) 1.1*sin(15*deg_rad) ...
     1.30*sin(0*deg_rad)...
     1.14*sin(-15*deg_rad) 1.00*sin(-30*deg_rad) 0.56*sin(-45*deg_rad) 0.45*sin(-50*deg_rad)...
     0.30*sin(-57*deg_rad) 0.23*sin(-70*deg_rad) 0.15*sin(-90*deg_rad);...
     0.15*cos(90*deg_rad) 0.23*cos(70*deg_rad) 0.30*cos(57*deg_rad) 0.45*cos(50*deg_rad)...
     0.56*sin(45*deg_rad) 1.00*cos(30*deg_rad) 1.14*cos(15*deg_rad) ...
     1.30*cos(0*deg_rad)...
     1.14*cos(-15*deg_rad) 1.00*cos(-30*deg_rad) 0.56*cos(-45*deg_rad) 0.45*cos(-50*deg_rad)...
     0.30*cos(-57*deg_rad) 0.23*cos(-70*deg_rad) 0.15*cos(-90*deg_rad)];

x=a(1,:);
y=a(2,:);

%% y in 2D
plot(a(2,:),a(1,:));

%% y in 3D
[X2,Y2,~] = cylinder(y);
Z2=repmat(x',[1 length(X2(1,:))]);

mesh(Y2,Z2,X2)
alpha(0.4);
rotate3d;
axis equal;