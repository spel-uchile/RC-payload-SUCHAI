clear all;
close all;
%% Load variables
load('2016_17_05_ExpFisTimeSeries.mat')

names = fieldnames(ExpFisTimeSeries);
TSeries = ExpFisTimeSeries.(names{10});
dataTSC = TSeries.tscData;
simTSC = TSeries.tscSimulation;

currentFreq = TSeries.freqSignalHz;
vin = dataTSC.vin;
vout = dataTSC.vout;
power = dataTSC.power;

simVin = simTSC.simVin;
simVout = simTSC.simVout;
simPower = simTSC.simPower;

%% Testing different span values for smooth the cummean
ref = 0;
spanVin = zeros(1,1);
spanVout = zeros(size(spanVin));
avgVin = cummean(simVin.Data,1)';
avgVout = cummean(simVout.Data,1)';

nlegends = length(spanVin) + length(spanVout) + 3;
Legend = cell(nlegends,1);

figure;
haxes = axes;
hold on;
% ylim([-.1 .1]);
% xlim([0 4000]);
rLine = refline([0 ref]);
rLine.Color = 'k';
plot(haxes, avgVin);
plot(haxes, avgVout);
iter = 1;
Legend{iter}=strcat('ref','');
iter = iter + 1;
Legend{iter}=strcat('avgVin','');
iter = iter + 1;
Legend{iter}=strcat('avgVout','');

winVin = 2e-3;
for i = 1 : length(spanVin)
    spanVin(i) = winVin;
    avgVinSmoothed = smooth(avgVin, spanVin(i));
    plot(haxes, avgVinSmoothed);
    iter = iter + 1;
    Legend{iter}=strcat('vin span = ',num2str(spanVin(i)));
    winVin = 2*winVin;
end

winVout = 2e-3;
for i = 1 : length(spanVout)
    spanVout(i) = winVout;
    avgVoutSmoothed = smooth(avgVout, spanVout(i));
    plot(haxes, avgVoutSmoothed);
    iter = iter + 1;
    Legend{iter}=strcat('vout span = ',num2str(spanVout(i)));
    winVout = 2 * winVout;
end
legend(Legend);

%% No buffering
tolerance = 1e-3;
span = 2e-3;
originalData = simVout.Data;
[simVoutIndex, cummeanSimVout, points] = findSState('simple', originalData, tolerance, span);
[~, simVoutFiltered] = reconstructBufferedSignal(originalData, simVoutIndex, length(originalData));

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1);
hold on;
plot(cummeanSimVout, 'b');
LegendFilterPlots = [];
LegendFilterPlots = [LegendFilterPlots; 'cummean'];
title('Reference signal used to detect steady state (no buffering)');
theLegend = cellstr(LegendFilterPlots);
legend(theLegend);
ylim([-1 1]);

subplot(2,1,2);
hold on;
plot(simVoutFiltered, 'g');
LegendFilterPlots = [];
LegendFilterPlots = [LegendFilterPlots; 'vout'];
title(strcat('Output voltage in steady state (no buffering, useful = ',...
    num2str((1-points/length(originalData))*100),' %)'));
theLegend = cellstr(LegendFilterPlots);
legend(theLegend);
ylim([-1 1]);

%% With buffering
tolerance = 1e-3;
buffLen = 200;
[simVoutBufferedIndexes, bufferedCummeanSignal, points] = findSState('buffered', simVout.Data, tolerance, span , buffLen);
[joinedSlices, filteredSignal] = reconstructBufferedSignal(simVout.Data, simVoutBufferedIndexes, buffLen);

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1);
hold on;
plot(bufferedCummeanSignal, 'm');
LegendFilterPlots = [];
LegendFilterPlots = [LegendFilterPlots; 'buffered cummean'];
title('Reference signal used to detect steady state (with buffering)');
theLegend = cellstr(LegendFilterPlots);
legend(theLegend);
ylim([-1 1]);

subplot(2,1,2);
hold on;
plot(filteredSignal,'b');
LegendFilterPlots = [];
LegendFilterPlots = [LegendFilterPlots; 'buffered vout '];
title(strcat('Output voltage in steady state (with buffering, useful = ',...
    num2str((1-points/length(originalData))*100),' %)'));
theLegend = cellstr(LegendFilterPlots);
legend(theLegend);
ylim([-1 1]);

% Buffering + join the slices
figure('units','normalized','outerposition',[0 0 1 1]);
hold on;
plot(joinedSlices);
LegendFilterPlots = [];
LegendFilterPlots = [LegendFilterPlots; 'useful simVout'];
theLegend = cellstr(LegendFilterPlots);
legend(theLegend);
title(strcat('Output voltage in steady state (with buffering, useful = ',...
    num2str((1-points/length(originalData))*100),' %)'));
ylim([-1 1]);

% no es lo mismo hacer smooth(algo) que computar la cummean entre
% ventanas pequeñas (resetear cada ciertos N puntos)

% La idea es tener un modelo lineal que indique desde que punto en la 
% serie de tiempo se pueden eliminar los datos. (Caso simulacion).

% Luego extender la idea entendiendo que se tienen ventanas de 200 datos de
% largos(dadas por el largo del buffer intermedio).

% preguntar sobre la implementacion del "filtrado" de datos
%   es razonable el uso de la media acumulada ?
%   por que no camvbia mucho entre frecuencias ?
%   Quiza sea mas util considerar una media entre +-10 puntos contiguos en
%   vez de la media acumyulada?