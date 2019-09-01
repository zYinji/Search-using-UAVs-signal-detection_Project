% ----------------------------------------------------------------------------------------------------------
%  File: IntersectionComputingXYZ.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function position = IntersectionComputingXYZ(GPS,distance)
%% Compute two intersections between two circles
syms x y z; 
Equation1 = (x - GPS(1,1))^2 + (y - GPS(1,2))^2 + (z - GPS(1,3))^2 - distance(1)^2; 
Equation2 = (x - GPS(2,1))^2 + (y - GPS(2,2))^2 + (z - GPS(2,3))^2 - distance(2)^2; 
Equation3 = (x - GPS(3,1))^2 + (y - GPS(3,2))^2 + (z - GPS(3,3))^2 - distance(3)^2; 

% Equation1 = (x - GPS(1,1))^2 + (y - GPS(1,2))^2 - distance(1)^2 +80^2; 
% Equation2 = (x - GPS(2,1))^2 + (y - GPS(2,2))^2 - distance(2)^2 +80^2; 
% Equation3 = (x - GPS(3,1))^2 + (y - GPS(3,2))^2 - distance(3)^2 +80^2; 

% [x,y]=solve(Equation1,Equation2); 
% position = double([x y])

[x,y,z]=solve(Equation1,Equation2,Equation3); 
position = double([x y z])
% x=vpa(x,5);  
% y=vpa(y,5);
