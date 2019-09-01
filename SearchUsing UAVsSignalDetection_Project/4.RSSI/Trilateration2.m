% ----------------------------------------------------------------------------------------------------------
%  File: Trilateration.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function [position1,position2] = Trilateration2(data,bias1,bias2)
%% Set parameters
deg_to_rad = pi/180;

distance = data(:,2);
distance = [distance(1);distance(3);distance(6)];
% distance = [distance(3);distance(4);distance(5)];
X = [60*cos(0); 45*cos(100*deg_to_rad); 40*cos(235*deg_to_rad)];
Y = [60*sin(0); 45*sin(100*deg_to_rad); 40*sin(235*deg_to_rad)];
% X = [45*cos(100*deg_to_rad); 35*cos(145*deg_to_rad);40*cos(170*deg_to_rad)];
% Y = [45*sin(100*deg_to_rad); 35*sin(145*deg_to_rad);40*sin(170*deg_to_rad)];

%% Draw locations of receivers
figure;
h1 = scatter(X,Y,'MarkerEdgeColor',[0.5 .5 .5],...  % plot figure 
              'MarkerFaceColor',[1 0 0],...
              'LineWidth',1.5);
hold on; 

%% Draw lines of receivers
X_draw = [X;X(1)];
Y_draw = [Y;Y(1)];
plot(X_draw,Y_draw)

%% Draw detection ranges of receivers
theta{1} = pi - atan(Y(2)/(X(1) - X(2))):2*pi/3600:...
           pi + atan(-40*sin(235*deg_to_rad)/(60*cos(0) - 40*cos(235*deg_to_rad)));
theta{2} = pi + atan((-Y(3)+Y(2))/(X(2)-X(3))):2*pi/3600:2*pi - atan(Y(2)/(X(1)-X(2)));
theta{3} = atan((-Y(3))/(X(1) - X(3))):2*pi/3600:atan((Y(2)-Y(3))/(X(2)-X(3)));
for i = 1:3
    r = distance(i) + bias1;
    Circle1 = X(i) + r *cos(theta{i});
    Circle2 = Y(i) + r *sin(theta{i});
    plot(Circle1,Circle2,'r','Linewidth',1);
    axis equal;
end

for i = 1:3
    r = distance(i) - bias2;
    Circle1 = X(i) + r *cos(theta{i});
    Circle2 = Y(i) + r *sin(theta{i});
    plot(Circle1,Circle2,'b','Linewidth',1);
end

%% Calculate outer intersections
% Intersections between receiver1 and receiver2
[x1,y1] = IntersectionComputing(X(1),X(2),Y(1),Y(2),distance(1)+bias1,distance(2)+bias1);
 
if norm([x1(1) y1(1)]-[X(3) Y(3)])<norm([x1(2) y1(2)]-[X(3) Y(3)]) % plot figure 
    x1 = x1(1); y1 = y1(1);
    h2 = scatter(x1, y1,'MarkerFaceColor',[0 0 0],'LineWidth',0.2);            
else
    x1 = x1(2); y1 = y1(2);
    h2 = scatter(x1, y1,'MarkerFaceColor',[0 0 0],'LineWidth',0.2);
end

% Intersections between receiver2 and receiver3
[x2,y2] = IntersectionComputing(X(2),X(3),Y(2),Y(3),distance(2)+bias1,distance(3)+bias1);
 
if norm([x2(1) y2(1)]-[X(1) Y(1)])<norm([x2(2) y2(2)]-[X(1) Y(1)]) % plot figure 
    x2 = x2(1); y2 = y2(1);
    scatter(x2, y2,'MarkerFaceColor',[0 0 0],'LineWidth',0.2);            
else
    x2 = x2(2); y2 = y2(2);
    scatter(x2, y2,'MarkerFaceColor',[0 0 0],'LineWidth',0.2);
end

% Intersections between receiver3 and receiver1
[x3,y3] = IntersectionComputing(X(3),X(1),Y(3),Y(1),distance(3)+bias1,distance(1)+bias1);
 
if norm([x3(1) y3(1)]-[X(2) Y(2)])<norm([x3(2) y3(2)]-[X(2) Y(2)]) % plot figure 
    x3 = x3(1); y3 = y3(1);
    scatter(x3, y3,'MarkerFaceColor',[0 0 0],'LineWidth',0.2);            
