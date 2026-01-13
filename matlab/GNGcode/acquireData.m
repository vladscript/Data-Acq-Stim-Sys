function acquireData
global globalTime;
global globalData;
global timeIndex;
% globalTime=[];
% globalData=[];

timeIndex = 1;

% Creating session
s = daq.createSession('ni');
channels = [0 1 2 3 4 6];
s.addAnalogInputChannel('Dev1',channels,'voltage');
s.Rate = 1000; % Cannot exceed 1666.6667 for six channels.
s.DurationInSeconds = input('duration in sec: '); % Change this to change duration of experiment.

globalTime = zeros(s.Rate*120,1);
globalData = zeros(s.Rate*120,size(channels,2));
% The factor of 2 is to make sure there's enough space in global vars.
fid_time = fopen('time.csv', 'w');
fid_data_1 = fopen('data_1.csv', 'w');
fid_data_2 = fopen('data_2.csv', 'w');
fid_data_3 = fopen('data_3.csv', 'w');
fid_data_4 = fopen('data_4.csv', 'w');
fid_data_5 = fopen('data_5.csv', 'w');
fid_data_6 = fopen('data_6.csv', 'w');

figure;
a1 = subplot(3,2,2);
h1 = plot(globalTime,globalData(:,1));
xlim(a1, [0 120]);
title('reward')

a2 = subplot(3,2,1);
h2 = plot(globalTime,globalData(:,2));
xlim(a2, [0 120]);
title('movement')

a3 = subplot(3,2,3);
h3 = plot(globalTime,globalData(:,3));
xlim(a3, [0 120]);
title('licking')

a4 = subplot(3,2,4);
h4 = plot(globalTime,globalData(:,4));
xlim(a4, [0 120]);
title('punishment')

a5 = subplot(3,2,5);
h5 = plot(globalTime,globalData(:,5));
xlim(a5, [0 120]);
title('visual stim')

a6 = subplot(3,2,6);
h6 = plot(globalTime,globalData(:,6));
xlim(a6, [0 120]);
title('other')

% Handle (whenever data is available, call the function inside)
lh = s.addlistener('DataAvailable', @(src,event)plotData(fid_time,fid_data_1, fid_data_2,... 
    fid_data_3, fid_data_4, fid_data_5, fid_data_6, event, h1,h2,h3,h4,h5,h6,...
    a1,a2,a3,a4,a5,a6));



s.startBackground();
s.wait();
delete(lh);


end