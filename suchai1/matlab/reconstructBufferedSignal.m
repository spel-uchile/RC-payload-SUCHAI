function [joinedSlices, filtered]= reconstructBufferedSignal(originalSignal, indexArray, buffLen )

joinedSlices = [];
filtered = zeros(size(originalSignal));
refLevel = mean(originalSignal);
for k = 1 : length(indexArray)
    firstNonUsefulDataIndex = (k-1) * buffLen + 1;
    firstUsefulDataIndex = indexArray(k) + firstNonUsefulDataIndex - 1;
    lastNonUsefulDataIndex = firstUsefulDataIndex - 1;
    lastUsefulDataIndex = k * buffLen;
    
    if indexArray(k) > buffLen
        lastNonUsefulDataIndex = lastUsefulDataIndex;
        filtered(firstNonUsefulDataIndex : lastNonUsefulDataIndex) = refLevel;
        continue
    end
    
    if lastUsefulDataIndex >= length(originalSignal)
        lastUsefulDataIndex = length(originalSignal);
    end
    usefulSliceOfSignal = originalSignal( firstUsefulDataIndex : lastUsefulDataIndex);
    joinedSlices = [joinedSlices; usefulSliceOfSignal];
    filtered(firstNonUsefulDataIndex : lastNonUsefulDataIndex,1) = refLevel;
    filtered(firstUsefulDataIndex : lastUsefulDataIndex,1) = usefulSliceOfSignal;
end
end

