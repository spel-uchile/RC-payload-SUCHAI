clear all;

%% Load variables
date = '2016_18_05';
prefix = strcat(date, '_');
folder = './img/dataEfficiency/';
matfilename = strcat(prefix, 'ExpFisTimeSeries.mat');
load(matfilename);

tolerance = 5e-3;
span = 2e-3;
buffLen = 200;

names = fieldnames(ExpFisTimeSeries);
for i = 1 : length(names)
    TSeries = ExpFisTimeSeries.(names{i});
    dataTSC = TSeries.tscData;
    freqSignalHz  = TSeries.freqSignalHz;
    vout = dataTSC.vout;
    
    [indexes, cumMeanSignal, ~] = findSState('buffered', vout.Data, tolerance, span , buffLen);
    yCum = cumMeanSignal;
    yRaw = vout.Data;
    winIni = 11;
    winEnd = 20;
    ini = (winIni - 1)* buffLen + 1;
    endd =  winEnd* buffLen;
    x = 1:1:(endd-ini+1);
    yCum = yCum(ini : endd);
    yRaw = yRaw(ini : endd);
    plotIndexes = zeros(1, winEnd - winIni +1);
    yIndexes = zeros(size(plotIndexes));
    for jj = 1 : length(plotIndexes)
        tmp = indexes(jj+winIni-1);
        if tmp <= buffLen
            plotIndexes(jj) = indexes(jj+winIni-1) + (jj-1)*buffLen;
        else
            plotIndexes(jj) = jj*buffLen;
        end
        yIndexes(jj) = yCum(plotIndexes(jj));
    end
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    plot(x,yRaw,'b--', x,yCum, 'r-');
    plot(plotIndexes, yIndexes, 'ro','MarkerSize',5, 'MarkerFaceColor', 'r');
    grid on;
    maxY = max(tolerance);
    minY = min(-tolerance);
    refMin = refline([0 minY]);
    refMin.Color = 'g';
    refMin.LineStyle = '-';
    refMax = refline([0 maxY]);
    refMax.Color = 'g';
    refMax.LineStyle = '-';
    
    legend('vout', 'cummean', 'detection', '+ ref', '- ref');
    title(['Cummulative mean for frequency',' ', num2str(freqSignalHz), ' Hz']);
    xlabel('Sample Index');
    ylabel('Volts');
    saveas(gcf,strcat(folder,prefix,'cumMeanSignal_',num2str(freqSignalHz),'.png'));
    close all;
end