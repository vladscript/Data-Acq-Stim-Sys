%% GET Animal INTEL
function [Nmice,Mice_IDs,IntervalRec,Intervals,numSeconds,SF]=getmiceintelAIMs()
%% N mice

Nmice = 4;  % default
prompt = {'Enter number of mice to record: '};
dlgtitle = 'Mice: ';
definput = {num2str(Nmice)};
dims = [1 40];
MinRec = inputdlg(prompt,dlgtitle,dims,definput);
Nmice=str2double( MinRec{1} );
waitfor(MinRec);
% Animals ID
for i=1: Nmice
    MiceIDsLabel{i}=['Mouse #',num2str(i-1),'ID'];
    DefaaulIDs{i}=['Cage_A_M_',num2str(i-1)];
end
Mice_IDs=inputdlg(MiceIDsLabel,'IDs',[1 75],DefaaulIDs);
%% Intervals
prompt = {'Enter times intervals (minutes):','Final time (minutes):'};
dlgtitle = 'MINUTES';
dims = [1 35];
definput = {'20','180'};
TInter = inputdlg(prompt,dlgtitle,dims,definput);
waitfor(MinRec);
IntervalRec=str2double(TInter{1});
EndTime=str2double(TInter{2});
Intervals=[0:IntervalRec:EndTime];
fprintf('\n %i intervasl to record:',numel(Intervals))
disp(Intervals)
%% Length Video
numSeconds = 60;
prompt = {'Enter recording minutes: '};
dlgtitle = 'Minutes: ';
definput = {num2str(numSeconds/60)};
dims = [1 40];
MinRec = inputdlg(prompt,dlgtitle,dims,definput);
numSeconds=60*str2double( MinRec{1} );
waitfor(MinRec);
%%
DF = 'AIMs_Cylinder_Videos';
fprintf('2. Files are going to the top Folder: (%s) of the current folder\n',DF)
fprintf('3. Video length fixed to %i seconds\n',numSeconds);
%% Directory Save
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