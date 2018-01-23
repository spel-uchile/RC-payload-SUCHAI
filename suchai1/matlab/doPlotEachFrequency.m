global matfileTM;
global matfileLab;
global suchaiFoldersName;
global saveFolder;
global mkrsize,
global freqsLab;
global freqsLegendTM;
global tmPerFreqSuchai;
global freqsLegendLab;
global tmPerFreqLab;

rootDir= './mat/pdf';
saveFolder =['./img/suchaiPDFs/SeparatedByFrequency/',date];
mkrsize = 6;
myLegendFontSize = 10;
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

labRootFolder = [rootDir,'/','lab'];
suchaiRootFolder =  [rootDir,'/','suchai'];
suchaiFoldersStruct = dir(suchaiRootFolder);
suchaiFoldersStruct = suchaiFoldersStruct(3:end);
isADir = [suchaiFoldersStruct.isdir];
suchaiFoldersStruct = suchaiFoldersStruct(isADir);
suchaiFoldersName = {suchaiFoldersStruct.name};
suchaiFoldersName = sortn(suchaiFoldersName);
freqsTelemetry = {};
freqsLegendTM = {};
telemetryCounter = 0;
pathMatTelemetry = {};
matfileTM = {};
tmPerFreqSuchai = zeros(1,numel(suchaiFoldersName));
for i = 1 : numel(suchaiFoldersName)
    tmFolder = strcat(suchaiRootFolder,'/', suchaiFoldersName{i});
    tmFile = dir(tmFolder);
    tmFile = {tmFile.name};
    tmFile = tmFile(3:end)';
    tmFile = sortn(tmFile);
    freqInHz = suchaiFoldersName{i};
    tmPerFreqSuchai(i) = length(tmFile);
    for j = 1 : length(tmFile)
        telemetryCounter = telemetryCounter + 1;
        pathMatTelemetry{telemetryCounter} = strcat(tmFolder,'/',tmFile{j});
        str = tmFile{j};
        freqsLegendTM{telemetryCounter} = strcat('SUCHAI_',str(1:15));
        freqsTelemetry{telemetryCounter} = freqInHz;
        matfileTM{telemetryCounter} = load(pathMatTelemetry{telemetryCounter});
    end
end
freqsLab = {};
freqsLegendLab = {};
labCounter = 0;
pathMatLab = {};
matfileLab = {};
tmPerFreqLab = zeros(1,numel(suchaiFoldersName));
for i = 1 : numel(suchaiFoldersName)
    
    tmFolder = strcat(labRootFolder,'/', suchaiFoldersName{i});
    tmFile = dir(tmFolder);
    tmFile = {tmFile.name};
    tmFile = tmFile(3:end)';
    tmFile = sortn(tmFile);
    freqInHz = suchaiFoldersName{i};
    tmPerFreqLab(i) = 0;
    for j = 1 : length(tmFile)
        if strfind (tmFile{j}, 'raw')
            labCounter = labCounter + 1;
            tmPerFreqLab(i) = tmPerFreqLab(i) + 1;
            pathMatLab{labCounter} = strcat(tmFolder,'/',tmFile{j});
            str = tmFile{j};
            freqsLegendLab{labCounter} = strcat('LAB_',str(1:15));
            freqsLab{labCounter} = freqInHz;
            matfileLab{labCounter} = load(pathMatLab{labCounter});
        end
    end
end
plotLegendCell = [freqsLegendTM, freqsLegendLab]';

plotPDFVariable('Vin', [-1.2 1.2],[-3 1],'V');
plotPDFVariable('Vout', [-1.2 1.2],[-3 1],'V');
plotPDFVariable('Vr', [-1.6 1.6],[-3 1],'V');
plotPDFVariable('Ir', [-1.6 1.6],[-3 1],'mA');
plotPDFVariable('Ic', [-0.3 0.3],[-3 2],'mA');
plotPDFVariable('Pin', [-0.4 1.5],[-3 1],'mW');
plotPDFVariable('Pr', [-0.5 3],[-5 1],'mW');
plotPDFVariable('Pc', [-0.25 1.25],[-5 2],'mW');
plotPDFVariable('DeltaP', [-0.25 1.25],[-5 2],'mW');
plotPDFVariable('LangInj', [-350 550],[-4 -1],'V^2 \cdot Hz');
plotPDFVariable('LangDiss',[-150 650],[-4 -1],'V^2 \cdot Hz')
plotPDFVariable('LangStored', [-300 300],[-4 -0.5],'V^2 \cdot Hz');
plotPDFVariable('LangDeltaP',[-200 650],[-4 -0.5],'V^2 \cdot Hz')