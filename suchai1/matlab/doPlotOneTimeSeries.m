clear all;
close all;
pathMatfile = './mat/ts/suchai/15.5109/20170918_024708_raw_15.5109Hz.mat';

pathMatfile = fullfile(pathMatfile);
[directoryOfFile, nameOfFile, extension] = fileparts(pathMatfile);
saveFolderFig =['./img/timeseries/',nameOfFile];
figSaveName = [saveFolderFig,'/',date,'_ts_voltages.png'];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
S = load(pathMatfile);
Sfnames = fieldnames(S);
name = Sfnames{1};
tsStruct = S.(name);

figure('units','normalized','outerposition',[0 0 1 1]);
stairs(tsStruct.tsc.Time, tsStruct.tsc.Vin.Data);
hold on;
stairs(tsStruct.tsc.Time, tsStruct.tsc.Vout.Data);
grid on;
ylim([-0.9 0.9]);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title([tsStruct.Name,' Voltage time series']);
xlabel(tsStruct.tsc.TimeInfo.Units);
ylabel(tsStruct.tsc.Vin.DataInfo.Units);
legVin =strcat('vin ','',num2str(tsStruct.fsignal),' Hz');
legVout =strcat('vout ','',num2str(tsStruct.fsignal),' Hz');
hleg = legend({legVin, legVout});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
saveas(gcf,figSaveName);

figSaveName = [saveFolderFig,'/',date,'_ts_power.png'];
figure('units','normalized','outerposition',[0 0 1 1]);
stairs(tsStruct.tsc.Time, tsStruct.tsc.injectedPower.Data);
hold on;
filterSize = 4*10;
smoothPower = smooth(tsStruct.tsc.Time, tsStruct.tsc.injectedPower.Data,...
    filterSize);
plot(tsStruct.tsc.Time, smoothPower);
grid on;
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title([tsStruct.Name,' Injected Power time series']);
xlabel(tsStruct.tsc.TimeInfo.Units);
ylabel(tsStruct.tsc.Vin.DataInfo.Units);
legPower =strcat('power ','',num2str(tsStruct.fsignal),' Hz');
legSmooth =strcat('filter','',num2str(filterSize),' points');
hleg = legend({legPower, legSmooth});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
saveas(gcf,figSaveName);