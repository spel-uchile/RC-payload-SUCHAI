disp('Processing a new SUCHAI telemetry');

%% when running for the first time uncommnet this values
% prefix = '2016_18_05';
% dataset = 'lab';
overwrite = 'yes';
if strfind(dataset,'suchai');
    doPreProcessorSuchaiLogs;
else
    doPreProcessor;
end
doParser;
doTimeSeriesFactory;
doPdfEstimator;