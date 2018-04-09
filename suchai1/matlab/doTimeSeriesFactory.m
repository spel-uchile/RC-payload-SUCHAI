% This script takes preprocessor files with vin and vout values in separted
% files and modifies and saves them in MAT-files for further time series
% creation.

% 'prefix' is an important variable that is a string with the date of the
% telemtry to be processed e.g: '2018_03_07_150000'

prefixjoin = [prefix(1:4), prefix(6:7), prefix(9:end)];
parserFolder = ['./parser/', dataset];
fixtureFolder = strcat(parserFolder,'/', prefix);
parserFiles = dir(fixtureFolder);
parserFiles = {parserFiles.name};
parserFiles = parserFiles(3:end)';
parserFiles = sortn(parserFiles);

charIndexForInputFixture = strfind(lower(parserFiles), 'input');
fixtureIndexForInputParserFiles = find(~cellfun(@isempty, charIndexForInputFixture));
inputFixture = strcat(fixtureFolder,'/', parserFiles{fixtureIndexForInputParserFiles});
outputFixture = cell(1, length(parserFiles) - 1);
fixtureIndexForOutputFiles = 0;
for i = 1 : length(parserFiles)
    fixtureIndexForOutputFiles = fixtureIndexForOutputFiles + 1;
    
    if i ~= fixtureIndexForInputParserFiles
        outputFixture{fixtureIndexForOutputFiles} = strcat(fixtureFolder,'/',...
            parserFiles{fixtureIndexForOutputFiles});
        S = load(outputFixture{fixtureIndexForOutputFiles});
        name = fieldnames(S);
        adcPeriod = S.(name{1}).adcPeriod;
        sampCoeff = S.(name{1}).oversamplingCoeff;
        fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);
        if ~exist('normalization','var')
            normalization = 'raw';
        end
        saveFolder = strcat(['./mat/ts-',normalization,'/',dataset,'/'], num2str(fsignal));
        
        if ~isdir(saveFolder)
            mkdir(saveFolder)
        end
        
        %raw timeserie
        disp(['raw timeseries ', num2str(fsignal), 'Hz']);
        raw = timeSeriesFactory(fsignal, 'raw', inputFixture, ...
            outputFixture{fixtureIndexForOutputFiles}, sampCoeff);
        newRawFile = strcat(saveFolder, '/',prefixjoin,'_', raw.Name,'.mat');
        save(newRawFile,'raw','-v7.3');
        
        %simulation timeserie
        disp(['simulink timeseries ', num2str(fsignal), 'Hz']);
        simulation = timeSeriesFactory(fsignal, 'simulink', inputFixture, ...
            sampCoeff);
        newSimFile = strcat(saveFolder, '/',prefixjoin,'_', simulation.Name,'.mat');
        save(newSimFile,'simulation','-v7.3');
        
        %theoretical timeserie
        disp(['theoretical simulation timeseries', num2str(fsignal), 'Hz']);
        Parameters.numberOfRandomValues = 1e5;
        Parameters.dacBits = 16;
        Parameters.adcBits = 10;
        Parameters.dacMaxVoltage = 3.3;
        Parameters.dacMinvoltage = 0;
        Parameters.oversamplingCoeff = 4;
        Parameters.buffLen = 200;
        Parameters.sampledValuesPerRound = floor(Parameters.buffLen / Parameters.oversamplingCoeff); %NOT USED REALLY
        Parameters.rounds = 3;%NOT USED REALLY
        Parameters.nWaitingUnits = 350; %NOT USED REALLY
        Parameters.nonSampledValuesPerRound = 500;%NOT USED REALLY
        theoretical = timeSeriesFactory(fsignal, 'theoretical', Parameters);
        newTheoreticalFile = strcat(saveFolder, '/',prefixjoin,'_', theoretical.Name,'.mat');
        save(newTheoreticalFile,'theoretical','-v7.3');
    end
    
end
