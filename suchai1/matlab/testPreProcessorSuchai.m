prefix = 'test';
suffix = 'HHMMSS';
prefixjoin = 'YYYYMMDD';

preprocessorFolder = './preprocessor';
saveFolder = strcat(preprocessorFolder, '/', prefix);
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

adcFile = ['./logs/', prefix, '/SUCHAI_', prefixjoin,'_', suffix,'_adcPeriod.txt'];
fid = fopen(adcFile);
tline = fgets(fid);
adcPeriod = sscanf(tline, 'adcPeriod %d');
fclose(fid);

telemetryFile = ['./logs/', prefix, '/SUCHAI_',prefixjoin,'_', suffix,'-frames.txt'];
[outFiles{1}, tmParams] = logPreProcessor(telemetryFile, saveFolder, 'telemetry-output', adcPeriod);

inputVoltagesFile = './logs/input_seed0.txt';
inFile = logPreProcessor(inputVoltagesFile, saveFolder, 'telemetry-input', tmParams);