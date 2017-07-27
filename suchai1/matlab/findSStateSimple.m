function [stationaryIndex, comparationSignal] = findSStateSimple(...
    signal, refLevel, tolerance, span)

accumulatedMean = cummean(signal);
comparationSignal = smooth(accumulatedMean, span);
refCrossings = crossing(comparationSignal,[],refLevel);

% zero crossing method
if ~isempty(refCrossings)
    tmp = crossing( refCrossings -  mean(refCrossings) );
    refCrossIndex = tmp(1);
    if length(refCrossings) > 1
        refCrossIndex = refCrossIndex + 1;
    end
    stationaryIndex0 = refCrossings(refCrossIndex);
else
    stationaryIndex0 = length(signal) + 1;
end

% tolerance method
toleranceCandidates = abs(comparationSignal - refLevel) < tolerance;
if sum(toleranceCandidates) > 0

    usefulIndexes = find(toleranceCandidates, 10, 'first');
    [~, closestToRefLevel] = min(abs(usefulIndexes - mean(usefulIndexes)));
    stationaryIndex1 = usefulIndexes(closestToRefLevel);
else
    stationaryIndex1 = length(signal) + 1;
end

stationaryIndex = min(stationaryIndex0, stationaryIndex1);
end