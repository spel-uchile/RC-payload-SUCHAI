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
% normalization = 'divByMean';
% normalization = 'diffByMeanDivByStd';
% normalization = 'withoutDC';

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
    indexC = strfind(tmFile,normalization);
    
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
    indexC = strfind(tmFile, normalization);
    
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
%         plotPDFVariable('Vin', [],[],'V'); close all;
%         plotPDFVariable('Vout', [],[],'V'); close all;
%         plotPDFVariable('Vr', [],[],'V'); close all;
%         plotPDFVariable('Ir', [],[],'A'); close all;
%         plotPDFVariable('Ic', [],[],'V'); close all;
%         plotPDFVariable('Pin', [],[],'V'); close all;
%         plotPDFVariable('Pr', [],[],'V'); close all;
%         plotPDFVariable('Pc', [],[],'V'); close all;
%         plotPDFVariable('DeltaP', [],[],'V'); close all;
        plotPDFVariable('LangInj', [],[],'V^2 \cdot Hz'); close all;
%         plotPDFVariable('LangDiss', [],[],'V^2 \cdot Hz'); close all;
%         plotPDFVariable('LangStored', [],[],'V^2 \cdot Hz'); close all;
%         plotPDFVariable('LangDeltaP', [],[],'V^2 \cdot Hz'); close all;
    case 'rawWithDC'
        plotPDFVariable('Vin', [],[],'V'); close all;
        plotPDFVariable('Vout', [],[],'V'); close all;
        plotPDFVariable('LangInj', [],[],'V^2 \cdot Hz'); close all;
        plotPDFVariable('LangDiss',[],[],'V^2 \cdot Hz'); close all;
    case 'divByMean'
        plotPDFVariable('Vin', [],[],'Vin / <Vin>'); close all;
        plotPDFVariable('Vout', [],[],'Vout / <Vout>'); close all;
        plotPDFVariable('LangInj', [],[],'I / <I>'); close all;
        plotPDFVariable('LangDiss',[],[],'Idiss / <Idiss>'); close all;
    case 'diffByMeanDivByStd'
        plotPDFVariable('Vin', [],[],'(Vin- <Vin>)/rms(Vin)'); close all;
        plotPDFVariable('Vout', [],[],'(Vout- <Vout>)/rms(Vout)'); close all;
        plotPDFVariable('LangInj', [],[],'(I- <I>)/rms(I)'); close all;
        plotPDFVariable('LangDiss',[],[],'(Idiss- <Idiss>)/rms(Idiss)'); close all;
end
