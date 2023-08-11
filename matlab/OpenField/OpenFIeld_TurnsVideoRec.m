%% Script to record 10 minutes of video of mouse in Open Field
% Camera PS
clc
fprintf('1. Make sure Camera is connected\n')
clear;
% Length Video
numSeconds = 600; % default
prompt = {'Enter recording minutes: '};
dlgtitle = 'Minutes: ';
definput = {num2str(numSeconds/60)};
dims = [1 40];
MinRec = inputdlg(prompt,dlgtitle,dims,definput);
numSeconds=60*str2double( MinRec{1} );
waitfor(MinRec);

DF = 'Open_Field_Videos';
fprintf('2. Files are going to the top Folder: (%s) of the current folder\n',DF)
fprintf('3. Video length fixed to %i seconds\n',numSeconds);
%% Settings
fprintf('\n>Checking camera: .')

% Create Figure

% Create Video Object
v = videoinput("winvideo", 1, "RGB32_320x240");
% v = videoinput("winvideo", 2, "RGB32_640x480"); % More resolution
v.ReturnedColorspace = "grayscale";
checkcam=true;
while checkcam
    preview(v)
    ansYN=questdlg('Is it the right View/Camera?');
    switch ansYN
        case 'Yes'
            fprintf(' proceed to record.')
            checkcam=false;
            % v.Running='on';
        otherwise
            closepreview;
            fprintf(' error.\n>Check camera (A)/drivers(B).')
            fprintf('For (A): use the righ camera\n For (B) do:')
            fprintf('\n 1. Go WIN+X: Device Manager')
            fprintf('\n 2. Identify the camera (exclamation point), e.g.:USB Camera-B4.09.24.1')
            fprintf('\n 3. Right click on it and choose: Update Driver')
            fprintf('\n 4. look for drivers on my computer or such')
            fprintf('\n 5. Choose from a list of drivers available on your computer');
            fprintf('\n 6. Accept the USB Camera-B4.09.24.1 or OTHER from the list');
            checkcam=false;
    end
end
%% Save
% Up folder
CF=pwd;
SEPS=strfind(CF,filesep);
CF=CF(1:SEPS(end));
SF=[CF,DF];
if ~exist(SF,'dir')
    mkdir(SF);
    fprintf('\n>Directory created')
else
    fprintf('\n>Already created destiny')
end
% File Name
DT=datestr(now); % Prefix
DT(DT==' ')='_';
DT(DT==':')='_';
% Sufix:
prompt = {'Enter suxif for the video recording (mouse ID, #Box, etc)'};
dlgtitle = 'Mouse ID';
definput = {'Mouse-0'};
dims = [1 40];
answer = inputdlg(prompt,dlgtitle,dims,definput);
FN=[DT,'_',answer{1},'.avi'];
waitfor(answer);
fullFilename = fullfile(SF, FN);

% Create and configure the video writer
logfile = VideoWriter(fullFilename, "Motion JPEG AVI");

% Configure the device to log to disk using the video writer
v.LoggingMode = "disk";
v.DiskLogger = logfile;
fprintf('\n Recording:')

%% Recording

v.FramesPerTrigger = Inf;
start(v);
pause(numSeconds); % Process of recording
stop(v);
% Wait for all frames to be written to disk
while v.FramesAcquired ~= v.DiskLoggerFrameCount
    pause(.1);
end
fprintf('\n end.\n > Cleaning:')
%% Clean Up
delete(v)
clear v
fprintf('done.\n');