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

%% Vin Plot
figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1 : length(pathMatTelemetry)
    xbins = matfileTM{i}.xbins;
    pdfResult = matfileTM{i}.pdfResult;
    Parameters = matfileTM{i}.Parameters;
    hold on;
    plot(xbins.raw.Vin, log10(pdfResult.raw.Vin),'*','MarkerSize', mkrsize);
    hold off;
end
for i = 1 : length(pathMatLab)
    xbins = matfileLab{i}.xbins;
    pdfResult = matfileLab{i}.pdfResult;
    Parameters = matfileLab{i}.Parameters;
    hold on;
    plot(xbins.raw.Vin, log10(pdfResult.raw.Vin),'o','MarkerSize', mkrsize);
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
hleg = legend(plotLegendCell,'Location','eastoutside','Orientation','vertical');

saveas(gcf,[saveFolder,'/','allfrequencies_','vin_',date,'.png']);
saveas(gcf,[saveFolder,'/','allfrequencies_','vin_',date,'.eps'],'epsc');

%% Vout Plot
figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1 : length(pathMatTelemetry)

        xbins = matfileTM{i}.xbins;
        pdfResult = matfileTM{i}.pdfResult;
        Parameters = matfileTM{i}.Parameters;
        % Plots
        hold on;
        plot(xbins.raw.Vout, log10(pdfResult.raw.Vout),'*','MarkerSize', mkrsize);
        hold off;
        
end
for i = 1 : length(pathMatLab)
    xbins = matfileLab{i}.xbins;
    pdfResult = matfileLab{i}.pdfResult;
    Parameters = matfileLab{i}.Parameters;
    hold on;
    plot(xbins.raw.Vout, log10(pdfResult.raw.Vout),'o','MarkerSize', mkrsize);
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
hleg = legend(plotLegendCell,'Location','eastoutside','Orientation','vertical');

saveas(gcf,[saveFolder,'/','allfrequencies_','vout_',date,'.png']);
saveas(gcf,[saveFolder,'/','allfrequencies_','vout_',date,'.eps'],'epsc');

%% Power Plot
figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1 : numel(matfileTM)
    xbins = matfileTM{i}.xbins;
    pdfResult = matfileTM{i}.pdfResult;
    Parameters = matfileTM{i}.Parameters;
    %% Plots
    hold on;
    plot(xbins.raw.injectedPower, log10(pdfResult.raw.injectedPower),'*', 'MarkerSize', mkrsize);
    hold off;
    
end
for i = 1 : length(pathMatLab)
    xbins = matfileLab{i}.xbins;
    pdfResult = matfileLab{i}.pdfResult;
    Parameters = matfileLab{i}.Parameters;
    hold on;
    plot(xbins.raw.injectedPower, log10(pdfResult.raw.injectedPower),'o','MarkerSize', mkrsize);
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
hleg = legend(plotLegendCell,'Location','eastoutside','Orientation','vertical');

saveas(gcf,[saveFolder,'/','allfrequencies_','power_',date,'.png']);
saveas(gcf,[saveFolder,'/','allfrequencies_','power_',date,'.eps'],'epsc');