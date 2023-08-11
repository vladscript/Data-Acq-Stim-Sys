% % Script to test code/times /proofs of concept
%% Test trigger 2 cams
clc; clear;
Tcam0=tic;
% DRUATION ###############
Tsec=5; % seconds

% CAMS *******************

fprintf('\n>Checking cameras: .')
CamsNames={'CyLyndercam','OpenFieldcam'}; % do not edit
CamSettings=camscheck(CamsNames);
for n=1:numel(CamSettings)
    switch CamSettings{n}.View
        case 'OpenFieldcam'
            v_OF = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
        case 'CyLyndercam'
            v_CYL = videoinput(CamSettings{n}.Adaptor, CamSettings{n}.ID, CamSettings{n}.Resolution);
        otherwise
            stoprunnning=true;
            fprintf('\n!!!!!\nOther names were edited in variable CamsNames \n!!!!!!!\n')
    end
    fprintf('\nCAM %i  XXXXXXXXXXXXXXX\n',n)
end
[v_CYL,expRate_Cyl] = setsettingsvid(v_CYL);    % logging/Color/Trigger
[v_OF,expRate_OF] = setsettingsvid(v_OF);      % logging/Color/Trigger


% FILES
FN_1=[prefixdate,'_M_666_.avi'];
FN_2=[prefixdate,'_M_007_.avi'];
SF=pwd;
INdxSep=strfind(SF,filesep);
fullFilename_1 = fullfile(SF(1:INdxSep(end-1)), FN_1);
fullFilename_2 = fullfile(SF(1:INdxSep(end-1)), FN_2);
% Create and configure the video writer
logfile_1 = VideoWriter(fullFilename_1, "Motion JPEG AVI");
logfile_2 = VideoWriter(fullFilename_2, "Motion JPEG AVI");
% Set it into video object:
v_CYL.DiskLogger = logfile_1; % This is tended to change from time to time
v_OF.DiskLogger = logfile_2;

fps_1=expRate_Cyl;
fps_2=expRate_OF;



v_CYL.FramesPerTrigger = ceil(1.05*Tsec*fps_1);
v_OF.FramesPerTrigger = ceil(1.05*Tsec*fps_2);



Tcam1=toc(Tcam0);
fprintf('ready [->]\n')
%% Preview
Tpre0=tic;
preview(v_CYL); preview(v_OF);
Tpre1=toc(Tpre0);
fprintf('>Time loading camera: %3.2f [s] and previewing: %3.2f [s]',Tcam1,Tpre1);
%% Record
fprintf('\n Recording ');
Trec0=tic;
start(v_CYL); Tvid11=toc(Trec0); start(v_OF); Tvid21=toc(Trec0);
trigger([v_OF,v_CYL]);
wait([v_CYL,v_OF],round(Tsec*max([fps_1,fps_2])));
% [~, timeStamp] = getdata(v_OF);

% timmerr(10);
% pause(5)


stop(v_CYL); Tvid12=toc(Trec0); stop(v_OF); Tvid22=toc(Trec0);
% Wait for all frames to be written to disk
while v_CYL.FramesAcquired ~= v_CYL.DiskLoggerFrameCount && v_OF.FramesAcquired ~= v_OF.DiskLoggerFrameCount
    pause(.1);
    fprintf('.');
end
fprintf('\n Recorded.\n')
%% SYNCHING
[~, timeStamp_OF] = getdata(v_OF);
[~, timeStamp_CYL] = getdata(v_CYL);
%% Close ALL
closepreview(v_CYL)
closepreview(v_OF)
delete(v_CYL); delete(v_OF);
clear v_CYL v_OF
Tend=toc(Tcam0);
fprintf('\n>Total Time %3.2f \n',Tend);