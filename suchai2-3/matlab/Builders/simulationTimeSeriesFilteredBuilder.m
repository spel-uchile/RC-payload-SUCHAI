clear all;
close all;
%% Load variables
date = '2016_25_06';
prefix = strcat(date, '_');
totalFreqs = 15;
points = zeros(1,totalFreqs);
freq = zeros(1,totalFreqs);
for i = 1 : totalFreqs
    matfilename = strcat(prefix, 'Simulation_freq', num2str(i-1),'.mat');
    load(matfilename);
    
    simTSC = Simulation.timeSeries;
    freq(i) = Simulation.freqSignalHz;
    fsHz = Simulation.fsHz;
    freqSignalHz  = Simulation.freqSignalHz;
    
    vin = simTSC.simVin;
    vout = simTSC.simVout;
    power = simTSC.simPower;
    
    %% Missed points
    tolerance = 5e-3;
    span = 2e-3;
    
    [indexes, signal, points(i)] = findSState('simple', vout.Data, tolerance,...
        span , length(vout.Data));
    
    filteredVin = filterPayloadTimeSeries( vin , indexes, length(vin.Data));
    filteredVin.Name = 'simVin';
    filteredVout = filterPayloadTimeSeries( vout , indexes, length(vout.Data));
    filteredVout.Name = 'simVout';
    filteredPower = filterPayloadTimeSeries( power , indexes, length(power.Data));
    filteredPower.Name = 'simPower';
    
    tscName = 'timeSeries';
    tscData = tscollection({filteredVin, filteredVout, filteredPower}, 'Name', tscName);
    
    dataEff = 1 - points(i)/length(vout.Data);
    
    SimulationFiltered.fsHz = fsHz;
    SimulationFiltered.freqSignalHz = freqSignalHz;
    SimulationFiltered.tscData = tscData;
    SimulationFiltered.efficiency = dataEff;
    
    timeseriesMATFileName = strcat(prefix, 'SimulationFiltered_freq', ...
        num2str(i-1),'.mat');
    disp(strcat('Saving into "',timeseriesMATFileName,'" MAT-file'));
    
    save(timeseriesMATFileName,'SimulationFiltered','-v7.3');
end