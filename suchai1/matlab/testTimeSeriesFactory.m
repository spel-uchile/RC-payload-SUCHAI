clear all;
close all;

parserFolder = './parser';
fixtureFolder = strcat(parserFolder,'/test');
parserFiles = dir(fixtureFolder);
parserFiles = parserFiles(arrayfun(@(x) ~strcmp(x.name(1),'.')...
    ,parserFiles));
parserFiles = {parserFiles.name};
parserFiles = sortn(parserFiles);
saveFolder = './mat/ts/test';

inputFixture = strcat(fixtureFolder,'/', parserFiles{1});
outputFixture = strcat(fixtureFolder,'/', parserFiles{2});
S = load(outputFixture);
name = fieldnames(S);
adcPeriod = S.(name{1}).adcPeriod;
sampCoeff = S.(name{1}).oversamplingCoeff;
fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);

raw = timeSeriesFactory(fsignal, 'raw', inputFixture, outputFixture, sampCoeff);
save(strcat(saveFolder, '/',raw.Name,'.mat'),'raw','-v7.3');

simulation = timeSeriesFactory(fsignal, 'simulink', inputFixture, sampCoeff);
save(strcat(saveFolder, '/', simulation.Name,'.mat'),'simulation','-v7.3');

Parameters.numberOfRandomValues = 1e6;
Parameters.dacBits = 16;
Parameters.adcBits = 10;
Parameters.dacMaxVoltage = 3.3;
Parameters.dacMinvoltage = 0;
Parameters.oversamplingCoeff = 4;
Parameters.buffLen = 200;
Parameters.sampledValuesPerRound = floor(Parameters.buffLen / Parameters.oversamplingCoeff);
Parameters.nonSampledValuesPerRound = 0;
Parameters.nWaitingUnits = 0; 

theoretical = timeSeriesFactory(fsignal, 'theoretical', Parameters);
save(strcat(saveFolder, '/', theoretical.Name,'.mat'),'theoretical','-v7.3');

%% Visual check
subplot(3,1,1);
plot(raw.tsc.Vin);
hold on;
plot(raw.tsc.Vout);
title(['Raw data at ', num2str(raw.fsignal), ' Hz']);
xlabel(raw.tsc.Vin.TimeInfo.Units);
ylabel(raw.tsc.Vin.DataInfo.Units);

subplot(3,1,2);
plot(simulation.tsc.Vin);
hold on;
plot(simulation.tsc.Vout);
title(['Simulation data at ', num2str(simulation.fsignal), ' Hz']);
xlabel(simulation.tsc.Vin.TimeInfo.Units);
ylabel(simulation.tsc.Vin.DataInfo.Units);

subplot(3,1,3);
plot(theoretical.tsc.Vin);
hold on;
plot(theoretical.tsc.Vout);
title(['Theoretical data at ', num2str(theoretical.fsignal), ' Hz']);
xlabel(theoretical.tsc.Vin.TimeInfo.Units);
ylabel(theoretical.tsc.Vin.DataInfo.Units);