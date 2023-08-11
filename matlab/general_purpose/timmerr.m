% Timer
% Input
% T:    Seconds
function timmerr(T)
preB=0;
TA=tic;
while toc(TA)<=T
    B=toc(TA);
    if floor(B)>preB
        fprintf('\n> Seconds: %i',T-floor(B));
        preB=B;
    end
end
fprintf('\n> END');