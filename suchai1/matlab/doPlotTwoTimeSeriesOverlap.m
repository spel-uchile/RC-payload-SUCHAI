
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

pathMatfile ={'./mat/ts/suchai/14628.6768/20180111_125344_raw_14628.6768Hz.mat',...
    './mat/ts/suchai/14628.6768/20180110_131222_raw_14628.6768Hz.mat',...
    './mat/ts/suchai/14628.6768/20180112_123525_raw_14628.6768Hz.mat',...
    './mat/ts/suchai/14628.6768/20180113_031449_raw_14628.6768Hz.mat',...
    './mat/ts/lab/14628.6768/20161805_raw_14628.6768Hz.mat'};

pathMatfile = fullfile(pathMatfile);
pathMatfileA = pathMatfile{1};
pathMatfileB = pathMatfile{2};
pathMatfileC = pathMatfile{3};
pathMatfileD = pathMatfile{4};
pathMatfileE = pathMatfile{5};
idx = strfind(pathMatfileA,'/');
idx = idx(end);
nicknameA = pathMatfileA(idx+1:end);
idx = strfind(pathMatfileB,'/');
idx = idx(end);
nicknameB = pathMatfileB(idx+1:end);
idx = strfind(pathMatfileC,'/');
idx = idx(end);
nicknameC = pathMatfileC(idx+1:end);
idx = strfind(pathMatfileD,'/');
idx = idx(end);
nicknameD = pathMatfileD(idx+1:end);
idx = strfind(pathMatfileD,'/');
idx = idx(end);
nicknameE = 'lab';

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

SC = load(pathMatfileC);
Sfnames = fieldnames(SC);
name = Sfnames{1};
tsStructC = SC.(name);
tdataC= tsStructC.tsc.Time;
dataC = tsStructC.tsc.Vout.Data;

SD = load(pathMatfileD);
Sfnames = fieldnames(SD);
name = Sfnames{1};
tsStructD = SD.(name);
tdataD= tsStructD.tsc.Time;
dataD = tsStructD.tsc.Vout.Data;

SE = load(pathMatfileE);
Sfnames = fieldnames(SE);
name = Sfnames{1};
tsStructE = SE.(name);
tdataE= tsStructE.tsc.Time;
dataE = tsStructE.tsc.Vout.Data;

% % set margins
iniiA = 1;
iniiB = 1;
iniiC = 1;
iniiD = 1;
tdataA= tdataA(iniiA:end);
dataA = dataA(iniiB:end);
tdataB= tdataB(iniiC:end);
dataB = dataB(iniiD:end);

figure('units','normalized','outerposition',[0 0 1 1]);
% plot(tdataA, dataA);
% hold on;
% grid on;
% plot(tdataB, dataB);
% plot(tdataC, dataC);
% plot(tdataD, dataD);
hA = plot(dataA);
hold on;
grid on;
hB = plot(dataB);
hC = plot(dataC);
hD = plot(dataD);
hE = plot(dataE);
hA.XData = hA.XData + 35;
hC.XData = hC.XData + 468;
hD.XData = hD.XData +272+96;
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title([tsStructA.Name,' vs ',tsStructB.Name]);
xlabel(tsStructA.tsc.TimeInfo.Units);
ylabel(tsStructA.tsc.Vout.DataInfo.Units);
legA = nicknameA;
legB = nicknameB;
legC = nicknameC;
legD = nicknameD;
legE = nicknameE;
% hleg = legend({legA, legB});
hleg = legend({legA, legB, legC, legD, legE});
set(htit, 'Interpreter', 'none');
set(hleg, 'Location','southoutside');
set(hleg,'Orientation','vertical');
set(hleg, 'Interpreter', 'none');