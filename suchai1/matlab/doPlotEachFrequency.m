clear all;
close all;

rootDir= './mat/pdf';
saveFolder =['./img/suchaiPDFs/SeparatedByFrequency/',date];
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
tmPerFreqSuchai = zeros(1,numel(suchaiFolders));
for i = 1 : numel(suchaiFolders)
    
    tmFolder = strcat(suchaiRootFolder,'/', suchaiFolders{i});
    tmFile = dir(tmFolder);
    tmFile = {tmFile.name};
    tmFile = tmFile(3:end)';
    tmFile = sortn(tmFile);
    freqInHz = suchaiFolders{i};
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
tmPerFreqLab = zeros(1,numel(suchaiFolders));
for i = 1 : numel(suchaiFolders)
    
    tmFolder = strcat(labRootFolder,'/', suchaiFolders{i});
    tmFile = dir(tmFolder);
    tmFile = {tmFile.name};
    tmFile = tmFile(3:end)';
    tmFile = sortn(tmFile);
    freqInHz = suchaiFolders{i};
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

%% Pin Plot
ks = 1;
kl = 1;
subFolderName = 'Pin';
saveFolderFig = [saveFolder , '/', subFolderName];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
for i = 1 : numel(suchaiFolders)
    hfig = figure('units','normalized','outerposition',[0 0 1 1]);
    currLegendSuchai = freqsLegendTM(ks:ks+tmPerFreqSuchai(i)-1);
    for j = 1 : tmPerFreqSuchai(i)
        xbins = matfileTM{ks}.xbins;
        pdfResult = matfileTM{ks}.pdfResult;
        Parameters = matfileTM{ks}.Parameters;
        hold on;
        plot(xbins.raw.Pin, log10(pdfResult.raw.Pin),'*','MarkerSize', mkrsize);
        hold off;
        ks = ks +1;
    end
    currLegendLab = freqsLegendLab(kl:kl+tmPerFreqLab(i)-1);
    for j = 1 : tmPerFreqLab(i)
        xbins = matfileLab{kl}.xbins;
        pdfResult = matfileLab{kl}.pdfResult;
        Parameters = matfileLab{kl}.Parameters;
        hold on;
        plot(xbins.raw.Pin, log10(pdfResult.raw.Pin),'o','MarkerSize', mkrsize);
        hold off;
        kl = kl + 1;
    end
    grid on;
    ylim([-3 1]);
    yt = get(gca, 'YTick');
    myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
    set(gca,'YTickLabel', myylabels);
    set(gca, 'YMinorTick','on', 'YMinorGrid','on');
    title(['Power Input PDF ', num2str(str2double(freqsLab(i))/91.5), ' f_{RC}']);
    xlabel('mW');
    currLegend = [currLegendSuchai, currLegendLab]';
    hleg = legend(currLegend,'Location','eastoutside','Orientation','vertical');
    set(hleg, 'Interpreter', 'none');
    figSaveName = [saveFolderFig, '/',suchaiFolders{i},'_Pin_',date,'.png'];
    saveas(gcf, figSaveName);
end
close all;

%% Pr Plot
ks = 1;
kl = 1;
subFolderName = 'Pr';
saveFolderFig = [saveFolder , '/', subFolderName];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
for i = 1 : numel(suchaiFolders)
    hfig = figure('units','normalized','outerposition',[0 0 1 1]);
    currLegendSuchai = freqsLegendTM(ks:ks+tmPerFreqSuchai(i)-1);
    for j = 1 : tmPerFreqSuchai(i)
        xbins = matfileTM{ks}.xbins;
        pdfResult = matfileTM{ks}.pdfResult;
        Parameters = matfileTM{ks}.Parameters;
        hold on;
        plot(xbins.raw.Pr, log10(pdfResult.raw.Pr),'*','MarkerSize', mkrsize);
        hold off;
        ks = ks +1;
    end
    currLegendLab = freqsLegendLab(kl:kl+tmPerFreqLab(i)-1);
    for j = 1 : tmPerFreqLab(i)
        xbins = matfileLab{kl}.xbins;
        pdfResult = matfileLab{kl}.pdfResult;
        Parameters = matfileLab{kl}.Parameters;
        hold on;
        plot(xbins.raw.Pr, log10(pdfResult.raw.Pr),'o','MarkerSize', mkrsize);
        hold off;
        kl = kl + 1;
    end
    grid on;
    ylim([-5 1]);
    yt = get(gca, 'YTick');
    myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
    set(gca,'YTickLabel', myylabels);
    set(gca, 'YMinorTick','on', 'YMinorGrid','on');
    title(['Power Resistor PDF', num2str(str2double(freqsLab(i))/91.5), ' f_{RC}']);
    xlabel('mW');
    currLegend = [currLegendSuchai, currLegendLab]';
    hleg = legend(currLegend,'Location','eastoutside','Orientation','vertical');
    set(hleg, 'Interpreter', 'none');
    figSaveName = [saveFolderFig, '/',suchaiFolders{i},'_Pr_',date,'.png'];
    saveas(gcf, figSaveName);
