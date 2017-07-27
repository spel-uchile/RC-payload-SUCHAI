function [newVin, newVout] = filterMemSDSimulation( tsVin, tsVout , nSampled, nNonSampled, nWaiting)


time = tsVin.Time;
vinValues = tsVin.Data;
voutValues = tsVout.Data;
dt = tsVin.TimeInfo.Increment;
nValuesPerRound = nSampled + nNonSampled + nWaiting;
rounds = floor(length(time) / nValuesPerRound);

newLength = rounds * nSampled;
timeMin = min(time);
timeMax = dt*(newLength-1);
newtime = timeMin : dt : timeMax;
newVinValues = zeros(newLength, 1);
newVoutValues = zeros(size(newVinValues));
globalIndex = 1;
filterIndex = 1;

for i = 1 : rounds
   for j = 1 : nNonSampled
       globalIndex = globalIndex + 1;
   end
   for j = 1 : nSampled
       newVinValues(filterIndex) = vinValues(globalIndex);
       newVoutValues(filterIndex) = voutValues(globalIndex);
       globalIndex = globalIndex + 1;
       filterIndex = filterIndex + 1;
   end
   for j = 1 : nWaiting
       globalIndex = globalIndex + 1;
   end
end

newVin = timeseries(newVinValues, newtime, 'name', tsVin.Name);
newVout = timeseries(newVoutValues, newtime, 'name', tsVout.Name);
newVin.DataInfo.Units = tsVin.DataInfo.Units;
newVout.DataInfo.Units = tsVout.DataInfo.Units;
newVin.DataInfo.Interpolation = tsVin.DataInfo.Interpolation;
newVout.DataInfo.Interpolation = tsVout.DataInfo.Interpolation;
newVin.TimeInfo.Units = tsVin.TimeInfo.Units;
newVout.TimeInfo.Units = tsVout.TimeInfo.Units;
end