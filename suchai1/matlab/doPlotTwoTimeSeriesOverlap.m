pathMatfile ={'./mat/ts/lab/2937.9922/20161805_123456_raw_2937.9922Hz.mat',
    './mat/ts/suchai/8593.9758/20171014_022659_raw_8593.9758Hz.mat'};

pathMatfile = fullfile(pathMatfile);
SA = load(pathMatfile{1});
Sfnames = fieldnames(SA);
name = Sfnames{1};
tsStructA = SA.(name);
tdataA= tsStructA.tsc.Time;
dataA = tsStructA.tsc.Vout.Data;

SB = load(pathMatfile{2});
Sfnames = fieldnames(SB);
name = Sfnames{1};
tsStructB = SB.(name);
tdataB= tsStructB.tsc.Time;
dataB = tsStructB.tsc.Vout.Data;

% set margins
inii = 1;
endd = min(length(tdataA), length(tdataB));
tdataA= tdataA(inii:endd);
dataA = dataA(inii:endd);
tdataB= tdataB(inii:endd);
dataB = dataB(inii:endd);

figure('units','normalized','outerposition',[0 0 1 1]);
plot(tdataA, dataA);
hold on;
grid on;
plot(tdataB, dataB);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title([tsStructA.Name,' and',tsStructB.Name]);
xlabel(tsStructA.tsc.TimeInfo.Units);
ylabel(tsStructA.tsc.Vin.DataInfo.Units);
legA = tsStructA.dateOfCreation;
legB = tsStructB.dateOfCreation;
hleg = legend({legA, legB});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');