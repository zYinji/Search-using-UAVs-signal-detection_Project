%圆的周长是递增的
t = 0:0.01:10*pi;
A = 1;
w = 1;
sita = 0;
for ii = 1:length(t)
    x(ii) = A *cos(w*t(ii) + sita)-1;
    y(ii) = A *sin(w*t(ii) + sita);
    A = A+ 0.0009*A;
end
figure;
plot(x,y,'k','LineWidth',1);
title('螺旋线');
xlabel('x axis');
ylabel('y axis');
grid on;
axis equal