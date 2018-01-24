disp('Processing a new SUCHAI telemetry');

prefix = '2018_01_23_013627';
dataset = 'suchai';
overwrite = 'yes';
if strfind(dataset,'suchai');
    doPreProcessorSuchaiLogs;
else
    doPreProcessor;
end
doParser;
doTimeSeriesFactory;
doPdfEstimator;