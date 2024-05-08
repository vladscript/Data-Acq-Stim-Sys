%% TODO
% replace pauses by timers -> feedback for the user tic toc & fprints
%% Script to record LID animals using a single Cylinder
% Camera PS
clc
fprintf('1. Make sure Camera is connected\n')
clear;
%% Camera
fprintf('\n>Checking camera: .')
CamsNames={'CyLyndercam'}; % do not edit
CamSettings=camscheck(CamsNames);
ViewOK=questdlg({'Cameras displayed correctly?'});
stoprunnning=false;
disp('sequential multiple mice - two cams')
switch ViewOK
    case 'Yes'
        disp('>Ready to go on ..')
    otherwise
        stoprunnning=true;
        runadvice;
end
%% Assign videos objects to variable
n=1; aux_OF=0; aux_CYL=0;
switch CamSettings{n}.View
    case 'CyLyndercam'
        v_CYL = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
        aux_CYL=1;
    otherwise
        stoprunnning=true;
        fprintf('\n!!!!!\nOther names were edited in variable CamsNames \n!!!!!!!\n')
end

if aux_CYL+aux_OF>1
    stoprunnning=true;
    fprintf('\nRepeated selection of camera\n')
else
    fprintf('Single camera OK\n')
    stoprunnning=false;
end

checkcam=true;
while checkcam
    preview(v_CYL)
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
            runadvice;
            checkcam=false;
    end
end
% VIDEO SETTINGS
% v_CYL=setsettingsvid(v_CYL); % logging/Color/Trigger
%% ANIMAL INFO
[Nmice,Mice_IDs,IntervalRec,Intervals,numSeconds,SF]=getmiceintelAIMs();

%% MAIN LOOP
% File Name
DT=prefixdate; % Started recording/experiment
% Init
TimeWati=zeros(Nmice-1,1); % Inter Mice Interval !!!!
TimeWatiUpd=TimeWati;
% Sufix:
esperaEnd=0;
for t=1:numel(Intervals)        % TIME
    IntervalStr=num2str( Intervals(t) );
    interRecordWait=tic;        % INTER REORDINGS INTERVALS
    for i=1:Nmice               % MICE
        % File ID
        FN=[DT,'_',Mice_IDs{i},'_Min_',IntervalStr,'.avi'];
        fullFilename = fullfile(SF, FN);
        % Create and configure the video writer
        logfile = VideoWriter(fullFilename, "Motion JPEG AVI");
%         logfile = VideoWriter(fullFilename, "Grayscale AVI");
        % Configure the device to log to disk using the video writer
        v_CYL.LoggingMode = "disk";
        v_CYL.DiskLogger = logfile;
        v_CYL.FramesPerTrigger = Inf;
        
        % WAIT
        if i>1
            fprintf('\n Additional wait: %2.1f seconds: \n',TimeWati(i-1))
            pause(TimeWati(i-1)); % adiditonal wait in between mice
        end
        fprintf('\n Recording %s:\n',FN)
        start(v_CYL);
        pause(numSeconds);              % time recording!!
        stop(v_CYL);
        % Wait for all frames to be written to disk
        while v_CYL.FramesAcquired ~= v_CYL.DiskLoggerFrameCount
            pause(.1);
        end
        fprintf('\n Recorded.\n')
        % SWITCH ANIMAL ONLY if it's not the last one
        if i<Nmice
            espera=tic;
            WACHA=true;
            while WACHA
                okans=questdlg({'Confirm another animal is placed in the cylynder:'});
                if strcmp(okans,'Yes')
                    WACHA=false;
                end
            end
            TimeWatiUpd(i)=toc(espera); % Inter Mice Wait (Variable)
        end

    end
    TimeWati=TimeWatiUpd;
    esperaEnd=toc(interRecordWait);
    if t<numel(Intervals)
        if ~isempty(TimeWati)
            InterWaitRecEnd=IntervalRec*60-esperaEnd-TimeWati(1);% seconds
            fprintf('\n\n>Wait for following interval in %3.2f minutes\n Clean up in the meantime',InterWaitRecEnd/60);
            pause(InterWaitRecEnd); % Process of recording
        end
    end
end

%% Clean Up
delete(v_CYL)
clear v_CYL
fprintf('\ndone.\n');