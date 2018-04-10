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
global normalization;

normalization = 'raw';
rootDir= ['./mat/pdf-',normalization];
saveFolder =['./img/suchaiPDFs/SeparatedByFrequency/pdf-',...
    normalization,'/',date];
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
    indexC = strfind(tmFile,'raw');
    indexRaw = find(not(cellfun('isempty', indexC)));
    freqInHz = suchaiFoldersName{i};
    tmFile = tmFile(indexRaw);
    for j = 1 : length(tmFile)
        if strfind (tmFile{j}, normalization)
            tmPerFreqSuchai(i) = tmPerFreqSuchai(i) + 1;
            telemetryCounter = telemetryCounter + 1;
            pathMatTelemetry{telemetryCounter} = strcat(tmFolder,'/',tmFile{j});
            str = tmFile{j};
            idx = strfind(str, '_');
            freqsLegendTM{telemetryCounter} = strcat('SUCHAI_',str(idx(1)+1:idx(4)-1));
            freqsTelemetry{telemetryCounter} = freqInHz;
            matfileTM{telemetryCounter} = load(pathMatTelemetry{telemetryCounter});
        end
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
    indexC = strfind(tmFile,'raw');
    indexRaw = find(not(cellfun('isempty', indexC)));
    tmFile = tmFile(indexRaw);
    freqInHz = suchaiFoldersName{i};
    tmPerFreqLab(i) = 0;
    for j = 1 : length(tmFile)
        if strfind (tmFile{j}, normalization)
            labCounter = labCounter + 1;
            tmPerFreqLab(i) = tmPerFreqLab(i) + 1;
            pathMatLab{labCounter} = strcat(tmFolder,'/',tmFile{j});
            str = tmFile{j};
            idx = strfind(str, '_');
            freqsLegendLab{labCounter} = strcat('LAB_',str(idx(1)+1:idx(4)-1));
            freqsLab{labCounter} = freqInHz;
            matfileLab{labCounter} = load(pathMatLab{labCounter});
        end
    end
end
plotLegendCell = [freqsLegendTM, freqsLegendLab]';

switch normalization
    case 'raw'
        plotPDFVariable('Vin', [-0.5 3],[-3 1],'V');
        plotPDFVariable('Vout', [-0.5 3],[-3 1],'V');
        % plotPDFVariable('Vr', [-1.6 1.6],[-3 1],'V');
        % plotPDFVariable('Ir', [-1.6 1.6],[-3 1],'mA');
        % plotPDFVariable('Ic', [-0.3 0.3],[-3 2],'mA');
        % plotPDFVariable('Pin', [-0.4 1.5],[-3 1],'mW');
        % plotPDFVariable('Pr', [-0.5 3],[-5 1],'mW');
        % plotPDFVariable('Pc', [-0.25 1.25],[-5 2],'mW');
        % plotPDFVariable('DeltaP', [-0.25 1.25],[-5 2],'mW');
        plotPDFVariable('LangInj', [-1000 3000],[-8 -2],'V^2 \cdot Hz');
        plotPDFVariable('LangDiss',[-1000 3000],[-8 2],'V^2 \cdot Hz');
        % plotPDFVariable('LangStored', [-300 300],[-4 -0.5],'V^2 \cdot Hz');
    case 'divByMean'
        plotPDFVariable('Vin', [-0.5 3],[-3 1],'V');
        plotPDFVariable('Vout', [-0.5 3],[-3 1],'V');
        % plotPDFVariable('Vr', [-1.6 1.6],[-3 1],'V');
        % plotPDFVariable('Ir', [-1.6 1.6],[-3 1],'mA');
        % plotPDFVariable('Ic', [-0.3 0.3],[-3 2],'mA');
        % plotPDFVariable('Pin', [-0.4 1.5],[-3 1],'mW');
        % plotPDFVariable('Pr', [-0.5 3],[-5 1],'mW');
        % plotPDFVariable('Pc', [-0.25 1.25],[-5 2],'mW');
        % plotPDFVariable('DeltaP', [-0.25 1.25],[-5 2],'mW');
        plotPDFVariable('LangInj', [-1000 3000],[-8 -2],'V^2 \cdot Hz');
        % plotPDFVariable('LangDiss',[-1000 3000],[-8 2],'V^2 \cdot Hz');
        % plotPDFVariable('LangStored', [-300 300],[-4 -0.5],'V^2 \cdot Hz');
    case 'diffByMeanDivByStd'
        plotPDFVariable('Vin', [-0.5 3],[-3 1],'V');
        plotPDFVariable('Vout', [-0.5 3],[-3 1],'V');
        % plotPDFVariable('Vr', [-1.6 1.6],[-3 1],'V');
        % plotPDFVariable('Ir', [-1.6 1.6],[-3 1],'mA');
        % plotPDFVariable('Ic', [-0.3 0.3],[-3 2],'mA');
        % plotPDFVariable('Pin', [-0.4 1.5],[-3 1],'mW');
        % plotPDFVariable('Pr', [-0.5 3],[-5 1],'mW');
        % plotPDFVariable('Pc', [-0.25 1.25],[-5 2],'mW');
        % plotPDFVariable('DeltaP', [-0.25 1.25],[-5 2],'mW');
        plotPDFVariable('LangInj', [-1000 3000],[-8 -2],'V^2 \cdot Hz');
        plotPDFVariable('LangDiss',[-1000 3000],[-8 2],'V^2 \cdot Hz');
        % plotPDFVariable('LangStored', [-300 300],[-4 -0.5],'V^2 \cdot Hz');
end
