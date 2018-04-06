clear all;
disp('Processing a telemetry');

%% when running for the first time uncommnet this values
datasets = {'suchai','tektronik','lab',};
for i = 1 : length(datasets)
    dataset = datasets{i};
    seedFolder = ['./logs/',dataset];
    datesOfExec = dir(seedFolder);
    datesOfExec = {datesOfExec.name};
    datesOfExec = datesOfExec(3:end);
    datesOfExec = sortn(datesOfExec);
    datesOfExec = lower(datesOfExec);
    
    for j = 1 : length(datesOfExec)
        prefix = datesOfExec{j};
        overwrite = 'yes';
        if strfind(dataset,'suchai');
            doPreProcessorSuchaiLogs;
            doParser;
            doTimeSeriesFactory;
        elseif strfind(dataset,'tektronix');
            doTimeSeriesTektronix;
        else
            doPreProcessor;
            doParser;
            doTimeSeriesFactory;
        end
    end
    doPdfEstimator;
end
%% Aleluya sound
Data = load('handel.mat');
sound(Data.y, Data.Fs)

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