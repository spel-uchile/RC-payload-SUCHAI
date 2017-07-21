clear all;
close all;

date = {'2016_17_05', '2016_18_05'};
points = {1000, 10000};
for k = 1 : length(date)
    pointsStr = num2str(points{k});
    samplesStr = num2str(4*points{k});
    matFileName = strcat(date{k},'_Distributions.mat');
    load(matFileName)
    names = fieldnames(ExpFisDistributions);
    plotFolder = strcat('./img/distributionsFinal/');
    
    for i = 1 : length(names)
        % Load counts and edges
        CurrentFreq = ExpFisDistributions.(names{i});
        f = CurrentFreq.freqSignalHz;
        Vin = CurrentFreq.vin;
        Vout = CurrentFreq.vout;
        Power = CurrentFreq.power;
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        hold on;
        xlim([-1 1]);
        plot(Vin.supportVector, Vin.teo);
        plot(Vin.supportVector, Vin.data);
        plot(Vin.supportVector, Vin.filtered);
        plot(Vin.supportVector, Vin.sim);
        xlabel('Vin [V]');
        legend('theoretical', 'raw data', 'filtered data', 'simulation');
        title(strcat('Input voltage distribution for signal = ',num2str(f), ...
            ' Hz, (N,S) = (',pointsStr,',',samplesStr,')'))
        saveas(gcf,strcat(plotFolder,date{k},'_vin_pdf_freq_',num2str(f),'.png'));
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        hold on;
        xlim([-1 1]);
        plot(Vout.supportVector, Vout.teo);
        plot(Vout.supportVector, Vout.data);
        plot(Vout.supportVector, Vout.filtered);
        plot(Vout.supportVector, Vout.sim);
        xlabel('Vout [V]');
        legend('theoretical', 'raw data', 'filtered data', 'simulation');
        title(strcat('Output voltage distribution for signal = ',num2str(f), ...
            ' Hz, (N,S) = (',pointsStr,',',samplesStr,')'))
        saveas(gcf,strcat(plotFolder,date{k},'_vout_pdf_freq_',num2str(f),'.png'));
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        hold on;
        plot(Power.supportVector, Power.teo);
        plot(Power.supportVector, Power.data);
        plot(Power.supportVector, Power.filtered);
        plot(Power.supportVector, Power.sim);
        semilogy(Power.supportVector, Power.teo, Power.supportVector, Power.data...
            ,Power.supportVector, Power.filtered,Power.supportVector, Power.sim);
        xlim([-0.6 0.6]);
        xlabel('Power [mW]');
        legend('theoretical', 'raw data', 'filtered data', 'simulation');
        title(strcat('Power distribution for signal = ',num2str(f), ...
            ' Hz, (N,S) = (',pointsStr,',',samplesStr,')'));
        saveas(gcf,strcat(plotFolder,date{k},'_power_pdf_freq_',num2str(f),'.png'));
        pause(1);
        close all;
    end
end
