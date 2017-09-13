% This script takes preprocessor files with vin and vout values in separted
% files and modifies and saves them in MAT-files for further time series
% creation.

for prefixx = {'2017_08_24_132346','2017_08_29_131900','2017_08_30_022511', ...
        '2017_08_31_124200','2017_09_01_135700', '2017_09_05_020600',...
        '2017_09_08_132000' };
    prefix = prefixx{1};
    prefixjoin = [prefix(1:4), prefix(6:7), prefix(9:end)];
    parserFolder = './parser/suchai';
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
            saveFolder = strcat('./mat/ts/suchai/', num2str(fsignal));
            
            if ~isdir(saveFolder)
                mkdir(saveFolder)
            end
            %raw timeserie
            raw = timeSeriesFactory(fsignal, 'raw', inputFixture, ...
                outputFixture{fixtureIndexForOutputFiles}, sampCoeff);
            save(strcat(saveFolder, '/',prefixjoin,'_', raw.Name,'_','.mat'),'raw','-v7.3');
            
            %filtered timeserie
            filtered = timeSeriesFactory(fsignal, 'filtered', inputFixture,...
                outputFixture{fixtureIndexForOutputFiles}, sampCoeff);
            save(strcat(saveFolder, '/',prefixjoin,'_', filtered.Name,'.mat'),'filtered','-v7.3');

            %simulation timeserie
            simulation = timeSeriesFactory(fsignal, 'simulink', inputFixture, ...
                sampCoeff);
            save(strcat(saveFolder, '/',prefixjoin,'_', simulation.Name,'.mat'),'simulation','-v7.3');
            
            %theoretical timeserie
            Parameters.numberOfRandomValues = 1e6;
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
            save(strcat(saveFolder, '/',prefixjoin,'_', theoretical.Name,'.mat'),'theoretical','-v7.3');
        end
        
    end
end