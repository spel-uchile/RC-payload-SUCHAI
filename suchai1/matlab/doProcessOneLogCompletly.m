clear all;
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

%% Example: four telemetries processed
% for prefixx = {'2018_01_17_123317','2018_01_23_013627','2018_01_23_030957','2018_01_24_132449'};
%     prefix = prefixx{1};
%     dataset = 'suchai';
%     overwrite = 'yes';
%     if strfind(dataset,'suchai');
%         doPreProcessorSuchaiLogs;
%     else
%         doPreProcessor;
%     end
%     doParser;
%     doTimeSeriesFactory;
%     doPdfEstimator;
% end