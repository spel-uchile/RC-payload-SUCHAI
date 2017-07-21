close all;

date = '2016_25_06';
prefix = strcat(date,'_');
saveFolder = strcat('./img/',date,'/');
mkdir(saveFolder);
histogramFileName = strcat(prefix, 'SimulationHistogram.mat');
load( histogramFileName );

names = fieldnames ( SimulationHistogram );
for i = 1 : length(names)
    %% Load counts and edges
    HistCounts = SimulationHistogram.(names{i});
    freqSignalHz = HistCounts.freqSignalHz;
    disp(strcat(num2str(i-1),' Plotting freq ', num2str(freqSignalHz), ' Hz'));
        
    %% Vin Histogram
    hSimVin = HistCounts.hSimVin;
    eSimVin = HistCounts.eSimVin;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    h = histogram(interpolateDataFromCounts(hSimVin, eSimVin), eSimVin);
    h.Normalization = 'probability';
    titleName = strcat('Vin Histogram Simulation fsignal = ',num2str(freqSignalHz), 'Hz');
    title(titleName);
    saveas(gcf, strcat(saveFolder,'simvin_freq',num2str(i-1),'.png'));
    
    %% Vout
    hSimVout = HistCounts.hSimVout;
    eSimVout = HistCounts.eSimVout;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    h = histogram(interpolateDataFromCounts(hSimVout, eSimVout), eSimVout);
    h.Normalization = 'probability';
    xlim([-1.2 1.2]);
    titleName = strcat('Vout Histogram Simulation fsignal = ',num2str(freqSignalHz), 'Hz');
    title(titleName);
    saveas(gcf, strcat(saveFolder,'simvout_freq',num2str(i-1),'.png'));
 
    %% Power
    hSimPower = HistCounts.hSimPower;
    eSimPower = HistCounts.eSimPower;

    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    h = histogram(interpolateDataFromCounts(hSimPower, eSimPower), eSimPower);
    h.Normalization = 'probability';
    xlim([-1.2 2.2]);
    titleName = strcat('Injected Power Simulation fsignal = ',num2str(freqSignalHz), 'Hz');
    title(titleName);
    saveas(gcf, strcat(saveFolder,'simpower_freq',num2str(i-1),'.png'));
    
end