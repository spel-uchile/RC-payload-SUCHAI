clear all;
close all;

tseriesFolder = './mat/ts/test';
files = dir(tseriesFolder);
files = files(arrayfun(@(x) ~strcmp(x.name(1),'.'), files));
files = {files.name};
% files = files(3:end);
files = sortn(files);
filePath = strcat(tseriesFolder, '/', files);
files = lower(files);
saveFolder = './mat/pdf/test';

freqCircuitHz = 92;
R = 1210;
C = 1 / (freqCircuitHz * 2 * pi * R);
dampingRate = 1/ (R*C);
npoints = 200;

for i = 1 : numel(files)
    S = load(filePath{i});
    name = fieldnames(S);
    name = name{1};
    ts = S.(name);
    [pdfResult.(name), xbins.(name), Parameters.(name)]= pdfEstimator(ts, [], npoints);
end

%% Plots
subplot(3,1,1);
plot(xbins.raw.Vin, pdfResult.raw.Vin);
hold on;
plot(xbins.simulation.Vin, pdfResult.simulation.Vin);
plot(xbins.theoretical.Vin, pdfResult.theoretical.Vin);
title(['Vin PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel(ts.tsc.Vin.DataInfo.Units);
legend( 'raw','simulation','theoretical');

subplot(3,1,2);
plot(xbins.raw.Vin, pdfResult.raw.Vin);
hold on;
plot(xbins.simulation.Vout, pdfResult.simulation.Vout);
plot(xbins.theoretical.Vout, pdfResult.theoretical.Vout);
title(['Vout PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel(ts.tsc.Vout.DataInfo.Units);
legend( 'raw','simulation','theoretical');

subplot(3,1,3);
plot(xbins.raw.injectedPower, pdfResult.raw.injectedPower);
hold on;
plot(xbins.simulation.injectedPower, pdfResult.simulation.injectedPower);
plot(xbins.theoretical.injectedPower, pdfResult.theoretical.injectedPower);
title(['injectedPower PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel(ts.tsc.injectedPower.DataInfo.Units);
legend( 'raw','simulation','theoretical');