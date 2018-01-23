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
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

freqCircuitHz = 92;
R = 1210;
C = 1 / (freqCircuitHz * 2 * pi * R);
dampingRate = 1/ (R*C);
npoints = 200;
kernel = 'normal';

for i = 1 : numel(files)
    S = load(filePath{i});
    name = fieldnames(S);
    name = name{1};
    ts = S.(name);
    [pdfResult.(name), xbins.(name), bandWidth.(name), Parameters.(name)]= pdfEstimator(ts, npoints, kernel, []);
end

%% Plots
subplot(3,1,1);
plot(xbins.raw.Vin, log10(pdfResult.raw.Vin));
hold on;
plot(xbins.simulation.Vin,log10( pdfResult.simulation.Vin));
plot(xbins.theoretical.Vin, log10(pdfResult.theoretical.Vin));
title(['Vin PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel(ts.tsc.Vin.DataInfo.Units);
legend( 'raw','simulation','theoretical');
xlim([-1.2 1.2]);
ylim([-3 1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');

subplot(3,1,2);
plot(xbins.raw.Vout, log10(pdfResult.raw.Vout));
hold on;
plot(xbins.simulation.Vout, log10(pdfResult.simulation.Vout));
plot(xbins.theoretical.Vout, log10(pdfResult.theoretical.Vout));
title(['Vout PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel(ts.tsc.Vout.DataInfo.Units);
legend( 'raw','simulation','theoretical');
xlim([-1.2 1.2]);
ylim([-3 1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');

subplot(3,1,3);
plot(xbins.raw.LangInj, log10(pdfResult.raw.LangInj));
hold on;
plot(xbins.simulation.LangInj, log10(pdfResult.simulation.LangInj));
plot(xbins.theoretical.LangInj, log10(pdfResult.theoretical.LangInj));
title(['injectedPower PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel(ts.tsc.langevinInjected.DataInfo.Units);
legend( 'raw','simulation','theoretical');
xlim([-1.2 1.2]);
ylim([-3 1]);
xlim([-350 550]);
ylim([-4 -1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');