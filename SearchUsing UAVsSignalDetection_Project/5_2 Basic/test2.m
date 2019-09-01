x=linspace(-90,-132,43);  
y = 10 * 10 .^((-98 - x)/35);
plot(y,x);
% set(gca,'XTick',-120:10:-90);
% set(gca,'yTick',0:1:100);
grid on;
xlabel('Distance (m)');
ylabel('RSSI Value (dBm)');