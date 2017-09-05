prefix = '2017_09_01_032100';

preprocessorFolder = './preprocessor';
saveFolder = strcat(preprocessorFolder, '/', prefix);
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

telemetryFile = './cutecom/2017_09_01_032100/SUCHAI_20170901_032100-frames.txt';
adcPeriod = 1417;
[outFiles{1}, tmParams] = logPreProcessor(telemetryFile, saveFolder, 'telemetry-output', adcPeriod);
% 
% inputVoltagesFile = './cutecom/2016_18_05/2016_18_05_input_voltages.log';
% inFile = logPreProcessor(inputVoltagesFile, saveFolder, 'telemetry-input', tmParams);
