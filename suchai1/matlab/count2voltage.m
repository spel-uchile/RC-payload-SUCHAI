function voltages = count2voltage( counts, maxVoltage, minVoltage, nbits)

maxCount = (2^nbits) - 1;

factor = (maxVoltage - minVoltage) / maxCount;

voltages = factor .* counts; 

end

