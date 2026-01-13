function plotData(fid_time, fid_data_1, fid_data_2, fid_data_3, fid_data_4,...
    fid_data_5, fid_data_6, event, h1,h2,h3,h4,h5,h6, a1,a2,a3,a4,a5,a6)
global globalTime;
global globalData;
global timeIndex;

if (mod(event.TimeStamps(1),120) == 0)
    globalTime = zeros(1000*120,1);
    globalData = zeros(1000*120,6);
    timeIndex = 1;
    xlim(a1, [event.TimeStamps(1) event.TimeStamps(1)+120]);
    xlim(a2, [event.TimeStamps(1) event.TimeStamps(1)+120]);
    xlim(a3, [event.TimeStamps(1) event.TimeStamps(1)+120]);
    xlim(a4, [event.TimeStamps(1) event.TimeStamps(1)+120]);
    xlim(a5, [event.TimeStamps(1) event.TimeStamps(1)+120]);
    xlim(a6, [event.TimeStamps(1) event.TimeStamps(1)+120]);
end

globalTime(timeIndex:(timeIndex + length(event.TimeStamps) - 1),1) = event.TimeStamps;
globalData(timeIndex:(timeIndex + length(event.TimeStamps) - 1),:) = event.Data;
set(h1,'XData',globalTime(1:(timeIndex+length(event.TimeStamps)-1),1),'YData',globalData(1:(timeIndex+length(event.TimeStamps)-1),1));
set(h2,'XData',globalTime(1:(timeIndex+length(event.TimeStamps)-1),1),'YData',globalData(1:(timeIndex+length(event.TimeStamps)-1),2));
set(h3,'XData',globalTime(1:(timeIndex+length(event.TimeStamps)-1),1),'YData',globalData(1:(timeIndex+length(event.TimeStamps)-1),3));
set(h4,'XData',globalTime(1:(timeIndex+length(event.TimeStamps)-1),1),'YData',globalData(1:(timeIndex+length(event.TimeStamps)-1),4));
set(h5,'XData',globalTime(1:(timeIndex+length(event.TimeStamps)-1),1),'YData',globalData(1:(timeIndex+length(event.TimeStamps)-1),5));
set(h6,'XData',globalTime(1:(timeIndex+length(event.TimeStamps)-1),1),'YData',globalData(1:(timeIndex+length(event.TimeStamps)-1),6));

timeIndex = length(event.TimeStamps) + timeIndex;

    
% Place data in file
fprintf(fid_time,'%f\n',event.TimeStamps);
fprintf(fid_data_1,'%f\n',event.Data(:,1));
fprintf(fid_data_2,'%f\n',event.Data(:,2));
fprintf(fid_data_3,'%f\n',event.Data(:,3));
fprintf(fid_data_4,'%f\n',event.Data(:,4));
fprintf(fid_data_5,'%f\n',event.Data(:,5));
fprintf(fid_data_6,'%f\n',event.Data(:,6));

end

