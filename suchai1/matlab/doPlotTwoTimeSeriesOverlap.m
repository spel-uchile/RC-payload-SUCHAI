
% pathMatfile ={'./mat/ts/lab/8593.9758/20161805_raw_8593.9758Hz.mat',...
%     './mat/ts/suchai/8593.9758/20171012_133800_raw_8593.9758Hz.mat'};%1
% pathMatfile ={'./mat/ts/lab/356.5754/20161805_raw_356.5754Hz.mat',...
%     './mat/ts/suchai/356.5754/20170830_022511_raw_356.5754Hz.mat'};%2
% pathMatfile ={'./mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat',...
%     './mat/ts/suchai/14628.6768/20180110_131222_raw_14628.6768Hz.mat'};%marcos1
% pathMatfile ={'./mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat',...
%     './mat/ts/suchai/14628.6768/20180111_125344_raw_14628.6768Hz.mat'};%marcos2
% pathMatfile ={'./mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat',...
%     './mat/ts/suchai/14628.6768/20180112_140716_raw_14628.6768Hz.mat'};%marcos3
% pathMatfile ={'./mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat',...
%     './mat/ts/suchai/14628.6768/20180112_123525_raw_14628.6768Hz.mat'};%marcos4
% pathMatfile ={'./mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat',...
%     './mat/ts/suchai/14628.6768/20180113_031449_raw_14628.6768Hz.mat'};%marcos5
% pathMatfile ={'./mat/ts/suchai/14628.6768/20180111_125344_raw_14628.6768Hz.mat',...
%     './mat/ts/suchai/14628.6768/20180110_131222_raw_14628.6768Hz.mat',...
%     './mat/ts/suchai/14628.6768/20180112_123525_raw_14628.6768Hz.mat',...
%     './mat/ts/suchai/14628.6768/20180113_031449_raw_14628.6768Hz.mat',...
%     './mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat'};
%
% pathMatfile ={'./mat/ts/lab/125.429/20161805_raw_125.429Hz.mat',...
%     './mat/ts/lab/125.429/20180115_000004_raw_125.429Hz.mat',...
%     './mat/ts/suchai/125.429/20170905_020600_raw_125.429Hz.mat'}; %125HZ

% pathMatfile ={'./mat/ts/lab/125.429/20161805_raw_125.429Hz.mat',...
%     './mat/ts/suchai/125.429/20180115_023601_raw_125.429Hz.mat',...
%     './mat/ts/suchai/125.429/20180114_132913_raw_125.429Hz.mat',...
%     './mat/ts/suchai/125.429/20170905_020600_raw_125.429Hz.mat'};

% pathMatfile ={'./mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat',...%labv vieja
%     './mat/ts/lab/14628.6768/20180115_000001_raw_14628.6768Hz.mat',...%lab nueva
%     './mat/ts/suchai/14628.6768/20180110_131222_raw_14628.6768Hz.mat'};% 14628Hz primera anomalia

pathMatfile ={'./mat/ts/lab/125.429/20161805_raw_125.429Hz.mat',...%lab
    './mat/ts/suchai/14628.6768/20180117_123317_raw_14628.6768Hz.mat'};% 125Hz ejecutada el martes descargada el miecoles

pathMatfile = fullfile(pathMatfile);
pathMatfileA = pathMatfile{1};
pathMatfileB = pathMatfile{2};
% pathMatfileC = pathMatfile{3};
% pathMatfileD = pathMatfile{4};
% pathMatfileE = pathMatfile{5};
idx = strfind(pathMatfileA,'/');
idx = idx(end);
nicknameA = pathMatfileA(idx+1:end);
idx = strfind(pathMatfileB,'/');
idx = idx(end);
nicknameB = pathMatfileB(idx+1:end);
% idx = strfind(pathMatfileC,'/');
% idx = idx(end);
% nicknameC = pathMatfileC(idx+1:end);
% idx = strfind(pathMatfileD,'/');
% idx = idx(end);
% nicknameD = pathMatfileD(idx+1:end);
% idx = strfind(pathMatfileD,'/');
% idx = idx(end);
% nicknameE = 'lab';

SA = load(pathMatfileA);
Sfnames = fieldnames(SA);
name = Sfnames{1};
tsStructA = SA.(name);
tdataA= tsStructA.tsc.Time;
dataA = tsStructA.tsc.Vout.Data;
dataAA = tsStructA.tsc.Vin.Data;

SB = load(pathMatfileB);
Sfnames = fieldnames(SB);
name = Sfnames{1};
tsStructB = SB.(name);
tdataB= tsStructB.tsc.Time;
dataB = tsStructB.tsc.Vout.Data;
dataBB = tsStructB.tsc.Vin.Data;

% SC = load(pathMatfileC);
% Sfnames = fieldnames(SC);
% name = Sfnames{1};
% tsStructC = SC.(name);
% tdataC= tsStructC.tsc.Time;
% dataC = tsStructC.tsc.Vout.Data;
% dataCC = tsStructC.tsc.Vin.Data;
% 
% SD = load(pathMatfileD);
% Sfnames = fieldnames(SD);
% name = Sfnames{1};
% tsStructD = SD.(name);
% tdataD= tsStructD.tsc.Time;
% dataD = tsStructD.tsc.Vout.Data;
% 
% SE = load(pathMatfileE);
% Sfnames = fieldnames(SE);
% name = Sfnames{1};
% tsStructE = SE.(name);
% tdataE= tsStructE.tsc.Time;
% dataE = tsStructE.tsc.Vout.Data;

% % set margins
% iniiA = 1;
% iniiB = 1;
% iniiC = 1;
% iniiD = 1;
% tdataA= tdataA(iniiA:end);
% dataA = dataA(1:4500);
% tdataB= tdataB(iniiC:end);
% dataB = dataB(iniiD:end);

figure('units','normalized','outerposition',[0 0 1 1]);
hA = plot(dataA(1:4000));
hold on;
grid on;
hB = plot(dataB);
% hC = plot(dataC);
% hD = plot(dataD,'b');
% hE = plot(dataE);
% hAA = plot(dataBB);
% hA.XData = hA.XData + 35;
hB.XData = hB.XData + 36;
% hD.XData = hD.XData +100;
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title('Telemetrias a 125Hz sobre la SAA');
xlabel('Numero de muestra');
ylabel('V');
legA = nicknameA;
legB = nicknameB;
legC = nicknameC;
% legVin = 'Vin (for all series)';
% legD = '20170905_020600 (sobre anomalía)';
% legE = nicknameE;
% hleg = legend({legA, legB});
hleg = legend({legA, legB, legC});
% hleg = legend({legA, legB, legC});
% hleg = legend({legB, legC, legD});
% hleg = legend({legA, legB, legC, legVin});
% hleg = legend({legA, legB, legC, legD, legE});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
set(hleg, 'Interpreter', 'none');