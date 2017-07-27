function modifiedTimeSeries = filterPayloadTimeSeries( timeSeries , indexArray, buffLen)

data = timeSeries.Data;
time = timeSeries.Time;
[data, filtered] = reconstructBufferedSignal(data, indexArray, buffLen );
time = time(1:length(data));
modifiedTimeSeries = timeseries(data, ...
    time, 'name', timeSeries.Name);
modifiedTimeSeries.DataInfo.Units = timeSeries.DataInfo.Units;
modifiedTimeSeries.DataInfo.Interpolation = timeSeries.DataInfo.Interpolation;
modifiedTimeSeries.TimeInfo.Units = timeSeries.TimeInfo.Units;
end

