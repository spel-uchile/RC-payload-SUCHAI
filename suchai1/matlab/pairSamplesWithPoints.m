function [pairedValues, Samples, Points] = pairSamplesWithPoints(values,...
    dataReceived, sizeTM, oversamplingcoeff)
%size of values and dataReceived MUST BE EQUAL

%% Detect samples not received 4 times
samplesRcv = dataReceived;
ideallyTotalPoints = (0:(floor(sizeTM/oversamplingcoeff)-1))';
pointsRcv = floor(samplesRcv./oversamplingcoeff)';
pointRepetition = [ideallyTotalPoints, histc(pointsRcv, ideallyTotalPoints)];
discardPointsIdx = pointRepetition(:,2) < oversamplingcoeff;

%% Point struct
pairedReceivedPoints = ideallyTotalPoints;
pairedReceivedPoints(discardPointsIdx) = [];
pairedLostPoints = ideallyTotalPoints;
pairedLostPoints(~discardPointsIdx) = [];

Points.received = pairedReceivedPoints';
Points.lost = pairedLostPoints';

%% Samples struct
pairedReceivedSamples = pairedReceivedPoints.*oversamplingcoeff;
for i = 1:oversamplingcoeff-1
   pairedReceivedSamples =  [pairedReceivedSamples, pairedReceivedSamples(:,end)+1];
end
pairedReceivedSamples = pairedReceivedSamples';
pairedReceivedSamples = pairedReceivedSamples(:);
ideallyTotalSamples = (0:(sizeTM-1))';
[~, idx]= intersect(ideallyTotalSamples, pairedReceivedSamples);
pairedLostSamples = ideallyTotalSamples;
pairedLostSamples(idx) = [];

Samples.received = pairedReceivedSamples;
Samples.lost = pairedLostSamples;

%% Pair Values
pairedValues = values;
[~, pairedValueIndex] = intersect(dataReceived, pairedReceivedSamples);
booleanIndex = ones(size(dataReceived));
booleanIndex(pairedValueIndex) = 0;
pairedValues(logical(booleanIndex)) = [];
end