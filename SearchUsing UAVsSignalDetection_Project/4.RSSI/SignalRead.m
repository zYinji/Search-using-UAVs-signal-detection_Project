% ----------------------------------------------------------------------------------------------------------
%  File: SignalRead.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function RSSI = SignalRead(input_distance)
record_times = 10; % total times of RSSI measurement

%% Set the serial port
port=serial('COM5');% COM5 port
set(port,'BaudRate',115200); % Set Baud Rate to 115200
fopen(port);% Open serial

%% Record RSSI data
filename = [num2str(input_distance) 'm_RSSI.txt'];
fileID = fopen(filename,'w');
for i = 1:record_times+3
    
    RSSI_Value = fgetl(port)
    fprintf(fileID,'%s\n',RSSI_Value);

end

fclose(fileID); % close txt file
fclose(port); % close serial trassmision
RSSI = importdata(filename);
figure;
plot(RSSI.data); % plot RSSI figure