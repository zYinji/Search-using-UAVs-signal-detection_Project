% ----------------------------------------------------------------------------------------------------------
%  File: Trilateration.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function [position,X,Y] = Trilateration(data)
%% Parameters
deg_to_rad = pi/180;

distance = data(:,2);
X = [60*cos(0); 50*cos(44*deg_to_rad); 45*cos(100*deg_to_rad); 35*cos(145*deg_to_rad);...
    40*cos(170*deg_to_rad); 40*cos(235*deg_to_rad); 45*cos(270*deg_to_rad)];
Y = [60*sin(0); 50*sin(44*deg_to_rad); 45*sin(100*deg_to_rad); 35*sin(145*deg_to_rad);...
    40*sin(170*deg_to_rad); 40*sin(235*deg_to_rad); 45*sin(270*deg_to_rad)];

scatter(X,Y,'MarkerEdgeColor',[0.5 .5 .5],...  % plot figure 
              'MarkerFaceColor',[1 0 0],...
              'LineWidth',1.5);

%% Calculate the position of sender
A = [2 * (X(1:end-1) - X(2:end)) 2 * (Y(1:end-1) - Y(2:end))];
B = [(X(1:end-1).^2 - X(2:end).^2) + (Y(1:end-1).^2 - Y(2:end).^2) - (distance(1:end-1).^2 - distance(2:end).^2)];
position = inv(A'*A) * A' * B;

%% Plot sender position
hold on;
scatter(position(1),position(2),'+','LineWidth',1.5);
legend('Receiver', 'Sender');
xlabel('x axis');
ylabel('y axis');



