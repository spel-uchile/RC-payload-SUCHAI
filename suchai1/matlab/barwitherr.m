function [hBar, hErrorBar] = barwitherr(x,y,error)

hb = bar(x,y);
% For each set of bars, find the centers of the bars, and write error bars
% pause(0.1); %pause allows the figure to be created
lower = zeros(size(error));
for ib = 1:numel(hb)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = hb(ib).XData+hb(ib).XOffset;
    he(ib) = errorbar(xData,y(ib,:),lower(ib,:),error(ib,:),'k*');
end

hBar = hb;
hErrorBar = he;
end