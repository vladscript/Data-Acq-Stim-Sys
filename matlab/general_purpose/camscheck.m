%% Two Cams Check-Check-Check
% Checking Installed Adaptors & Cameras Connected
% Input
%   CamsNames={'OpenFieldcam';'CyLyndercam'};
% Ouput
%   CamSettings{aux}.View
%   CamSettings{aux}.Adaptor
%   CamSettings{aux}.ID
%   CamSettings{aux}.name

function CamSettings=camscheck(CamsNames)

% Ouput
CamSettings=cell(numel(CamsNames),1);
clc;
A=imaqhwinfo;
N=numel(A.InstalledAdaptors);
fprintf('\n                     Camera Adaptors installed:')
Ntotal=0;
aux=0;
for n=1:N
    camdapa=A(n).InstalledAdaptors{1};
    fprintf('\n                                      %s: % #cams:',camdapa);
    B=imaqhwinfo(camdapa);
    Ball{n}=B; % output
    Nc=numel(B.DeviceInfo);
    Ntotal=Ntotal+Nc;
    for i=1:Nc
        CamName=B.DeviceInfo(i).DeviceName;
        fprintf('\n%i [%s] - formats:',i,CamName);
        Nf=numel(B.DeviceInfo(i).SupportedFormats);
        % preview
        v=videoinput(camdapa, i);
        preview(v);
        
        % Output Text
        for j=1:Nf
            form = B.DeviceInfo(i).SupportedFormats(j);
            fprintf('\n%s',form{1})
        end
        
        % Only if Names are already assigned
        if aux<=numel(CamsNames)
            % Select Cam
            [indx,tf] = listdlg('ListString',CamsNames,'SelectionMode',...
                'single','ListSize',[150,100],'PromptString',...
                'Select camera type:');
            if tf>0
                aux=aux+1;
                CamSettings{aux}.View=CamsNames{indx};
                CamSettings{aux}.Adaptor=camdapa;
                CamSettings{aux}.ID=i;
                CamSettings{aux}.name=CamName;
                % Read Resolution
                [indx,tf] = listdlg('ListString',B.DeviceInfo(i).SupportedFormats,'SelectionMode',...
                'single','ListSize',[200,100],'PromptString',...
                'Select Resolution:');
                CamSettings{aux}.Resolution=B.DeviceInfo(i).SupportedFormats{indx};
            end
        end
        
        closepreview(v)
    end
    fprintf('\n');
end
clear v;
% fprintf('\n');
%%
