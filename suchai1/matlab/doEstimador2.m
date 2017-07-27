clear all;
close all;

seed = {'seed0', 'seed1000', 'seed5000'};
date = '2017_11_03';
saveAsPngFile = 'doEstimator2';

for j = 1:1%length(seed)
    seedd = seed{j};
    
    seedFolder = ['./mat/ts/', date,'/' seedd];
    freqs = dir(seedFolder);
    freqs = {freqs.name};
    freqs = freqs(3:end);
    freqs = sortn(freqs);
    freqsFolder = strcat(seedFolder, '/', freqs);
    freqs = lower(freqs);
    
    for i = 1 : length(freqs)
        
        saveFolder = ['./mat/pdf/',date,'/', seedd,'/',freqs(i)];
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
        
        %% Plots
        figure;
        pause(0.001);
        frame_h = get(handle(gcf),'JavaFrame');
        set(frame_h,'Maximized',1);
        
        subplot(3,1,1);
        plot(xbins.raw.Vin, pdfResult.raw.Vin);
        hold on;
        plot(xbins.theoretical.Vin, pdfResult.theoretical.Vin);
        title(['Vin PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
        xlabel(ts.tsc.Vin.DataInfo.Units);
        legend( 'data','theoretical');
        
        subplot(3,1,2);
        plot(xbins.raw.Vin, pdfResult.raw.Vin);
        hold on;
        plot(xbins.theoretical.Vout, pdfResult.theoretical.Vout);
        title(['Vout PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
        xlabel(ts.tsc.Vout.DataInfo.Units);
        legend( 'data','theoretical');
        
        subplot(3,1,3);
        plot(xbins.raw.injectedPower, pdfResult.raw.injectedPower);
        hold on;
        plot(xbins.theoretical.injectedPower, pdfResult.theoretical.injectedPower);
        title(['injectedPower PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
        xlabel(ts.tsc.injectedPower.DataInfo.Units);
        legend( 'data','theoretical');
        
        pause(2);
        saveas(gcf,[saveAsPngFile,'_',seedd,'_',freqs{i},'.png'])
        close all;
    end
end