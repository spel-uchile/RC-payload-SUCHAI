prefix = '2017_08_30';
suffix = '022511-frames';
prefixjoin = [prefix(1:4), prefix(6:7), prefix(9:10)];

preprocessorFolder = './preprocessor';
saveFolder = strcat(preprocessorFolder, '/', prefix);
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

telemetryFile = ['./logs/', prefix, '/SUCHAI_',prefixjoin,'_', suffix,'.txt'];
adcPeriod = 175;
[outFiles{1}, tmParams] = logPreProcessor(telemetryFile, saveFolder, 'telemetry-output', adcPeriod);
% 
inputVoltagesFile = './logs/input_seed0.txt';
inFile = logPreProcessor(inputVoltagesFile, saveFolder, 'telemetry-input', tmParams);
