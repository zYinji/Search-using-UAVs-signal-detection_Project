clear;
addpath('project_data');

data = importdata('0m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [0;data.data], 'sheet1');

data = importdata('10m_high.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [10;data.data], 'sheet2');

data = importdata('15m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [15;data.data], 'sheet3');

data = importdata('20m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [20;data.data], 'sheet4');

data = importdata('30m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [30;data.data], 'sheet5');

data = importdata('40m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [40;data.data], 'sheet6');

data = importdata('50m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [50;data.data], 'sheet7');

data = importdata('60m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [60;data.data], 'sheet8');

data = importdata('70m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [70;data.data], 'sheet9');

data = importdata('80m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [80;data.data], 'sheet10');

data = importdata('90m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [90;data.data], 'sheet11');

data = importdata('100m.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [100;data.data], 'sheet12');

data = importdata('130(110).txt');  %??txt??
xlswrite('processed_data/data.xlsx', [110;data.data], 'sheet13');

data = importdata('150(120).txt');  %??txt??
xlswrite('processed_data/data.xlsx', [120;data.data], 'sheet14');

data = importdata('150.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [150;data.data], 'sheet15');

data = importdata('175.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [175;data.data], 'sheet16');

data = importdata('around_200.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [200;data.data], 'sheet17');

data = importdata('220.txt');  %??txt??
xlswrite('processed_data/data.xlsx', [220;data.data], 'sheet18');