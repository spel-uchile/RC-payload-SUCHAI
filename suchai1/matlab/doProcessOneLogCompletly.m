disp('Processing a new SUCHAI telemetry');

prefix = '2016_18_05';
dataset = 'lab';
if strfind(dataset,'suchai');
    doPreProcessorSuchaiLogs;
else
    doPreProcessor;
end
doParser;
doTimeSeriesFactory;
doPdfEstimator;
