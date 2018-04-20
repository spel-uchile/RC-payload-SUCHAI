clear all;
disp('Processing a telemetry');

%% when running for the first time uncommnet this values
datasets = {'suchai','tektronix','lab'};
overwrite = 'no';
normalization = 'diffByMeanDivByStd';
for i = 1 : length(datasets)
    dataset = datasets{i};
    if strfind(dataset,'tektronix');
        %         doTimeSeriesTektronix;
    end
    
    seedFolder = ['./logs/',dataset];
    datesOfExec = dir(seedFolder);
    datesOfExec = {datesOfExec.name};
    datesOfExec = datesOfExec(3:end);
    datesOfExec = sortn(datesOfExec);
    datesOfExec = lower(datesOfExec);
    
%     for j = 1 : length(datesOfExec)
%         prefix = datesOfExec{j};
%         if strfind(dataset,'suchai');
%             doPreProcessorSuchaiLogs;
%             doParser;
%             doTimeSeriesFactory;
%         elseif strfind(dataset,'lab');
%             doPreProcessor;
%             doParser;
%             doTimeSeriesFactory;
%         end
%     end
    doPdfEstimator;
end
%% Aleluya sound
Data = load('handel.mat');
sound(Data.y, Data.Fs)