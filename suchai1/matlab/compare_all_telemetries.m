rootMatFiles = './mat/pdf_compare_all_telemetries_script';
rootFiles = dir(rootMatFiles);
rootFiles = {rootFiles.name};
rootFiles = rootFiles(3:end)';
rootFiles = sortn(rootFiles);

labFolder = '2016_18_05';
idxCell = strfind(rootFiles, labFolder);
labFolderIdx = find(not(cellfun('isempty',idxCell)));

suchaiIndex = 1 : numel(rootFiles);
suchaiIndex(labFolderIdx) = [];
freqsTelemetry = cell(1,numel(suchaiIndex));
freqsLegend = cell(1,numel(suchaiIndex));
matfileTM =  cell(1,numel(suchaiIndex));

figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1 : numel(suchaiIndex)
    
    tmFolder = strcat(rootMatFiles,'/', rootFiles{suchaiIndex(i)});
    subfolder = dir(tmFolder);
    subfolder = {subfolder.name};
    subfolder = subfolder(3:end)';
    subfolder = sortn(subfolder);
    freqInHz = subfolder{1};
    freqsTelemetry{i} = freqInHz;
    freqsLegend{i} = strcat(num2str(str2double(freqInHz)/91.5),' f_{RC} SUCHAI');
    tmFolder = strcat(tmFolder,'/',subfolder{1});
    tmFile = dir(tmFolder);
    tmFile = {tmFile.name};
    tmFile = tmFile(3:end)';
    
    pathMatTelemetry = strcat(tmFolder,'/', tmFile{1});
    matfileTM{i} = load(pathMatTelemetry);
    xbins = matfileTM{i}.xbins;
    pdfResult = matfileTM{i}.pdfResult;
    Parameters = matfileTM{i}.Parameters;
    %% Plots
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
legend(freqsLegend,'Location','south','Orientation','vertical');

saveas(gcf,['./img/suchai-vs-lab/','compareAllTelemetries_','vout_',date,'.png']);
saveas(gcf,['./img/suchai-vs-lab/','compareAllTelemetries_','vout_',date,'.eps'],'epsc');


figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1 : numel(suchaiIndex)
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
legend(freqsLegend,'Location','south','Orientation','vertical');


saveas(gcf,['./img/suchai-vs-lab/','compareAllTelemetries_','power_',date,'.png']);
saveas(gcf,['./img/suchai-vs-lab/','compareAllTelemetries_','power_',date,'.eps'],'epsc');