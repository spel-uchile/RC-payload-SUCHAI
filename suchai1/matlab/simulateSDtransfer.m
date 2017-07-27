function modifiedTimeSeries = simulateSDtransfer(vinTimeSeries, nValuesPerRound, nWaitingUnits, varargin)

time = vinTimeSeries.Time;
vinValues = vinTimeSeries.Data;
dtVin = vinTimeSeries.TimeInfo.Increment;
rounds = floor(length(time) / nValuesPerRound);

newLength = rounds*(nWaitingUnits + nValuesPerRound);
simulationValues = zeros(newLength, 1);
simulationGlobalIndex = 1;
dataGlobalIndex = 1;
maxValue = max(vinValues);
minValue = min(vinValues);
limitValues = [minValue, maxValue];

for i = 1 : rounds
    for j = 1 : nValuesPerRound
        simulationValues(simulationGlobalIndex) = vinValues(dataGlobalIndex);
        simulationGlobalIndex = simulationGlobalIndex + 1;
        dataGlobalIndex = dataGlobalIndex + 1;
    end
    option = varargin{1};
    if strcmp(option, 'option1')
        temp = randi([1, 2]);
        standbyValue = limitValues(temp);
    elseif strcmp(option, 'option2')
        standbyValue = vinValues(dataGlobalIndex-1);
    elseif strcmp(option, 'option3')
        standbyValue = mean(vinValues);
    else
        error(['varargin{1} ', option, ' not recognized']);
    end
    
    for j = 1 : nWaitingUnits
        simulationValues(simulationGlobalIndex) = standbyValue;
        simulationGlobalIndex = simulationGlobalIndex + 1;
    end
end

timeMin = min(time);
timeMax = dtVin*(newLength-1);
newtime = timeMin : dtVin : timeMax;

modifiedTimeSeries = timeseries(simulationValues, newtime);
modifiedTimeSeries.Name = vinTimeSeries.Name;
modifiedTimeSeries = setuniformtime(modifiedTimeSeries,'StartTime',timeMin,'EndTime',timeMax);
modifiedTimeSeries.DataInfo.Units = vinTimeSeries.DataInfo.Units;
modifiedTimeSeries.DataInfo.Interpolation = vinTimeSeries.DataInfo.Interpolation;

end