else
    x3 = x3(2); y3 = y3(2);
    scatter(x3, y3,'MarkerFaceColor',[0 0 0],'LineWidth',0.2);
end

position1 = double(mean([x1 y1; x2 y2; x3 y3]));

%% Calculate inner intersections
% Intersections between inner receiver1 and receiver2
[xx1,yy1] = IntersectionComputing(X(1),X(2),Y(1),Y(2),distance(1)-bias2,distance(2)+bias1);
 
if norm([xx1(1) yy1(1)]-[X(3) Y(3)])<norm([xx1(2) yy1(2)]-[X(3) Y(3)]) % plot figure 
    xx1 = xx1(1); yy1 = yy1(1);
    h3 = scatter(xx1, yy1,'k^','filled');            
else
    xx1 = xx1(2); yy1 = yy1(2);
    h3 = scatter(xx1, yy1,'k^','filled');
end

% Intersections between inner receiver1 and receiver3
[xx2,yy2] = IntersectionComputing(X(1),X(3),Y(1),Y(3),distance(1)-bias2,distance(3)+bias1);
 
if norm([xx2(1) yy2(1)]-[X(2) Y(2)])<norm([xx2(2) yy2(2)]-[X(2) Y(2)]) % plot figure 
    xx2 = xx2(1); yy2 = yy2(1);
    scatter(xx2, yy2,'k^','filled');            
else
    xx2 = xx2(2); yy2 = yy2(2);
    scatter(xx2, yy2,'k^','filled');
end

% Intersections between inner receiver2 and receiver1
[xx3,yy3] = IntersectionComputing(X(2),X(1),Y(2),Y(1),distance(2)-bias2,distance(1)+bias1);
 
if norm([xx3(1) yy3(1)]-[X(3) Y(3)])<norm([xx3(2) yy3(2)]-[X(3) Y(3)]) % plot figure 
    xx3 = xx3(1); yy3 = yy3(1);
    scatter(xx3, yy3,'k^','filled');            
else
    xx3 = xx3(2); yy3 = yy3(2);
    scatter(xx3, yy3,'k^','filled');
end

% Intersections between inner receiver2 and receiver3
[xx4,yy4] = IntersectionComputing(X(2),X(3),Y(2),Y(3),distance(2)-bias2,distance(3)+bias1);
 
if norm([xx4(1) yy4(1)]-[X(1) Y(1)])<norm([xx4(2) yy4(2)]-[X(1) Y(1)]) % plot figure 
    xx4 = xx4(1); yy4 = yy4(1);
    scatter(xx4, yy4,'k^','filled');            
else
    xx4 = xx4(2); yy4 = yy4(2);
    scatter(xx4, yy4,'k^','filled');
end

% Intersections between inner receiver3 and receiver1
[xx5,yy5] = IntersectionComputing(X(3),X(1),Y(3),Y(1),distance(3)-bias2,distance(1)+bias1);
 
if norm([xx5(1) yy5(1)]-[X(2) Y(2)])<norm([xx5(2) yy5(2)]-[X(2) Y(2)]) % plot figure 
    xx5 = xx5(1); yy5 = yy5(1);
    scatter(xx5, yy5,'k^','filled');            
else
    xx5 = xx5(2); yy5 = yy5(2);
    scatter(xx5, yy5,'k^','filled');
end

% Intersections between inner receiver3 and receiver2
[xx6,yy6] = IntersectionComputing(X(3),X(2),Y(3),Y(2),distance(3)-bias2,distance(2)+bias1);
 
if norm([xx6(1) yy6(1)]-[X(1) Y(1)])<norm([xx6(2) yy6(2)]-[X(1) Y(1)]) % plot figure 
    xx6 = xx6(1); yy6 = yy6(1);
    scatter(xx6, yy6,'k^','filled');            
else
    xx6 = xx6(2); yy6 = yy6(2);
    scatter(xx6, yy6,'k^','filled');
end

position2 = double(mean([xx1 yy1; xx2 yy2; xx3 yy3; xx4 yy4; xx5 yy5; xx6 yy6]));

xlabel('x axis');
ylabel('y axis');

legend([h1,h2,h3],'Receiver','With inner','Outer');