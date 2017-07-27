clear all;
close all;

parserFolder = './parser';
fixtureFolder = strcat(parserFolder,'/test');
parserFiles = dir(fixtureFolder);
parserFiles = {parserFiles.name};
parserFiles = parserFiles(3:end)';
parserFiles = sortn(parserFiles);

inputFixture = strcat(fixtureFolder,'/', parserFiles{1});
outputFixture = strcat(fixtureFolder,'/', parserFiles{2});
S = load(outputFixture);
name = fieldnames(S);

adcPeriod = S.(name{1}).adcPeriod;
sampCoeff = S.(name{1}).oversamplingCoeff;

fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);    %try different values
fsignal = fsignal / 100;
Parameters.dacBits = 16;
Parameters.dacMaxVoltage = 3.3;
Parameters.dacMinvoltage = 0;
Parameters.oversamplingCoeff = 4;
Parameters.adcMaxVoltage = 3.3;
Parameters.adcMinVoltage = 0;
Parameters.adcBits = 10;
Parameters.buffLen = 200;   %try with 200
Parameters.adcPeriod = adcPeriod;
Parameters.sampledValuesPerRound = floor(Parameters.buffLen / Parameters.oversamplingCoeff);
Parameters.rounds = 3;
Parameters.nWaitingUnits = 350; %check if is good enough
Parameters.nonSampledValuesPerRound = 500;  %try different values

op1 = simulationFactory(fsignal, 'option1', Parameters);
op2 = simulationFactory(fsignal, 'option2', Parameters);
op3 = simulationFactory(fsignal, 'option3', Parameters);
[completeSignal, sampled] = simulationFactory(fsignal, 'option1+3', Parameters);
Parameters.numberOfRandomValues = 1e3;
theoretical = simulationFactory(fsignal, 'theoretical', Parameters);

%% Plots
nPlots = 3;
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(nPlots,1,1)
plot(op1.tsc.Vin);
hold on;
plot(op1.tsc.Vout);
title(['Option 1 at ', num2str(op1.fsignal), ' Hz']);
xlabel(op1.tsc.Vin.TimeInfo.Units);
ylabel(op1.tsc.Vin.DataInfo.Units);
legend('vin','vout');

subplot(nPlots,1,2);
plot(op2.tsc.Vin);
hold on;
plot(op2.tsc.Vout);
title(['Option 2 at ', num2str(op1.fsignal), ' Hz']);
xlabel(op1.tsc.Vin.TimeInfo.Units);
ylabel(op1.tsc.Vin.DataInfo.Units);
legend('vin','vout');

subplot(nPlots,1,3);
plot(op3.tsc.Vin);
hold on;
plot(op3.tsc.Vout);
title(['Option 3 at ', num2str(op1.fsignal), ' Hz']);
xlabel(op1.tsc.Vin.TimeInfo.Units);
ylabel(op1.tsc.Vin.DataInfo.Units);
legend('vin','vout');

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(nPlots,1,1);
plot(completeSignal.tsc.Vin);
hold on;
plot(completeSignal.tsc.Vout);
title(['Option 1+3 at ', num2str(completeSignal.fsignal), ' Hz']);
xlabel(completeSignal.tsc.Vin.TimeInfo.Units);
ylabel(completeSignal.tsc.Vin.DataInfo.Units);
legend('vin','vout');

subplot(nPlots,1,2);
plot(sampled.tsc.Vin);
hold on;
plot(sampled.tsc.Vout);
title(['Option 1+3 at ', num2str(sampled.fsignal), ' Hz (samples only)']);
xlabel(sampled.tsc.Vin.TimeInfo.Units);
ylabel(sampled.tsc.Vin.DataInfo.Units);
legend('vin','vout');

subplot(nPlots,1,3);
plot(theoretical.tsc.Vin);
hold on;
plot(theoretical.tsc.Vout);
title(['Theoretical response at ', num2str(theoretical.fsignal), ' Hz']);
xlabel(theoretical.tsc.Vin.TimeInfo.Units);
ylabel(theoretical.tsc.Vin.DataInfo.Units);
legend('vin','vout');