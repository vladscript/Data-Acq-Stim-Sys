%% Script to record 10 minutes of video of mouse in Open Field
% Camera PS
clc
fprintf('1. Make sure Camera is connected\n')
clear;

CamsNames={'OpenFieldcam'}; % do not edit
CamSettings=camscheck(CamsNames);
ViewOK=questdlg({'Cameras displayed correctly?'});
stoprunnning=false;
switch ViewOK
    case 'Yes'
        disp('>Ready to go on ..')
    otherwise
        stoprunnning=true;
        runadvice;
end

if ~stoprunnning
    n=1; % ONE CAM
    v = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
    [v,expRate_OF] = setsettingsvid(v);      % logging/Color/Trigger
    triggerconfig(v,'immediate');
end

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
preview(v)

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