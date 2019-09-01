% ----------------------------------------------------------------------------------------------------------
%  File: IntersectionComputing.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function [x,y] = IntersectionComputing(X1,X2,Y1,Y2,R1,R2)
%% Compute two intersections between two circles
syms x y ; 
Equation1 = (x - X1)^2 + (y - Y1)^2 - R1^2; 
Equation2 = (x - X2)^2 + (y - Y2)^2 - R2^2; 
[x,y]=solve(Equation1,Equation2); 
% x=vpa(x,5);  
% y=vpa(y,5);
