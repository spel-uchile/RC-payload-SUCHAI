rootDir= './mat/pdf';
% rootMatFiles = './mat/pdf_compare_all_telemetries_script';

labFolder = [rootDir,'/','lab'];
suchaiRootFolder =  [rootDir,'/','suchai'];
suchaiFolders = dir(suchaiRootFolder);
suchaiFolders = {suchaiFolders.name};
suchaiFolders = suchaiFolders(3:end)';
suchaiFolders = sortn(suchaiFolders);

freqsTelemetry = {};
freqsLegend = {};
telemetryCounter = 0;
pathMatTelemetry = {};
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
        freqsLegend{telemetryCounter} = strcat(num2str(str2double(freqInHz)/91.5),' f_{RC} SUCHAI');
        freqsTelemetry{telemetryCounter} = freqInHz;
        matfileTM{telemetryCounter} = load(pathMatTelemetry{telemetryCounter});
    end
end

saveFolder =['./img/suchaiPDFs/AllFrequencies/',date];
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

%% Vin
saveFolderFig = [saveFolder,'/vin'];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1 : length(pathMatTelemetry)
    xbins = matfileTM{i}.xbins;
    pdfResult = matfileTM{i}.pdfResult;
    Parameters = matfileTM{i}.Parameters;
    %% Plots
    hold on;
    plot(xbins.raw.Vin, log10(pdfResult.raw.Vin),'*');
    hold off;
end
grid on;
ylim([-3 1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['SUCHAI Vin PDF']);
xlabel('V');
legend(freqsLegend,'Location','eastoutside','Orientation','vertical');
figSaveName = [saveFolderFig,'/','compareAllTelemetries_','vin_',date,'.png'];
saveas(gcf,figSaveName);

%% Vout
saveFolderFig = [saveFolder,'/vout'];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1 : length(pathMatTelemetry)

        xbins = matfileTM{i}.xbins;
        pdfResult = matfileTM{i}.pdfResult;
        Parameters = matfileTM{i}.Parameters;
        % Plots
        hold on;
        plot(xbins.raw.Vout, log10(pdfResult.raw.Vout),'*');
        hold off;
        
end
grid on;
ylim([-5 1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['SUCHAI Vout PDFs']);
xlabel('V');
legend(freqsLegend,'Location','eastoutside','Orientation','vertical');
figSaveName = [saveFolderFig,'/','compareAllTelemetries_','vout_',date,'.png'];
saveas(gcf,figSaveName);

%% injectedPower
saveFolderFig = [saveFolder,'/injectedPower'];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1 : numel(matfileTM)
    xbins = matfileTM{i}.xbins;
    pdfResult = matfileTM{i}.pdfResult;
    Parameters = matfileTM{i}.Parameters;
    %% Plots
    hold on;
    plot(xbins.raw.injectedPower, log10(pdfResult.raw.injectedPower),'*');
    hold off;
    
end
grid on;
ylim([-4 -1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['SUCHAI injected Power PDFs']);
xlabel('V^2 \cdot Hz');
legend(freqsLegend,'Location','eastoutside','Orientation','vertical');
figSaveName = [saveFolderFig,'/','compareAllTelemetries_','power_',date,'.png'];
saveas(gcf,figSaveName);