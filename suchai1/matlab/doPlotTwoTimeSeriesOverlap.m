pathMatfile ={'./mat/ts/suchai/125.429/20180123_013627_raw_125.429Hz.mat',...
    './mat/ts/suchai/125.429/20180124_132449_raw_125.429Hz.mat'};

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

endd = min(length(dataA),length(dataB));
dataA = dataA(1:endd);
dataB = dataB(1:endd);

figure('units','normalized','outerposition',[0 0 1 1]);
hA = plot(dataA);
hold on;
grid on;
hB = plot(dataB);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title('Telemetrias a 125Hz sobre la SAA');
xlabel('Numero de muestra');
ylabel('V');
legA = nicknameA;
legB = nicknameB;
hleg = legend({legA, legB});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
set(hleg, 'Interpreter', 'none');