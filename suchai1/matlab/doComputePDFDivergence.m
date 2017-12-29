%% Load PDF mat files
rootDir= './mat/pdf';
saveFolder ='./img/suchai-vs-lab';
mkrsize = 6;
myLegendFontSize = 10;
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

labRootFolder = [rootDir,'/','lab'];
suchaiRootFolder =  [rootDir,'/','suchai'];
suchaiFolders = dir(suchaiRootFolder);
suchaiFolders = {suchaiFolders.name};
suchaiFolders = suchaiFolders(3:end)';
suchaiFolders = sortn(suchaiFolders);

freqsTelemetry = {};
freqsLegendTM = {};
telemetryCounter = 0;
pathMatTelemetry = {};
matfileTM = {};
for i = 1 : numel(suchaiFolders)
    
    tmFolder = strcat(suchaiRootFolder,'/', suchaiFolders{i});
    tmFile = dir(tmFolder);
    tmFile = {tmFile.name};
    tmFile = tmFile(3:end)';
    tmFile = sortn(tmFile);
    freqInHz = suchaiFolders{i};
    for j = 1 : length(tmFile)
        telemetryCounter = telemetryCounter + 1;
        pathMatTelemetry{telemetryCounter} = strcat(tmFolder,'/',tmFile{j});
        freqsLegendTM{telemetryCounter} = strcat(num2str(str2double(freqInHz)/91.5),' f_{RC} SUCHAI');
        freqsTelemetry{telemetryCounter} = freqInHz;
        matfileTM{telemetryCounter} = load(pathMatTelemetry{telemetryCounter});
    end
end
freqsLab = {};
freqsLegendLab = {};
labCounter = 0;
pathMatLab = {};
matfileLab = {};
for i = 1 : numel(suchaiFolders)
    
    tmFolder = strcat(labRootFolder,'/', suchaiFolders{i});
    tmFile = dir(tmFolder);
    tmFile = {tmFile.name};
    tmFile = tmFile(3:end)';
    tmFile = sortn(tmFile);
    freqInHz = suchaiFolders{i};
    for j = 1 : length(tmFile)
        labCounter = labCounter + 1;
        pathMatLab{labCounter} = strcat(tmFolder,'/',tmFile{j});
        freqsLegendLab{labCounter} = strcat(num2str(str2double(freqInHz)/91.5),' f_{RC} LAB');
        freqsLab{labCounter} = freqInHz;
        matfileLab{labCounter} = load(pathMatLab{labCounter});
    end
end
plotLegendCell = [freqsLegendTM, freqsLegendLab]';

%% frequencies load
aString = sprintf('%s ', freqsTelemetry{:});
freqsArrayTelemetry = sscanf(aString, '%f');
repetitionfreqs = histc(freqsArrayTelemetry, unique(freqsArrayTelemetry));
aString = sprintf('%s ', freqsLab{:});
freqsArrayLab = sscanf(aString, '%f');

%% Compute KL for Vin
KLVin = zeros(1,length(freqsArrayLab));
for i = 1 : length(freqsArrayLab)
        xbinsTM = matfileTM{i}.xbins;
        xbinsTM = xbinsTM.raw.Vin;
        pdfResultTM = matfileTM{i}.pdfResult;
        pdfResultTM = pdfResultTM.raw.Vin;
        ParametersTM = matfileTM{i}.Parameters;
        ParametersTM = ParametersTM.raw;
    if repetitionfreqs(i) > 1
        extra  = repetitionfreqs(i) - 1;
        for j = 1 : extra
           tmpPdfResultTM = matfileTM{i + j}.pdfResult;
           tmpPdfResultTM = tmpPdfResultTM.raw.Vin;
           tmpxbinsTM = matfileTM{i + j}.xbins;
           tmpxbinsTM = tmpxbinsTM.raw.Vin;
           pdfResultTM = [pdfResultTM;  tmpPdfResultTM];
           xbinsTM = [xbinsTM; tmpxbinsTM];
        end
        pdfResultTM = mean(pdfResultTM);    %promedio de las telemetrias
        xbinsTM = mean(xbinsTM);
    end
        xbinsLab = matfileLab{i}.xbins;
        xbinsLab = xbinsLab.raw.Vin;
        pdfResultLab = matfileLab{i}.pdfResult;
        pdfResultLab = pdfResultLab.raw.Vin;
        ParametersLab = matfileLab{i}.Parameters;
        ParametersLab = ParametersLab.raw;
        
        X = mean([xbinsLab; xbinsTM]);
        KLVin(i) = kldiv(X, pdfResultLab, pdfResultTM, 'sym');
