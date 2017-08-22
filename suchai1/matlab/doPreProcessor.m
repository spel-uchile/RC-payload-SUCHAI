% This script takes cutecom files with vin and vout values in separted
% files and modifies to a format that the parserInput() and parserOutput()
% function can handle. The vin/vout files aren't in the same file (as shown
% in testPreProcessor.m), so there is a for loop that preprocess each file
% separadetaly.
clear all;
close all;

prefix = '2016_18_05';
rawLogsFolder = strcat('./cutecom','/', prefix);
inputVoltagesFile = strcat(prefix, '_', 'input_voltages.log');  %vin file
logPath = strcat(rawLogsFolder, '/', inputVoltagesFile);
preprocessorFolder = './preprocessor';

saveFolder = strcat(preprocessorFolder, '/', prefix);
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

inFile = logPreProcessor(logPath, saveFolder, 'input');
for i = 1 : 15
    voutFile = strcat(prefix,'_freq', num2str(i-1),'.log');
    logPath = strcat(rawLogsFolder, '/', voutFile);
    outFiles{i} = logPreProcessor(logPath, saveFolder, 'output', i);
end