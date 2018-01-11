pathMatfile ={'./mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat',...
    './mat/ts/suchai/14628.6768/20180111_125344_raw_14628.6768Hz.mat'};



pathMatfile = fullfile(pathMatfile);
pathMatfileA = pathMatfile{1};
pathMatfileB = pathMatfile{2};
idx = strfind(pathMatfileA,'/');
idx = idx(end);
nicknameA = pathMatfileA(idx+1:end);
idx = strfind(pathMatfileB,'/');
idx = idx(end);
nicknameB = pathMatfileB(idx+1:end);

SA = load(pathMatfileA);
Sfnames = fieldnames(SA);
name = Sfnames{1};
tsStructA = SA.(name);
tdataA= tsStructA.tsc.Time;
dataA = tsStructA.tsc.Vout.Data;

SB = load(pathMatfileB);
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
htit = title([tsStructA.Name,' vs ',tsStructB.Name]);
xlabel(tsStructA.tsc.TimeInfo.Units);
ylabel(tsStructA.tsc.Vin.DataInfo.Units);
legA = nicknameA;
legB = nicknameB;
hleg = legend({legA, legB});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
set(hleg, 'Interpreter', 'none');