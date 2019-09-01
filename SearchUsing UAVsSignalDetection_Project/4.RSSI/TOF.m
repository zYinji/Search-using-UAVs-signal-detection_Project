x = [10;20;30;40;50;60;70];
y = [0.018;0.647/2;0.3344/3;1.40125/4;1.015/4;0.989/6;0.856/7];
plot(x,y)
% xlim([0 70]);
ylim([-0.2 1]);
xlabel('Distance (m)');
ylabel('Error rate: Error/Distance x 100%');