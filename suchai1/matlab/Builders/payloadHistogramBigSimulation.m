prefix = '2016_25_06_';
bins = 331;

names = {};
for i = 1 : 15
    timeseriesFileName = strcat(prefix, 'Simulation_freq',num2str(i-1),'.mat');
    names{i} = strcat('freq', num2str(i-1));
    
    load(timeseriesFileName);
    
    %% Load real data & simulation data
    
    SimTimeSeries = Simulation.timeSeries;
    freqSignalHz = Simulation.freqSignalHz;
    fsHz = Simulation.fsHz;
    simVin = SimTimeSeries.simVin;
    simVout = SimTimeSeries.simVout;
    simPower = SimTimeSeries.simPower;
    
    %% Compute HisCounts
    [hSimVin, eSimVin] = histcounts(simVin.Data, bins);
    [hSimVout, eSimVout] = histcounts(simVout.Data, bins);
    [hSimPower, eSimPower] = histcounts(simPower.Data, bins);
    
    %% Save to Struct
    
    SimulationHistogram.(names{i}).freqSignalHz = freqSignalHz;
    SimulationHistogram.(names{i}).fsHz = fsHz;
    SimulationHistogram.(names{i}).hSimVin = hSimVin;
    SimulationHistogram.(names{i}).eSimVin = eSimVin;
    SimulationHistogram.(names{i}).hSimVout = hSimVout;
    SimulationHistogram.(names{i}).eSimVout = eSimVout;
    SimulationHistogram.(names{i}).hSimPower = hSimPower;
    SimulationHistogram.(names{i}).eSimPower = eSimPower;
    
end

histogramFileName = strcat(prefix, 'SimulationHistogram.mat');
disp(strcat('Saving into "',histogramFileName,'" MAT-file'));

save(histogramFileName,'SimulationHistogram','-v7.3');
