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
        
        tsProducedName = strcat( normalization ,'_', num2str(fsignal),'Hz');
        newFile = strcat(saveFolder, '/',prefixjoin,'_', tsProducedName,'.mat');
        if ~exist(fullfile(newFile))
            disp([newFile,' is being created']);
        elseif exist(fullfile(newFile)) && exist('overwrite')
            if strfind(overwrite,'yes')
                disp([newFile,' is being created']);
            else
                disp([newFile,' already exists']);
                continue;
            end
        else
            disp([newFile,' already exists']);
            continue;
        end
        tsProduced = timeSeriesFactory(fsignal, normalization, inputFixture, ...
            outputFixture{fixtureIndexForOutputFiles}, sampCoeff);
        tsProduced.Name = tsProducedName;
        save(newFile, 'tsProduced','-v7.3');
        
    end
    
end