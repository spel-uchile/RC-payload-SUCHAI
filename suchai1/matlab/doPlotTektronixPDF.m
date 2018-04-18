global matfileTM;
global suchaiFoldersName;
global saveFolder;
global mkrsize;
global freqsLegendTM;
global tmPerFreqSuchai;
global normalization;

% normalization = 'raw';
% normalization = 'divByMean';
normalization = 'diffByMeanDivByStd';
rootDir= ['./mat/pdf-',normalization];
saveFolder =['./img/tektronixPDFs/pdf-',...
    normalization,'/',date];
mkrsize = 6;
myLegendFontSize = 10;
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

suchaiRootFolder =  [rootDir,'/','tektronix'];
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
    indexC = strfind(tmFile,'tektronix');
    indexRaw = find(not(cellfun('isempty', indexC)));
    freqInHz = suchaiFoldersName{i};
    tmFile = tmFile(indexRaw);
    for j = 1 : length(tmFile)
        if strfind (tmFile{j}, 'tektronix')
            tmPerFreqSuchai(i) = tmPerFreqSuchai(i) + 1;
            telemetryCounter = telemetryCounter + 1;
            pathMatTelemetry{telemetryCounter} = strcat(tmFolder,'/',tmFile{j});
            str = tmFile{j};
            idx = strfind(str, '_');
            freqsLegendTM{telemetryCounter} = strcat('TEKTRONIX_',str(idx(1)+1:idx(4)-1));
            freqsTelemetry{telemetryCounter} = freqInHz;
            matfileTM{telemetryCounter} = load(pathMatTelemetry{telemetryCounter});
        end
    end
end

plotLegendCell = [freqsLegendTM]';

switch normalization
    case 'raw'
        plotPDFVariableTektronix('Vin', [],[],'V');
        plotPDFVariableTektronix('Vout', [],[],'V');
        plotPDFVariableTektronix('LangInj', [],[],'V^2 \cdot Hz');
        plotPDFVariableTektronix('LangDiss',[],[],'V^2 \cdot Hz');
    case 'divByMean'
        plotPDFVariableTektronix('Vin', [],[],'Vin / <Vin>');
        plotPDFVariableTektronix('Vout', [],[],'Vout / <Vout>');
        plotPDFVariableTektronix('LangInj', [],[],'I / <I>');
        plotPDFVariableTektronix('LangDiss',[],[],'Idiss / <Idiss>');
    case 'diffByMeanDivByStd'
        plotPDFVariableTektronix('Vin', [],[],'(Vin- <Vin>)/rms(Vin)');
        plotPDFVariableTektronix('Vout', [],[],'(Vout- <Vout>)/rms(Vout)');
        plotPDFVariableTektronix('LangInj', [],[],'(I- <I>)/rms(I)');
        plotPDFVariableTektronix('LangDiss',[],[],'(Idiss- <Idiss>)/rms(Idiss)'); close all;
end