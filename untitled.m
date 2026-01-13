% Create a serial port object
% Replace 'COMx' with the actual serial port connected to your Arduino
s = serialport('COM7', 9600); 

% Optional: Configure terminator for reading
% This tells MATLAB to read until a newline character is encountered
configureTerminator(s, "LF"); 

% Read data in a loop
numReadings = 100; % Number of readings to take
data = zeros(numReadings, 1); % Preallocate array for data

for i = 1:numReadings
    % Read a line of data and convert to a number
    data(i) = str2double(readline(s)); 
    disp(['Received: ', num2str(data(i))]); % Display the received value
    pause(0.1); % Small pause
end

% Plot the received data (optional)
plot(data);
xlabel('Sample Number');
ylabel('Sensor Value');
title('Arduino Sensor Data in MATLAB');

% Clean up the serial port object
clear s; 