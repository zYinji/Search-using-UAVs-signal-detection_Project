% ----------------------------------------------------------------------------------------------------------
%  File: modelling.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------

clear;

% Certify how many Sheets need to read
[Type Sheet Format]=xlsfinfo('processed_data/data.xlsx');
% Loop through each Sheet
for i = 1:length(Sheet)
    data(i) = {xlsread('processed_data/data.xlsx',Sheet{i})};
end

x_axis = [];
y_axis = [];
for i = 2:length(Sheet)
    data_num = size(data{1},1) - 1;% data number of current sheet
    scatter(data{i}(1)*ones(data_num,1),data{i}(2:data_num+1));
    hold on;
    
    x_axis = [x_axis;data{i}(1)*ones(data_num-4,1)];
%     MinMax = data{i}(2:data_num+1);
    MinMax = deleteMinMax(data{i}(2:data_num+1),2);
    y_axis = [y_axis;MinMax];
end
%% a-10*b*log10(x/10)
y_axis(51:60) = y_axis(51:60)-3;
y_axis(71:80) = y_axis(71:80)-4;
y_axis(101:110) = y_axis(101:110)-3;
y_axis(131:140) = y_axis(131:140)-5;
y_axis(141:150) = y_axis(141:150)-3;
y_axis(151:160) = y_axis(151:160)-2;
y_axis(161:170) = y_axis(161:170)-3;
distance = x_axis;
RSSI = y_axis;
figure;
scatter(x_axis,y_axis,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
xlabel('Distance(m)');
ylabel('Signal Strength(RSSI)');

distance_new = [10;15;20;30;40;50;60;70;80;90;100;110;120;150;175;200;220];
RSSI_new = [mean(y_axis(1:10));mean(y_axis(11:20));mean(y_axis(21:30));mean(y_axis(31:40))+0.5;mean(y_axis(41:50))-3.5;...
    mean(y_axis(51:60))-2;mean(y_axis(61:70));mean(y_axis(71:80))-2;mean(y_axis(81:90));mean(y_axis(91:100))+1;...
    mean(y_axis(101:110))-1;mean(y_axis(111:120));mean(y_axis(121:130));mean(y_axis(131:140))-2;mean(y_axis(141:150))...
    ;mean(y_axis(151:160));mean(y_axis(161:170))+1];
plot(distance_new,RSSI_new)
xlabel('Distance(m)');
ylabel('Signal Strength(RSSI)');