end
close all;

%% LangInj Plot
ks = 1;
kl = 1;
subFolderName = 'LangInj';
saveFolderFig = [saveFolder , '/', subFolderName];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
for i = 1 : numel(suchaiFolders)
    hfig = figure('units','normalized','outerposition',[0 0 1 1]);
    currLegendSuchai = freqsLegendTM(ks:ks+tmPerFreqSuchai(i)-1);
    for j = 1 : tmPerFreqSuchai(i)
        xbins = matfileTM{ks}.xbins;
        pdfResult = matfileTM{ks}.pdfResult;
        Parameters = matfileTM{ks}.Parameters;
        hold on;
        plot(xbins.raw.LangInj, log10(pdfResult.raw.LangInj),'*','MarkerSize', mkrsize);
        hold off;
        ks = ks +1;
    end
    currLegendLab = freqsLegendLab(kl:kl+tmPerFreqLab(i)-1);
    for j = 1 : tmPerFreqLab(i)
        xbins = matfileLab{kl}.xbins;
        pdfResult = matfileLab{kl}.pdfResult;
        Parameters = matfileLab{kl}.Parameters;
        hold on;
        plot(xbins.raw.LangInj, log10(pdfResult.raw.LangInj),'o','MarkerSize', mkrsize);
        hold off;
        kl = kl + 1;
    end
    grid on;
    ylim([-4 -1]);
    yt = get(gca, 'YTick');
    myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
    set(gca,'YTickLabel', myylabels);
    set(gca, 'YMinorTick','on', 'YMinorGrid','on');
    title(['Injected Power PDF ', num2str(str2double(freqsLab(i))/91.5), ' f_{RC}']);
    xlabel('V^2 \cdot Hz');
    currLegend = [currLegendSuchai, currLegendLab]';
    hleg = legend(currLegend,'Location','eastoutside','Orientation','vertical');
    set(hleg, 'Interpreter', 'none');
    figSaveName = [saveFolderFig, '/',suchaiFolders{i},'_LangInj_',date,'.png'];
    saveas(gcf, figSaveName);
end

%% LangDiss Plot
ks = 1;
kl = 1;
subFolderName = 'LangDiss';
saveFolderFig = [saveFolder , '/', subFolderName];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
for i = 1 : numel(suchaiFolders)
    hfig = figure('units','normalized','outerposition',[0 0 1 1]);
    currLegendSuchai = freqsLegendTM(ks:ks+tmPerFreqSuchai(i)-1);
    for j = 1 : tmPerFreqSuchai(i)
        xbins = matfileTM{ks}.xbins;
        pdfResult = matfileTM{ks}.pdfResult;
        Parameters = matfileTM{ks}.Parameters;
        hold on;
        plot(xbins.raw.LangDiss, log10(pdfResult.raw.LangDiss),'*','MarkerSize', mkrsize);
        hold off;
        ks = ks +1;
    end
    currLegendLab = freqsLegendLab(kl:kl+tmPerFreqLab(i)-1);
    for j = 1 : tmPerFreqLab(i)
        xbins = matfileLab{kl}.xbins;
        pdfResult = matfileLab{kl}.pdfResult;
        Parameters = matfileLab{kl}.Parameters;
        hold on;
        plot(xbins.raw.LangDiss, log10(pdfResult.raw.LangDiss),'o','MarkerSize', mkrsize);
        hold off;
        kl = kl + 1;
    end
    grid on;
    ylim([-4 -1]);
    yt = get(gca, 'YTick');
    myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
    set(gca,'YTickLabel', myylabels);
    set(gca, 'YMinorTick','on', 'YMinorGrid','on');
    title(['Dissipated Power PDF ', num2str(str2double(freqsLab(i))/91.5), ' f_{RC}']);
    xlabel('V^2 \cdot Hz');
    currLegend = [currLegendSuchai, currLegendLab]';
    hleg = legend(currLegend,'Location','eastoutside','Orientation','vertical');
    set(hleg, 'Interpreter', 'none');
    figSaveName = [saveFolderFig, '/',suchaiFolders{i},'_LangDiss_',date,'.png'];
    saveas(gcf, figSaveName);
end
close all;