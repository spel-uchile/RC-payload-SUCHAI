clear all;
close all;
%% Load variables

alldates = {'2016_17_05', '2016_18_05'};
for k = 1: length(alldates)
    date = alldates{k};
    prefix = strcat(date, '_');
    filteredFilename = strcat(prefix, 'FilteredSeries.mat');
    load(filteredFilename);
    folder = './img/dataEfficiency/';
    
    points = {1000, 10000};
    pointsStr = num2str(points{k});
    samplesStr = num2str(4*points{k});
    
    names = fieldnames(FilteredSeries);
    points = zeros(1,length(names));
    dataEfficiency = zeros(1,length(names));
    simEfficiency = zeros(1,length(names));
    freq = zeros(1,length(names));
    % s
    for i = 1 : length(names)
        FiSeries = FilteredSeries.(names{i});
        dataEfficiency(i) = FiSeries.efficiencyData;
        simEfficiency(i) = FiSeries.efficiencySimulation;
        freq(i) = FiSeries.freqSignalHz;
    end
    
    %% data efficiency
    x = freq;
    y = 100.* dataEfficiency;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    semilogx(freq, y,'o');
    hold on;
    grid on;
    maxY = max(y);
    minY = min(y);
    refMin = refline([0 minY]);
    refMin.Color = 'b';
    refMin.LineStyle = '--';
    refMax = refline([0 maxY]);
    refMax.Color = 'k';
    refMax.LineStyle = '--';
    
    [fobjQuad, godQuad, ~] = fit(x',y', 'poly3');
    plot(fobjQuad,'r');
    
    xlabel('freq [Hz]');
    ylabel('%');
    ylim([0 100]);
    xMin = min(x);
    xMax = max(x);
    xlim([xMin xMax]);
    title(strcat('Useful samples due to Buffering (N,S) = (',pointsStr,',',...
        samplesStr,')'));
    leg1 = strcat('useful sample ratio');
    leg2 = strcat('min = ',num2str(minY),' %');
    leg3 = strcat('max = ',num2str(maxY),' %');
    leg5 = strcat('cubic fit; R² =', ' ', num2str(godQuad.rsquare));
    legend(leg1, leg2, leg3, leg5,'Location','northeast');
    saveas(gcf,strcat(folder,prefix,'dataEfficiency','.png'));
    
    %% simulink efficiency
    x = freq;
    y = 100.* simEfficiency;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    semilogx(freq, y,'o');
    hold on;
    grid on;
    maxY = max(y);
    minY = min(y);
    refMin = refline([0 minY]);
    refMin.Color = 'b';
    refMin.LineStyle = '--';
    refMax = refline([0 maxY]);
    refMax.Color = 'k';
    refMax.LineStyle = '--';
    
    [fobjQuad, godQuad, ~] = fit(x',y', 'poly3');
    plot(fobjQuad,'r');
    
    xlabel('freq [Hz]');
    ylabel('%');
    ylim([0 100]);
    xMin = min(x);
    xMax = max(x);
    xlim([xMin xMax]);
    title(strcat('(Simulation) Useful samples due to Buffering (N,S) = (',pointsStr,',',...
        samplesStr,')'));
    leg1 = strcat('useful sample ratio');
    leg2 = strcat('min = ',num2str(minY),' %');
    leg3 = strcat('max = ',num2str(maxY),' %');
    leg5 = strcat('cubic fit; R² =', ' ', num2str(godQuad.rsquare));
    legend(leg1, leg2, leg3, leg5,'Location','southeast');
    saveas(gcf,strcat(folder,prefix,'simEfficiency','.png'));
    
end