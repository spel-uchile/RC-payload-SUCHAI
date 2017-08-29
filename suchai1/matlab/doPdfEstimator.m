prefix = '2017_08_29';

seedFolder = ['./mat/ts/', prefix ];
freqs = dir(seedFolder);
freqs = {freqs.name};
freqs = freqs(3:end);
freqs = sortn(freqs);
freqsFolder = strcat(seedFolder, '/', freqs);
freqs = lower(freqs);

for i = 1 : length(freqs)
    
    saveFolder = ['./mat/pdf/',prefix,'/',freqs{i}];
    currFreqFolder = freqsFolder{i};
    
    freqCircuitHz = 92;
    R = 1210;
    C = 1 / (freqCircuitHz * 2 * pi * R);
    dampingRate = 1/ (R*C);
    npoints = 200;
    
    matfiles = dir(currFreqFolder);
    matfiles = {matfiles.name};
    matfiles = matfiles(3:end);
    matfiles = sortn(matfiles);
    
    for k = 1 : numel(matfiles)
        file = [currFreqFolder,'/', matfiles{k}];
        S = load(file);
        name = fieldnames(S);
        name = name{1};
        ts = S.(name);
        [pdfResult.(name), xbins.(name),Parameters.(name)]= pdfEstimator(ts, [], npoints );
    end
    if ~isdir(saveFolder)
        mkdir(saveFolder)
    end
    save(strcat(saveFolder, '/pdfEstimator_',freqs{i},'Hz.mat'),'pdfResult','xbins','Parameters','-v7.3');
    
    %% Plots
    figure('units','normalized','outerposition',[0 0 1 1]);
    pause(0.001);
    nPlots = 3;
    
    subplot(nPlots,1,1);
    plot(xbins.theoretical.Vin, pdfResult.theoretical.Vin);
    hold on;
    plot(xbins.raw.Vin, pdfResult.raw.Vin);
    plot(xbins.filtered.Vin, pdfResult.filtered.Vin);
    plot(xbins.simulation.Vin, pdfResult.simulation.Vin);
    title(['Vin PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
    xlabel(ts.tsc.Vin.DataInfo.Units);
    legend('theoretical', 'raw','filtered', 'simulation');
    
    subplot(nPlots,1,2);
    plot(xbins.theoretical.Vout, pdfResult.theoretical.Vout);
    hold on;
    plot(xbins.raw.Vout, pdfResult.raw.Vout);
    plot(xbins.filtered.Vout, pdfResult.filtered.Vout);
    plot(xbins.simulation.Vout, pdfResult.simulation.Vout);
    title(['Vout PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
    xlabel(ts.tsc.Vout.DataInfo.Units);
    legend('theoretical', 'raw','filtered', 'simulation');
    
    subplot(nPlots,1,3);
    plot(xbins.theoretical.injectedPower, pdfResult.theoretical.injectedPower);
    hold on;
    plot(xbins.raw.injectedPower, pdfResult.raw.injectedPower);
    plot(xbins.filtered.injectedPower, pdfResult.filtered.injectedPower);
    plot(xbins.simulation.injectedPower, pdfResult.simulation.injectedPower);
    title(['injectedPower PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
    xlabel(ts.tsc.injectedPower.DataInfo.Units);
    legend('theoretical', 'raw','filtered', 'simulation');
    
    saveFolder = ['img/',prefix,'_pdfEstimator/'];
    if ~isdir(saveFolder)
        mkdir(saveFolder)
    end
    saveAsPngFile = [date,'_doEstimator'];
    saveas(gcf,[saveFolder,saveAsPngFile,'_',freqs{i},'Hz.png'])
    pause(1);
    close all;
end
