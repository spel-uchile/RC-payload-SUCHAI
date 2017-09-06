function [pairedValues, Samples, Points] = pairSamplesWithPoints(values, dataReceived, sizeTM, oversamplingcoeff)

samplesrcv = dataReceived;
pointsrcv = floor(samplesrcv./oversamplingcoeff);
pointsThatGenerateSamples = unique(pointsrcv);
pointRepetition = [pointsThatGenerateSamples; histc(pointsrcv(:)',pointsThatGenerateSamples)]';
pointsNotFullyRepeatedIdx = pointRepetition(:,2) < oversamplingcoeff;
pointValues = pointRepetition(pointsNotFullyRepeatedIdx,1);
[~, discardIdx] = intersect(pointsrcv, pointValues);

%% Samples & Values
pairedReceivedSamples = dataReceived;
pairedReceivedSamples(discardIdx) = [];  %remove incomplete samples
pairedValues = values;
pairedValues(discardIdx) = [];
pairedLostSamples = 0: sizeTM-1;
[~, receivedSampIdx] = intersect(pairedLostSamples, pairedReceivedSamples);
pairedLostSamples(receivedSampIdx) = [];
Samples.received = pairedReceivedSamples;
Samples.lost = pairedLostSamples;

%% Points
pairedReceivedPoints = pointsrcv;
pairedReceivedPoints(discardIdx) = [];
pairedReceivedPoints = unique(pairedReceivedPoints);
pairedLostPoints = 0: ((sizeTM/oversamplingcoeff)-1);
[~, receivedPointsIndex] = intersect(pairedLostPoints, pairedReceivedPoints);
pairedLostPoints(receivedPointsIndex) = [];
Points.received = pairedReceivedPoints;
Points.lost = pairedLostPoints;

end