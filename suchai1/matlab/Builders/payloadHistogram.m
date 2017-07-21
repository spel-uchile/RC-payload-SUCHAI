function histogramFileName = payloadHistogram(prefix, bins)
timeseriesFileName = strcat(prefix, 'ExpFisTimeSeries.mat');

if ~exist(timeseriesFileName,'file')
    timeseriesFileName = payloadTimeSeriesBuilder(prefix);
end

load(timeseriesFileName);
names = fieldnames ( ExpFisTimeSeries );
disp('payloadHistogram...');

for i = 1 : length( fieldnames ( ExpFisTimeSeries ) )
    %% Load real data & simulation data

    PayloadTSeries = ExpFisTimeSeries.(names{i});
    freqSignalHz = PayloadTSeries.freqSignalHz;
    disp(strcat(num2str(i-1),' Computing freq ', num2str(freqSignalHz), ' Hz'));
    
    tscData = PayloadTSeries.tscData;
    vin = tscData.vin;
    vout = tscData.vout;
    power = tscData.power;
    
    tscSimulation =  PayloadTSeries.tscSimulation;
    simVin = tscSimulation.simVin;
    simVout = tscSimulation.simVout;
    simPower = tscSimulation.simPower;
        
    %% Vin
    meanVin = vin.mean;
    meanSimVin = simVin.mean;
    centeredVin = vin.Data - meanVin;
    centeredSimVin = simVin.Data - meanSimVin;
    [hVin, eVin] = histcounts(centeredVin, bins);
    [hSimVin, eSimVin] = histcounts(centeredSimVin, eVin);
    
    %% Vout
    meanVout = vout.mean;
    meanSimVout = simVout.mean;
    centeredVout = vout.Data - meanVout;
    centeredSimVout = simVout.Data - meanSimVout;
    [hVout, eVout] = histcounts(centeredVout, bins);
    [hSimVout, eSimVout] = histcounts(centeredSimVout, eVout);

    %% Power
    meanPower = power.mean;
    meanSimPower = simPower.mean;
    centeredPower = power.Data - meanPower;
    centeredSimPower = simPower.Data - meanSimPower;
    [hPower, ePower] = histcounts(centeredPower, bins);
    [hSimPower, eSimPower] = histcounts(centeredSimPower, ePower);
    
    %% Save to Struct
    ExpFisHistogram.(names{i}).freqSignalHz = freqSignalHz;
    ExpFisHistogram.(names{i}).fsHz = ExpFisTimeSeries.(names{i}).fsHz;
    ExpFisHistogram.(names{i}).data.hVin = hVin;
    ExpFisHistogram.(names{i}).data.eVin = eVin;
    ExpFisHistogram.(names{i}).data.hVout = hVout;
    ExpFisHistogram.(names{i}).data.eVout = eVout;
    ExpFisHistogram.(names{i}).data.hPower = hPower;
    ExpFisHistogram.(names{i}).data.ePower = ePower;
    ExpFisHistogram.(names{i}).simulation.hVin = hSimVin;
    ExpFisHistogram.(names{i}).simulation.eVin = eSimVin;
    ExpFisHistogram.(names{i}).simulation.hVout = hSimVout;
    ExpFisHistogram.(names{i}).simulation.eVout = eSimVout;
    ExpFisHistogram.(names{i}).simulation.hPower = hSimPower;
    ExpFisHistogram.(names{i}).simulation.ePower = eSimPower;

end

histogramFileName = strcat(prefix, 'ExpFisHistogram.mat');
disp(strcat('Saving into "',histogramFileName,'" MAT-file'));

save(histogramFileName,'ExpFisHistogram','-v7.3');
end
