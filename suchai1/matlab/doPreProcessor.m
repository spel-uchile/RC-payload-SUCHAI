% This script takes logs files with vin and vout values in separted
% files and modifies to a format that the parserInput() and parserOutput()
% function can handle. The vin/vout files aren't in the same file (as shown
% in testPreProcessor.m), so there is a for loop that preprocess each file
% separadetaly.

% dataset = 'lab';
rawLogsFolder = strcat('./logs/',dataset,'/', prefix);
inputVoltagesFile = strcat(prefix, '_', 'input_voltages.txt');  %vin file
logPath = strcat(rawLogsFolder, '/', inputVoltagesFile);
preprocessorFolder = ['./preprocessor/',dataset];

saveFolder = strcat(preprocessorFolder, '/', prefix);
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

logsDir = dir(rawLogsFolder);  %pair only with suchai frequencies
logsDir = {logsDir.name};
logsDir = logsDir(3:end);
logsDir = sortn(logsDir);
logsDir = lower(logsDir);
idx = strfind(logsDir, prefix);
tf = cellfun('isempty',idx);
idx(tf) = {0};
idx = logical(cell2mat(idx));
logsDir = logsDir(idx);
idx = strfind(logsDir, 'input');
tf = cellfun('isempty',idx);
idx(tf) = {0};
idx = ~logical(cell2mat(idx));
logsDir = logsDir(idx);

inFile = logPreProcessor(logPath, saveFolder, 'input');
for i = 1 : length(logsDir)
    voutFile = strcat(prefix,'_freq', num2str(i-1),'.txt');
    logPath = strcat(rawLogsFolder, '/', voutFile);
    outFiles{i} = logPreProcessor(logPath, saveFolder, 'output', i);
end