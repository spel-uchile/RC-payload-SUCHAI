
pathMatfile1 = './mat/ts/lab/2937.9922/20161805_123456_raw_2937.9922Hz.mat';
pathMatfile2 = './mat/ts/suchai/2937.9922/20170927_133958_raw_2937.9922Hz.mat';

pathMatfile = fullfile(pathMatfile);
[directoryOfFile, nameOfFile, extension] = fileparts(pathMatfile);
saveFolderFig =['./img/timeseries/',nameOfFile];
figSaveName = [saveFolderFig,'/',date,'_ts_voltages.png'];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
S1 = load(pathMatfile1);
Sfnames1 = fieldnames(S1);
name1 = Sfnames{1};
tsStruct1 = S.(name1);
tlab= tsStruct1.tsc.Time;
voutlab = tsStruct1.tsc.Vout.Data;


S2 = load(pathMatfile2);
Sfnames2 = fieldnames(S2);
name2 = Sfnames{1};
tsStruct2 = S.(name2);

figure('units','normalized','outerposition',[0 0 1 1]);
% stairs(tsStruct1.tsc.Time, tsStruct1.tsc.Vin.Data);
% hold on;
len = length(tsStruct2.tsc.Time);
tlab= tlab(1:len);
voutlab = voutlab(1:len);
plot(tlab, voutlab);
hold on;
plot(tsStruct2.tsc.Time, tsStruct2.tsc.Vout.Data);
grid on;
ylim([-0.9 0.9]);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title([tsStruct1.Name,' Voltage time series']);
xlabel(tsStruct1.tsc.TimeInfo.Units);
ylabel(tsStruct1.tsc.Vin.DataInfo.Units);
legVin =strcat('lab ','',num2str(tsStruct1.fsignal),' Hz');
legVout =strcat('suchai ','',num2str(tsStruct1.fsignal),' Hz');
hleg = legend({legVin, legVout});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
saveas(gcf,figSaveName);

% figSaveName = [saveFolderFig,'/',date,'_ts_power.png'];
% figure('units','normalized','outerposition',[0 0 1 1]);
% stairs(tsStruct.tsc.Time, tsStruct.tsc.injectedPower.Data);
% hold on;
% filterSize = 4*10;
% smoothPower = smooth(tsStruct.tsc.Time, tsStruct.tsc.injectedPower.Data,...
%     filterSize);
% plot(tsStruct.tsc.Time, smoothPower);
% grid on;
% set(gca, 'YMinorTick','on', 'YMinorGrid','on');
% htit = title([tsStruct.Name,' Injected Power time series']);
% xlabel(tsStruct.tsc.TimeInfo.Units);
% ylabel(tsStruct.tsc.Vin.DataInfo.Units);
% legPower =strcat('power ','',num2str(tsStruct.fsignal),' Hz');
% legSmooth =strcat('filter','',num2str(filterSize),' points');
% hleg = legend({legPower, legSmooth});
% set(htit, 'Interpreter', 'none');
% set(hleg, 'Location','southoutside');
% set(hleg,'Orientation','vertical');
% saveas(gcf,figSaveName);