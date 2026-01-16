%%  AIMs recorder with 2cams
%% 1: verify Camera are connected & are in the right view

CamsNames={'Bottom-Cam';'Front-Cam'}; % do not edit
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
% n=1; v1 = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
% n=2; v2 = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
% preview(v1); preview(v2)
% closepreview(v2)
%% Assign videos objectos to variable names
aux_BOTTOM=0; aux_FRONT=0;
for n=1:2
    switch CamSettings{n}.View
        case CamsNames{1}
            v_BOTTOM = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
            aux_BOTTOM=1;
        case CamsNames{2}
            v_FRONT = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
            aux_FRONT=1;
        otherwise
            stoprunnning=true;
            fprintf('\n!!!!!\nOther names were edited in variable CamsNames \n!!!!!!!\n')
    end
end
if aux_FRONT+aux_BOTTOM~=2
    stoprunnning=true;
    fprintf('\nRepeated or unselected camera\n')
else
    fprintf('OK\n')
end

% Setting logfiles and stuff
%% ANIMAL SETTINGS
[Nmice,Mice_IDs,IntervalRec,Intervals,numSeconds,SF]=getmiceintelAIMs();

%% JUST IF CAMS R OK
if ~stoprunnning
    fprintf('\n>GOOD!, \n>Testing cams:')
    [v_FRONT,expRate_FRONT] = setsettingsvid(v_FRONT);    % logging/Color/Trigger
    [v_BOTTOM,expRate_BOTTOM] = setsettingsvid(v_BOTTOM);      % logging/Color/Trigger
    preview(v_FRONT); preview(v_BOTTOM);
    fprintf('>[OK].\n.')
    %% MAIN CODE HERE ###########################################
    % File Name
    DT=prefixdate; % Started recording/experiment
    % Init aux vars
    TimeWati=zeros(Nmice-1,1); % Inter Mice Interval !!!!
    TimeWatiUpd=TimeWati;
    esperaEnd=0;
    for t=1:numel(Intervals)        % TIME
        IntervalStr=num2str( Intervals(t) );
        
        for i=1:Nmice               % MICE
            % Files ID
            suficsID=[Mice_IDs{i},'_Min_',IntervalStr];
            FNcyl=[DT,'_FRONT_',suficsID,'.avi'];
            FNof=[DT,'_BOTTOM_',suficsID,'.avi'];
            fullFilename_FRONT = fullfile(SF, FNcyl);
            fullFilename_BOTTOM = fullfile(SF, FNof);
            
            % Create and configure the video writer
            logfile_FRONT = VideoWriter(fullFilename_FRONT, "Motion JPEG AVI");
            logfile_BOTTOM = VideoWriter(fullFilename_BOTTOM, "Motion JPEG AVI");
            logfile_FRONT.FrameRate=expRate_FRONT;
            logfile_BOTTOM.FrameRate=expRate_BOTTOM;
    %         logfile = VideoWriter(fullFilename, "Grayscale AVI");
            % Configure the device to log to disk using the video writer
            % v_FRONT.LoggingMode = "disk";
            v_FRONT.DiskLogger = logfile_FRONT;
            v_BOTTOM.DiskLogger = logfile_BOTTOM;

            %v_FRONT.FramesPerTrigger = Inf;
            
            v_FRONT.FramesPerTrigger = ceil(1.05*numSeconds*expRate_FRONT);
            v_BOTTOM.FramesPerTrigger = ceil(1.05*numSeconds*expRate_BOTTOM);

            % WAIT inter-mice-placing times:
            if i>1 && t>1
                fprintf('\n Additional wait: %2.1f seconds: \n',TimeWati(i-1))
                pause(TimeWati(i-1)); % adiditonal wait in between mice
            end
            
            if i==1
                interRecordWait=tic;        % INTER RECORDINGS INTERVALS
            end

            % R E C O R D I N G 
            fprintf('\n Recording min %1.1f / mouse: %i',Intervals(t),i);
            Trec0=tic;
            start(v_FRONT); Tvid11=toc(Trec0); start(v_BOTTOM); Tvid21=toc(Trec0);
            trigger([v_BOTTOM,v_FRONT]);
            wait([v_FRONT,v_BOTTOM],round(numSeconds*max([expRate_BOTTOM,expRate_FRONT])));

            stop(v_FRONT); Tvid12=toc(Trec0); stop(v_BOTTOM); Tvid22=toc(Trec0);
            
            % Wait for all frames to be written to disk
            while v_FRONT.FramesAcquired ~= v_FRONT.DiskLoggerFrameCount && v_BOTTOM.FramesAcquired ~= v_BOTTOM.DiskLoggerFrameCount
                pause(.1);
                fprintf('.');
            end
            fprintf('\n Recorded.\n')
            
            % S Y n C H - intel
            [~, timeStamp_BOTTOM] = getdata(v_BOTTOM);
            [~, timeStamp_FRONT] = getdata(v_FRONT);
            
            [~,t0_FRONT]=min(abs(timeStamp_FRONT-max([timeStamp_FRONT(1),timeStamp_BOTTOM(1)])));
            [~,t0_BOTTOM]=min(abs(timeStamp_BOTTOM-max([timeStamp_FRONT(1),timeStamp_BOTTOM(1)])));
            % Save Time Stamps
            indxof=strfind(FNof,'_BOTTOM_');
            NameMatDat=['/TimeStampsMATLAB_',FNof(1:indxof-1),'_',suficsID];
            save([SF,NameMatDat,],'timeStamp_BOTTOM','timeStamp_FRONT','t0_FRONT','t0_BOTTOM');

%             % PREVIO
%             fprintf('\n Recording %s:\n',FN)
%             start(v_FRONT);
%             pause(numSeconds);              % time recording!!
%             stop(v_FRONT);
%             % Wait for all frames to be written to disk
%             while v_FRONT.FramesAcquired ~= v_FRONT.DiskLoggerFrameCount
%                 pause(.1);
%             end
%             fprintf('\n Recorded.\n')


            % SWITCH ANIMAL ONLY if it's not the last one
            if i<Nmice
                espera=tic; %  TIME @ PLACING MOUSE
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
        esperaEnd=toc(interRecordWait); % TIME AFTER FIRST MICE and NEXT INTERVAL
        TimeWati=TimeWatiUpd;
        if t<numel(Intervals)
            % InterWaitRecEnd=IntervalRec*60-esperaEnd-TimeWati(1);   % SECONDS
            InterWaitRecEnd=IntervalRec*60-esperaEnd;   % SECONDS
            fprintf('\n\n>Wait for following interval in %3.2f minutes\n Clean up in the meantime',InterWaitRecEnd/60);
            pause(InterWaitRecEnd); % Process of recording
        end
    end

    %% Close Stuff
    fprintf('\n>Clearing:')
    closepreview(v_FRONT);
    closepreview(v_BOTTOM);
    delete(v_FRONT); delete(v_BOTTOM);
    clear v_FRONT v_BOTTOM
    fprintf('[COMPLETE]\n')
else
    fprintf('Check stuff')
end
%% CLOSE STUFF
clear;