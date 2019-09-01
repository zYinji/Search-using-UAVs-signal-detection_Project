% ----------------------------------------------------------------------------------------------------------
%  File: Antenna_Pattern.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
%% Plot Antenna pattern

syms x y z
% plot E-H plain gain 
fimplicit((-98 - 35 * log10(sqrt(x^2+y^2)/10))*(exp(2*(-0.3 - sqrt(x^2)))+1)==-120,[-17 17]);

% plot 3D antenna pattern (antenna direction is up)
% function expression
f = @(x,y,z) (-98 - 35 * log10(sqrt(x.^2+y.^2+z.^2)/10)).*(exp(2*(-0.3 - sqrt(x.^2+y.^2)))+1)+100;

% plot 3D antenna pattern (antenna direction has 45 degrees yaw)
alpha = pi/4;
% function expression
f = @(x,y,z) (-98 - 35 * log10(sqrt((x*cos(alpha)+z*sin(alpha)).^2+y.^2+(-x*sin(alpha)+z*cos(alpha)).^2)/10))...
    .*(exp(2*(-0.3 - sqrt((x*cos(alpha)+z*sin(alpha)).^2+y.^2)))+1)+100;
% f = @(x,y,z) (-98 - 35 * log10(sqrt(x.^2+y.^2+z.^2)/10))./(1 - 0.5*exp(1 * log(1/2) - sqrt(x.^2+z.^2)))+100; 
[x,y,z] = meshgrid(-20:.2:20,-20:.2:20,-20:.2:20);       % figure range
v = f(x,y,z);
h = patch(isosurface(x,y,z,v,0)); 
isonormals(x,y,z,v,h)              
set(h,'FaceColor','r','EdgeColor','none');
xlabel('x');ylabel('y');zlabel('z'); 
alpha(1)   
grid on; 
view([1,1,1]); 
axis equal; 
camlight; 
lighting gouraud