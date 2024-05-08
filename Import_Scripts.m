% Call Directories where ALL scripts are
%% ADDING ALLSCRIPTS
fprintf('\n>>Loading Scripts for D.A.S.S. : ')
if exist('OpenFIeld_TurnsVideoRec.m','file')
    fprintf('already ')
else
    ActualDir=pwd;
    addpath(genpath([ActualDir,'\matlab']))
end
fprintf('done.\n\n')