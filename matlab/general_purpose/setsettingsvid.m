%       setsettingsvid
% Sets:
%   ReturnedColorspace: 'grayscale'
%   Logging Mode: 'disk'
%   triggerconfig: 'manual'
% Gets
%   Updated video object: vout
%   Actual Frame Rate: expRate
% 
function [vout,expRate] = setsettingsvid(vin)
vout=vin;
vout.ReturnedColorspace = "grayscale";
triggerconfig(vout,'immediate');
vout.LoggingMode='memory';
src = getselectedsource(vout);
disp(src)
A=src.propinfo;
if isfield(A,'FrameRate')
    frameRates = set(src, 'FrameRate');
    src.FrameRate = frameRates{1};
    actualRate = str2double( frameRates{1} );
else
    fprintf('\n [No Frame Rate in Fields, 30 fps assumed ]')
    actualRate = 30; % MAYBE
end

%% Testing to get Actual Frame Rate
fprintf('\n>Testing frame rate: ')
% Configure the number of frames to log.
vout.FramesPerTrigger = 85;
% Skip the first few frames the device provides
% before logging data.
vout.TriggerFrameDelay = 15;

% Start the acquisition.
start(vout)

% Wait for data logging to end before retrieving data.  Set the wait time
% to be equal to the expected time to acquire the number of frames
% specified plus a little buffer time to accommodate  overhead.
waittime = actualRate * (vout.FramesPerTrigger + vout.TriggerFrameDelay) + 5;
wait(vout, waittime);

% Retrieve the data and timestamps.
[~, timeStamp] = getdata(vout);
% plot(timeStamp,'x')
% xlabel('Frame Index')
% ylabel('Time(s)')
diffFrameTime = diff(timeStamp);
% plot(diffFrameTime, 'x');
% xlabel('Frame Index')
% ylabel('Time Difference(s)')
% ylim([0 .12])
avgTime = mean(diffFrameTime);
expRate = 1/avgTime;
diffRates = abs(actualRate - expRate);
percentError = (diffRates/actualRate) * 100;
fprintf('done.\n>Average fps: %3.2f \n>Error from %3.2f (%%):%3.2f\n',expRate,actualRate,percentError);
%% Return actual settings:
vout.LoggingMode='disk&memory';
triggerconfig(vout,'manual');