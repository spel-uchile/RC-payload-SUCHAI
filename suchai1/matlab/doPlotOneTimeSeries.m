
pathMatfile = './mat/ts/lab/2937.9922/20161805_123456_raw_2937.9922Hz.mat';

pathMatfile = fullfile(pathMatfile);
[directoryOfFile, nameOfFile, extension] = fileparts(pathMatfile);
saveFolderFig =['./img/timeseries/',nameOfFile];
figSaveName = [saveFolderFig,'/',date,'_ts.png'];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
S = load(pathMatfile1);
Sfnames = fieldnames(S);
name = Sfnames{1};
tsStruct = S.(name);
tdata= tsStruct.tsc.Time;
voutdata = tsStruct.tsc.Vout.Data;

figure('units','normalized','outerposition',[0 0 1 1]);
inii = 1;
endd = length(tsStruct.tsc.Time);
tdata= tdata(inii:endd);
voutdata = voutdata(inii:endd);
plot(tdata, voutdata);
hold on;
grid on;
ylim([-0.9 0.9]);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title([tsStruct.Name,' Voltage time series']);
xlabel(tsStruct.tsc.TimeInfo.Units);
ylabel(tsStruct.tsc.Vin.DataInfo.Units);
legVoutData = tsStruct.dateOfCreation;
hleg = legend({legVoutData});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
saveas(gcf,figSaveName);
