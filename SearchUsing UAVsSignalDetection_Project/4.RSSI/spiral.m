%圆的周长是递增的
t = 0:0.01:10*pi;
A = 0;
w = 1;
sita = 0;
for ii = 1:length(t)
    x(ii) = A *cos(w*t(ii) + sita);
    y(ii) = A *sin(w*t(ii) + sita);
    A = A+ 0.1;
end
z = t*2;
figure;
% plot3(x,y,z,'r');
plot(x,y,'r');
title('螺旋线');
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');
grid on;

scatter(x, y,'MarkerFaceColor',[0 0 0],'LineWidth',0.1);