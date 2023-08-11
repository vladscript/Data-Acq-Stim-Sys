function DT=prefixdate
DT=datestr(now); % Prefix
DT(DT==' ')='_';
DT(DT==':')='_';