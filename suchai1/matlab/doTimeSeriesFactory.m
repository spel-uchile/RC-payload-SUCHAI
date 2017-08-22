% This script takes preprocessor files with vin and vout values in separted
% files and modifies and saves them in MAT-files for further time series
% creation.

prefix ='2016_18_05';
parserFolder = './parser';
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
    saveFolder = strcat('./mat/ts/', prefix);
    fixtureIndexForOutputFiles = fixtureIndexForOutputFiles + 1;

    if i ~= fixtureIndexForInputParserFiles
        outputFixture{fixtureIndexForOutputFiles} = strcat(fixtureFolder,'/',...
            parserFiles{fixtureIndexForOutputFiles});
        S = load(outputFixture{fixtureIndexForOutputFiles});
        name = fieldnames(S);
        adcPeriod = S.(name{1}).adcPeriod;
        sampCoeff = S.(name{1}).oversamplingCoeff;
        fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);
        saveFolder = strcat(saveFolder, '/', num2str(fsignal));
        
        if ~isdir(saveFolder)
            mkdir(saveFolder)
        end
        %raw timeserie
        raw = timeSeriesFactory(fsignal, 'raw', inputFixture, ...
            outputFixture{fixtureIndexForOutputFiles}, sampCoeff);
        save(strcat(saveFolder, '/',raw.Name,'.mat'),'raw','-v7.3');
        
        %filtered timeserie
        filtered = timeSeriesFactory(fsignal, 'filtered', inputFixture,...
            outputFixture{fixtureIndexForOutputFiles}, sampCoeff);
        save(strcat(saveFolder, '/', filtered.Name,'.mat'),'filtered','-v7.3');
        
        %simulation timeserie
        simulation = timeSeriesFactory(fsignal, 'simulink', inputFixture, ...
            sampCoeff);
        save(strcat(saveFolder, '/', simulation.Name,'.mat'),'simulation','-v7.3');
        
        %theoretical timeserie
        Parameters.numberOfRandomValues = 1e6;
        Parameters.dacBits = 16;
        Parameters.adcBits = 10;
        Parameters.dacMaxVoltage = 3.3;
        Parameters.dacMinvoltage = 0;
        Parameters.oversamplingCoeff = 4;
        theoretical = timeSeriesFactory(fsignal, 'theoretical', Parameters);
        save(strcat(saveFolder, '/', theoretical.Name,'.mat'),'theoretical','-v7.3');
    end
    
end