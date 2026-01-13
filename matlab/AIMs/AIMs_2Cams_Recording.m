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
aux_OF=0; aux_CYL=0;
for n=1:2
    switch CamSettings{n}.View
        case CamsNames{1}
            v_OF = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
            aux_OF=1;
        case CamsNames{2}
            v_CYL = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
            aux_CYL=1;
        otherwise
            stoprunnning=true;
            fprintf('\n!!!!!\nOther names were edited in variable CamsNames \n!!!!!!!\n')
    end
end
if aux_CYL+aux_OF~=2
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
    [v_CYL,expRate_Cyl] = setsettingsvid(v_CYL);    % logging/Color/Trigger
    [v_OF,expRate_OF] = setsettingsvid(v_OF);      % logging/Color/Trigger
    preview(v_CYL); preview(v_OF);
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
            fullFilename_cyl = fullfile(SF, FNcyl);
            fullFilename_of = fullfile(SF, FNof);
            
            % Create and configure the video writer
            logfile_cyl = VideoWriter(fullFilename_cyl, "Motion JPEG AVI");
            logfile_of = VideoWriter(fullFilename_of, "Motion JPEG AVI");
            logfile_cyl.FrameRate=expRate_Cyl;
            logfile_of.FrameRate=expRate_OF;
    %         logfile = VideoWriter(fullFilename, "Grayscale AVI");
            % Configure the device to log to disk using the video writer
            % v_CYL.LoggingMode = "disk";
            v_CYL.DiskLogger = logfile_cyl;
            v_OF.DiskLogger = logfile_of;

            %v_CYL.FramesPerTrigger = Inf;
            
            v_CYL.FramesPerTrigger = ceil(1.05*numSeconds*expRate_Cyl);
            v_OF.FramesPerTrigger = ceil(1.05*numSeconds*expRate_OF);

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
            start(v_CYL); Tvid11=toc(Trec0); start(v_OF); Tvid21=toc(Trec0);
            trigger([v_OF,v_CYL]);
            wait([v_CYL,v_OF],round(numSeconds*max([expRate_OF,expRate_Cyl])));

            stop(v_CYL); Tvid12=toc(Trec0); stop(v_OF); Tvid22=toc(Trec0);
            
            % Wait for all frames to be written to disk
            while v_CYL.FramesAcquired ~= v_CYL.DiskLoggerFrameCount && v_OF.FramesAcquired ~= v_OF.DiskLoggerFrameCount
                pause(.1);
                fprintf('.');
            end
            fprintf('\n Recorded.\n')
            
            % S Y n C H - intel
            [~, timeStamp_OF] = getdata(v_OF);
            [~, timeStamp_CYL] = getdata(v_CYL);
            
            [~,t0_CYL]=min(abs(timeStamp_CYL-max([timeStamp_CYL(1),timeStamp_OF(1)])));
            [~,t0_OF]=min(abs(timeStamp_OF-max([timeStamp_CYL(1),timeStamp_OF(1)])));
            % Save Time Stamps
            indxof=strfind(FNof,'_OF_');
            NameMatDat=['/TimeStampsMATLAB_',FNof(1:indxof-1),'_',suficsID];
            save([SF,NameMatDat,],'timeStamp_BOTTOM','timeStamp_FRONT','t0_FRONT','t0_BOTTOM');

%             % PREVIO
%             fprintf('\n Recording %s:\n',FN)
%             start(v_CYL);
%             pause(numSeconds);              % time recording!!
%             stop(v_CYL);
%             % Wait for all frames to be written to disk
%             while v_CYL.FramesAcquired ~= v_CYL.DiskLoggerFrameCount
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
    closepreview(v_CYL);
    closepreview(v_OF);
    delete(v_CYL); delete(v_OF);
    clear v_CYL v_OF
    fprintf('[COMPLETE]\n')
else
    fprintf('Check stuff')
end
%% CLOSE STUFF
clear;