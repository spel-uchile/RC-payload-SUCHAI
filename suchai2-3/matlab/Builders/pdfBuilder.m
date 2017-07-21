clear all;
close all;

numBins = 1000;
date = {'2016_17_05', '2016_18_05'};
for k = 1 : length(date)
    prefix{k} = strcat(date{k},'_');
    filteredFilename = strcat(prefix{k}, 'FilteredSeries.mat');
    seriesFilename = strcat(prefix{k}, 'ExpFisTimeSeries.mat');
    FilterSeriesStruct{k} = load(filteredFilename);
    RawSeriesStruct{k} = load(seriesFilename);
end

names = fieldnames(FilterSeriesStruct{1}.FilteredSeries);
simulationFileName = cell(1, length(names));
for i = 1: length(names)
    simulationFileName{i} = strcat('2016_25_06_SimulationFiltered_freq',num2str(i-1),'.mat');
end

for i = 1 : length(names)
    f = zeros(1, length(names));
    fs = zeros(1, length(names));
    
    for k = 1: length(date)
        disp(strcat('loading ',' ', simulationFileName{i}));
        simulation{k} = load(simulationFileName{i});
        
        SimTimeSeries = simulation{k}.SimulationFiltered.tscData;
        teoVin{k} = SimTimeSeries.simVin.Data;
        teoVout{k} = SimTimeSeries.simVout.Data;
        teoPower{k} = SimTimeSeries.simPower.Data;
        
        TSeries = RawSeriesStruct{k}.ExpFisTimeSeries.(names{i});
        dataTSC = TSeries.tscData;
        simTSC = TSeries.tscSimulation;
        
        FiSeries = FilterSeriesStruct{k}.FilteredSeries.(names{i});
        FSeries = FiSeries.tscData;
        filteredVin{k} = FSeries.vin.Data;
        filteredVout{k} = FSeries.vout.Data;
        filteredPower{k} = FSeries.power.Data;
        vinData{k} = dataTSC.vin.Data;
        simVinData{k} = simTSC.simVin.Data;
        voutData{k} = dataTSC.vout.Data;
        simVoutData{k} = simTSC.simVout.Data;
        powerData{k} = dataTSC.power.Data;
        simPowerData{k} = simTSC.simPower.Data;
    end
    
    f(i) = FiSeries.freqSignalHz;
    fs(i) = FiSeries.fsHz;
    
    %% Vin
    xmin = -0.8;
    xmax = 0.8;
    xx = linspace(xmin,xmax, numBins);
    
    [fVin, ~, bwRawVin] = ksdensity(vinData{1},xx);
    pdfVin = normalize(xx, fVin);
    [fSimVin, ~, bwSimVin] = ksdensity(simVinData{1},xx);
    pdfSimVin = normalize(xx, fSimVin);
    [fteoVin, ~, bwTeoVin] = ksdensity(teoVin{1},xx);
    pdfTeoVin = normalize(xx, fteoVin);
    [fFilteredVin, ~, bwFiltVin] = ksdensity(filteredVin{1}, xx);
    pdfFilteredVin = normalize(xx,fFilteredVin);
    
    Input1.teo = pdfTeoVin;
    Input1.data = pdfVin;
    Input1.filtered = pdfFilteredVin;
    Input1.sim = pdfSimVin;
    Input1.supportVector = xx;
    disp('vin 1 ');
    
    [fVin, ~, bwRawVin] = ksdensity(vinData{2},xx,'Bandwidth',bwRawVin);
    pdfVin = normalize(xx, fVin);
    [fSimVin, ~, bwSimVin] = ksdensity(simVinData{2},xx, 'Bandwidth', bwSimVin);
    pdfSimVin = normalize(xx, fSimVin);
    [fteoVin, ~, bwTeoVin] = ksdensity(teoVin{2},xx,'Bandwidth', bwTeoVin);
    pdfTeoVin = normalize(xx, fteoVin);
    [fFilteredVin, ~, bwFiltVin] = ksdensity(filteredVin{2}, xx, 'Bandwidth', bwFiltVin);
    pdfFilteredVin = normalize(xx,fFilteredVin);
    
    Input2.teo = pdfTeoVin;
    Input2.data = pdfVin;
    Input2.filtered = pdfFilteredVin;
    Input2.sim = pdfSimVin;
    Input2.supportVector = xx;
    Input{1} = Input1;
    Input{2} = Input2;
    disp('vin 2 ');
    
    %% Vout
    xmin = -0.9;
    xmax = 0.9;
    xx = linspace(xmin, xmax, numBins);
    
    [fVout, ~, bwRawVout] = ksdensity(voutData{1},xx);
    pdfVout = normalize(xx, fVout);
    [fSimVout, ~, bwSimVout] = ksdensity(simVoutData{1},xx);
    pdfSimVout = normalize(xx, fSimVout);
    [fteoVout, ~, bwTeoVout] = ksdensity(teoVout{1},xx);
    pdfTeoVout = normalize(xx, fteoVout);
    [fFilteredVout, ~, bwFilVout] = ksdensity(filteredVout{1}, xx);
    pdfFilteredVout = normalize(xx, fFilteredVout);
    
    Output1.teo = pdfTeoVout;
    Output1.data = pdfVout;
    Output1.filtered = pdfFilteredVout;
    Output1.sim = pdfSimVout;
    Output1.supportVector = xx;
    disp('vout 1');
    
    [fVout, ~, bwRawVout] = ksdensity(voutData{2},xx,'Bandwidth',bwRawVout);
    pdfVout = normalize(xx, fVout);
    [fSimVout, ~, bwSimVout] = ksdensity(simVoutData{2},xx,'Bandwidth',bwSimVout);
    pdfSimVout = normalize(xx, fSimVout);
    [fteoVout, ~, bwTeoVout] = ksdensity(teoVout{2},xx,'Bandwidth',bwTeoVout);
    pdfTeoVout = normalize(xx, fteoVout);
    [fFilteredVout, ~, bwFilVout] = ksdensity(filteredVout{2}, xx,'Bandwidth',bwFilVout);
    pdfFilteredVout = normalize(xx, fFilteredVout);
    
    Output2.teo = pdfTeoVout;
    Output2.data = pdfVout;
    Output2.filtered = pdfFilteredVout;
    Output2.sim = pdfSimVout;
    Output2.supportVector = xx;
    Output{1} = Output1;
    Output{2} = Output2;
    disp('vout 2 ');
    
    %% Power
    xmin = -0.6;
    xmax = 0.6;
    xx = linspace(xmin, xmax, numBins);
    
    [fPower, ~, bwRawPower] = ksdensity(powerData{1},xx);
    pdfPower = normalize(xx, fPower);
    [fSimPower, ~, bwSimPower] = ksdensity(simPowerData{1},xx);
    pdfSimPower = normalize(xx, fSimPower);
    [fteoPower, ~, bwTeoPower] = ksdensity(teoPower{1},xx);
    pdfTeoPower = normalize(xx, fteoPower);
    [fFilteredPower, ~, bwFilPower] = ksdensity(filteredPower{1}, xx);
    pdfFilteredPower = normalize(xx, fFilteredPower);
    
    Power1.teo = pdfTeoPower;
    Power1.data = pdfPower;
    Power1.filtered = pdfFilteredPower;
    Power1.sim = pdfSimPower;
    Power1.supportVector = xx;
    disp('power 1 ');
    
    [fPower, ~, bwRawPower] = ksdensity(powerData{2},xx,'Bandwidth',bwRawPower);
    pdfPower = normalize(xx, fPower);
    [fSimPower, ~, bwSimPower] = ksdensity(simPowerData{2},xx,'Bandwidth',bwSimPower);
    pdfSimPower = normalize(xx, fSimPower);
    [fteoPower, ~, bwTeoPower] = ksdensity(teoPower{2},xx,'Bandwidth',bwTeoPower);
    pdfTeoPower = normalize(xx, fteoPower);
    [fFilteredPower, ~, bwFilPower] = ksdensity(filteredPower{2}, xx,'Bandwidth',bwFilPower);
    pdfFilteredPower = normalize(xx, fFilteredPower);
    
    Power2.teo = pdfTeoPower;
    Power2.data = pdfPower;
    Power2.filtered = pdfFilteredPower;
    Power2.sim = pdfSimPower;
    Power2.supportVector = xx;
    Power{1} = Power1;
    Power{2} = Power2;
    disp('power 2 ');
    
    for k = 1 : length(date)
        ExpFisDistributions.(names{i}).vin = Input{k};
        ExpFisDistributions.(names{i}).vout = Output{k};
        ExpFisDistributions.(names{i}).power = Power{k};
        ExpFisDistributions.(names{i}).freqSignalHz = f(i);
        ExpFisDistributions.(names{i}).fsHz = fs(i);
        
        pdfMatFile = strcat(prefix{k}, 'Distributions.mat');
        disp(strcat('Saving into "', pdfMatFile,'" MAT-file'));
        save(pdfMatFile,'ExpFisDistributions','-v7.3');
    end
    disp('struct ready ');

end