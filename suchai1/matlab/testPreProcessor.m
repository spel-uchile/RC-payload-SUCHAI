clear all;
close all;

prefix = '2016_18_05';
rawLogsFolder = strcat('./cutecom','/',prefix);
inputVoltagesFile = strcat(prefix,'_','input_voltages.log');  %vin file
logPath = strcat(rawLogsFolder, '/', inputVoltagesFile);
preprocessorFolder = './preprocessor';

saveFolder = strcat(preprocessorFolder, '/test');
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

inFile = logPreProcessor(logPath, saveFolder, 'input');

for i = 1 :4
    voutFile = strcat(prefix,'_freq',num2str(i-1),'.log');  %vout files
    logPath = strcat(rawLogsFolder, '/', voutFile);
    outFiles{i} = logPreProcessor(logPath, saveFolder, 'output', i);
end