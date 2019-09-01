%% Parameters
deg_to_rad = pi/180;

% distance = [50.12; 60.78; 70.89];
distance = [50+rand(1); 60+rand(1); 70+rand(1);40+rand(1); 40+rand(1);70+rand(1);60+rand(1)];
X = [50*cos(0); 60*cos(44*deg_to_rad); 70*cos(100*deg_to_rad);40*cos(145*deg_to_rad);...
    40*cos(170*deg_to_rad); 70*cos(235*deg_to_rad); 60*cos(270*deg_to_rad)];
Y = [50*sin(0); 60*sin(44*deg_to_rad); 70*sin(100*deg_to_rad);40*sin(145*deg_to_rad);...
    40*sin(170*deg_to_rad); 70*sin(235*deg_to_rad); 60*sin(270*deg_to_rad)];
% distance = [distance(1);distance(6);distance(7)];
% X = [X(1);X(6);X(7)];
% Y = [Y(1);Y(6);Y(7)];
% % X = X(1,6,7);
% % Y = Y(1,6,7);
scatter(X,Y,'MarkerEdgeColor',[0.5 .5 .5],...  % plot figure 
              'MarkerFaceColor',[1 0 0],...
              'LineWidth',1.5);

%% Calculate the position of sender
A = [2 * (X(1:end-1) - X(2:end)) 2 * (Y(1:end-1) - Y(2:end))];
B = [(X(1:end-1).^2 - X(2:end).^2) + (Y(1:end-1).^2 - Y(2:end).^2) - (distance(1:end-1).^2 - distance(2:end).^2)];
position = inv(A'*A) * A' * B;

hold on;
scatter(position(1),position(2),'+','LineWidth',1.5);
legend('Receiver', 'Sender');
xlabel('x axis');
ylabel('y axis');