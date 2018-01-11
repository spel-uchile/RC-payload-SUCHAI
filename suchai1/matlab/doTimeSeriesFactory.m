% This script takes preprocessor files with vin and vout values in separted
% files and modifies and saves them in MAT-files for further time series
% creation.

for prefixx = {'2018_01_11_125344'}
database = 'suchai'; %other: 'lab' or 'suchai'
% for prefixx = {'2017_08_24_132346','2017_08_29_131900','2017_08_30_022511', ...
%         '2017_08_31_124200','2017_09_01_135700', '2017_09_05_020600',...
%         '2017_09_08_132000','2017_09_15_020900', '2017_09_16_032505',...
%        ,'2017_09_18_132118', '2017_09_22_030600',...
%         '2017_09_22_133600','2017_09_24_130307', '2017_09_26_135800', ...
%         '2017_09_27_133958','2017_09_28_024600', '2017_09_29_130300',...
%         '2017_10_13_024557',,'2017_10_12_133800','2017_09_18_132118'...
%         '2018_01_10_131222','2018_01_11_125344'};
% telemetries?{'2017_10_14_022659','2017_09_18_024708'} not used because
% small number of frames downloaded.
    prefix = prefixx{1};
    prefixjoin = [prefix(1:4), prefix(6:7), prefix(9:end)];
    parserFolder = ['./parser/', database];
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
            saveFolder = strcat(['./mat/ts/',database,'/'], num2str(fsignal));
            
            if ~isdir(saveFolder)
                mkdir(saveFolder)
            end
            
            %raw timeserie
            disp(['raw timeseries ', num2str(fsignal), 'Hz']);
            raw = timeSeriesFactory(fsignal, 'raw', inputFixture, ...
                outputFixture{fixtureIndexForOutputFiles}, sampCoeff);
            newRawFile = strcat(saveFolder, '/',prefixjoin,'_', raw.Name,'.mat');
            save(newRawFile,'raw','-v7.3');
            
            %filtered timeserie
            disp(['filtered timeseries ', num2str(fsignal), 'Hz']);
            filtered = timeSeriesFactory(fsignal, 'filtered', inputFixture,...
                outputFixture{fixtureIndexForOutputFiles}, sampCoeff);
            newFilteredFile = strcat(saveFolder, '/',prefixjoin,'_', filtered.Name,'.mat');
            save(newFilteredFile,'filtered','-v7.3');
            
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
end