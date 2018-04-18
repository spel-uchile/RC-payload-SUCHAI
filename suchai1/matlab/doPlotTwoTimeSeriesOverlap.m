pathMatfile ={'./mat/ts-raw/suchai/125.429/20170905_020600_raw_125.429Hz.mat',...
    './mat/ts-raw/suchai/125.429/20180124_132449_raw_125.429Hz.mat'};

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

% endd = min(length(dataA),length(dataB));
dataA = dataA(1:end);
dataB = dataB(1:end);

figure('units','normalized','outerposition',[0 0 1 1]);
dataC = tsStructB.tsc.Vin.Data;
hc = plot(dataC);
hold on;
hA = plot(dataA);
hold on;
grid on;
hB = plot(dataB);

set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title(['Trazas de Vin y Vout del circuito a ', ...
    num2str(tsStructA.fsignal), ' Hz']);
xlabel('Numero de muestra');
ylabel('V');
legA = ['suchai ',  nicknameA];
legB = ['suchai ',nicknameB];
legC = 'Vin (identico para ambos)';
hleg = legend({ legC, legA, legB});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
set(hleg, 'Interpreter', 'none');

figure('units','normalized','outerposition',[0 0 1 1]);
dataAA = tsStructA.tsc.langevinInjected.Data;
hA = plot(dataAA);
hold on;
grid on;
dataBB = tsStructB.tsc.langevinInjected.Data;
hB = plot(dataBB);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title(['Traza calculada de potencia inyectada I(t) a ',...
    num2str(tsStructA.fsignal), ' Hz']);
xlabel('Numero de muestra');
ylabel('V^2 \cdot Hz');
legA = ['suchai ',  nicknameA];
legB = ['suchai ',nicknameB];
hleg = legend({legA, legB});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
set(hleg, 'Interpreter', 'none');