end
plot(log10(freqsArrayLab), log10(KLVin), '.'); 
hold on;

%% Compute KL for Vout

KLVout = zeros(1,length(freqsArrayLab));
for i = 1 : length(freqsArrayLab)
        xbinsTM = matfileTM{i}.xbins;
        xbinsTM = xbinsTM.raw.Vout;
        pdfResultTM = matfileTM{i}.pdfResult;
        pdfResultTM = pdfResultTM.raw.Vout;
        ParametersTM = matfileTM{i}.Parameters;
        ParametersTM = ParametersTM.raw;
    if repetitionfreqs(i) > 1
        extra  = repetitionfreqs(i) - 1;
        for j = 1 : extra
           tmpPdfResultTM = matfileTM{i + j}.pdfResult;
           tmpPdfResultTM = tmpPdfResultTM.raw.Vout;
           tmpxbinsTM = matfileTM{i + j}.xbins;
           tmpxbinsTM = tmpxbinsTM.raw.Vout;
           pdfResultTM = [pdfResultTM;  tmpPdfResultTM];
           xbinsTM = [xbinsTM; tmpxbinsTM];
        end
        pdfResultTM = mean(pdfResultTM);    %promedio de las telemetrias
        xbinsTM = mean(xbinsTM);
    end
        xbinsLab = matfileLab{i}.xbins;
        xbinsLab = xbinsLab.raw.Vout;
        pdfResultLab = matfileLab{i}.pdfResult;
        pdfResultLab = pdfResultLab.raw.Vout;
        ParametersLab = matfileLab{i}.Parameters;
        ParametersLab = ParametersLab.raw;
        
        X = mean([xbinsLab; xbinsTM]);
        KLVout(i) = kldiv(X, pdfResultLab, pdfResultTM, 'sym');
end
plot(log10(freqsArrayLab), log10(KLVout), '--'); 

KLPin = zeros(1,length(freqsArrayLab));
for i = 1 : length(freqsArrayLab)
        xbinsTM = matfileTM{i}.xbins;
        xbinsTM = xbinsTM.raw.injectedPower;
        pdfResultTM = matfileTM{i}.pdfResult;
        pdfResultTM = pdfResultTM.raw.injectedPower;
        ParametersTM = matfileTM{i}.Parameters;
        ParametersTM = ParametersTM.raw;
    if repetitionfreqs(i) > 1
        extra  = repetitionfreqs(i) - 1;
        for j = 1 : extra
           tmpPdfResultTM = matfileTM{i + j}.pdfResult;
           tmpPdfResultTM = tmpPdfResultTM.raw.injectedPower;
           tmpxbinsTM = matfileTM{i + j}.xbins;
           tmpxbinsTM = tmpxbinsTM.raw.injectedPower;
           pdfResultTM = [pdfResultTM;  tmpPdfResultTM];
           xbinsTM = [xbinsTM; tmpxbinsTM];
        end
        pdfResultTM = mean(pdfResultTM);    %promedio de las telemetrias
        xbinsTM = mean(xbinsTM);
    end
        xbinsLab = matfileLab{i}.xbins;
        xbinsLab = xbinsLab.raw.injectedPower;
        pdfResultLab = matfileLab{i}.pdfResult;
        pdfResultLab = pdfResultLab.raw.injectedPower;
        ParametersLab = matfileLab{i}.Parameters;
        ParametersLab = ParametersLab.raw;
        
        X = mean([xbinsLab; xbinsTM]);
        KLPin(i) = kldiv(X, pdfResultLab, pdfResultTM, 'sym');
end
plot(log10(freqsArrayLab), log10(KLPin), '-'); 

%
% % saveas(gcf,[saveFolder,'/','allfrequencies_','power_',date,'.png']);
% % saveas(gcf,[saveFolder,'/','allfrequencies_','power_',date,'.eps'],'epsc');