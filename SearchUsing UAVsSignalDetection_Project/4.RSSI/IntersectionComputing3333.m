% ----------------------------------------------------------------------------------------------------------
%  File: IntersectionComputing3333.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
% function [x,y] = IntersectionComputing3333(X1,X2,Y1,Y2,R1,R2)
%% ≤‚ ‘”√£¨XYZ»˝÷·
deg_to_rad = pi/180;
load('data.mat')
load('distance.mat')
X = [60*cos(0); 45*cos(100*deg_to_rad); 40*cos(235*deg_to_rad)];
Y = [60*sin(0); 45*sin(100*deg_to_rad); 40*sin(235*deg_to_rad)+150];
Z = [120; 100; 110];

% X = [60*cos(0); 50*cos(44*deg_to_rad); 45*cos(100*deg_to_rad); 35*cos(145*deg_to_rad);...
%     40*cos(170*deg_to_rad); 40*cos(235*deg_to_rad); 45*cos(270*deg_to_rad)];
% Y = [60*sin(0); 50*sin(44*deg_to_rad); 45*sin(100*deg_to_rad); 35*sin(145*deg_to_rad);...
%     40*sin(170*deg_to_rad); 40*sin(235*deg_to_rad); 45*sin(270*deg_to_rad)];
% X = [X(5); X(3); X(4);X(5)];
% Y = [Y(5); Y(3); Y(4);Y(5)];
distance = data(:,2);
distance = [distance(5); distance(3); distance(4);distance(5)];

Z = [90; 90; 90];

%% Compute two intersections between two circles
syms x y z; 
Equation1 = (x - X(1))^2 + (y - Y(1))^2 + (z - Z(1))^2 - distance(1)^2-(Z(1))^2; 
Equation2 = (x - X(2))^2 + (y - Y(2))^2 + (z - Z(2))^2 - distance(2)^2-(Z(2))^2; 
Equation3 = (x - X(3))^2 + (y - Y(3))^2 + (z - Z(3))^2 - distance(3)^2-(Z(3))^2; 
% Equation4 = (x - X(4))^2 + (y - Y(4))^2 + (z - Z(4))^2 - distance(4)^2-(Z(4)-3)^2;
% Equation1 = (x - X(1))^2 + (y - Y(1))^2 + (z - Z(1))^2 - distance(1)^2; 
% Equation2 = (x - X(2))^2 + (y - Y(2))^2 + (z - Z(2))^2 - distance(2)^2; 
% Equation3 = (x - X(3))^2 + (y - Y(3))^2 + (z - Z(3))^2 - distance(3)^2; 

[x,y,z]=solve(Equation1,Equation2,Equation3); 
% [x,y,z]=solve(Equation1,Equation2,Equation3,Equation4); 
double([x y z])
% x=vpa(x,5);  
% y=vpa(y,5);

a = X(1);b = Y(1);c = Z(1);r = sqrt(distance(1)^2+Z(1)^2);
[x,y,z]=sphere(30);
XX=x*r+a;
YY=y*r+b;
ZZ=z*r+c;
mesh(XX,YY,ZZ);
hold on
a = X(2);b = Y(2);c = Z(2);r = sqrt(distance(2)^2+Z(2)^2);
[x,y,z]=sphere(30);
XX=x*r+a;
YY=y*r+b;
ZZ=z*r+c;
mesh(XX,YY,ZZ);
hold on
a = XX(3);b = Y(3);c = Z(3);r = sqrt(distance(3)^2+Z(3)^2);
[x,y,z]=sphere(30);
XX=x*r+a;
YY=y*r+b;
ZZ=z*r+c;
mesh(XX,YY,ZZ);
hold on
axis equal

A = [1 2 0; 3 4 0; 5 6 0; 7 8 0]