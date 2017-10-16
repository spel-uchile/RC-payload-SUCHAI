prefix = '2017_10_12_133800';
j = strfind(prefix,'_');
suffix = prefix(j(3)+1:end);
suffixFrames = [suffix '-frames'];
suffixAdc = [suffix '_adcPeriod'];
prefixjoin = [prefix(1:4), prefix(6:7), prefix(9:10)];

preprocessorFolder = './preprocessor/suchai';
saveFolder = strcat(preprocessorFolder, '/', prefix);
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

telemetryFile = ['./logs/suchai/', prefix, '/SUCHAI_', prefixjoin,'_', suffixFrames,'.txt'];
telemetryFile = fullfile(telemetryFile);
[dir, name, extension] = fileparts(telemetryFile);
adcFile = ['./logs/suchai/', prefix, '/SUCHAI_', prefixjoin,'_', suffixAdc,'.txt'];
fid = fopen(adcFile);
tline = fgets(fid);
adcPeriod = sscanf(tline, 'adcPeriod %d');
fclose(fid);
[outFiles{1}, tmParams] = logPreProcessor(telemetryFile, saveFolder, 'telemetry-output', adcPeriod);
% 
inputVoltagesFile = './logs/input_seed0.txt';
inFile = logPreProcessor(inputVoltagesFile, saveFolder, 'telemetry-input', tmParams);