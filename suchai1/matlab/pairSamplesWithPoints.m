function [pairedValues, Samples, Points] = pairSamplesWithPoints(values, dataReceived, sizeTM, oversamplingcoeff)

samplesrcv = dataReceived;
pointsrcv = floor(samplesrcv./oversamplingcoeff);
pointsThatGenerateSamples = unique(pointsrcv);
pointRepetition = [pointsThatGenerateSamples; histc(pointsrcv(:)',pointsThatGenerateSamples)]';
pointsNotFullyRepeated = find(pointRepetition(:,2) < oversamplingcoeff);

tmp = pointsNotFullyRepeated.* oversamplingcoeff;
samplesToDiscard = [tmp, tmp+1, tmp+2, tmp+3];
samplesToDiscard = samplesToDiscard';
samplesToDiscard = samplesToDiscard(:)';

%% values
[vals, samplesToDiscardIndex] = intersect(dataReceived,samplesToDiscard);
pairedValues = values;
pairedReceivedSamples = dataReceived;

pairedValues(samplesToDiscardIndex) = [];

%% samples
pairedReceivedSamples(samplesToDiscardIndex) = [];  %remove incomplete samples
pairedLostSamples = 0: sizeTM-1;
[~, receivedSamplesIndex] = intersect((0:sizeTM-1),pairedReceivedSamples);
pairedLostSamples(receivedSamplesIndex) = [];

Samples.received = pairedReceivedSamples;
Samples.lost = pairedLostSamples;

%% Points
pairedReceivedPoints = unique(floor(pairedReceivedSamples./oversamplingcoeff));
pairedLostPoints = 0: ((sizeTM/oversamplingcoeff)-1);
[~, receivedPointsIndex] = intersect(pairedLostPoints, pairedReceivedPoints);
pairedLostPoints(receivedPointsIndex) = [];
Points.received = pairedReceivedPoints;
Points.lost = pairedLostPoints;

end