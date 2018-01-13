clear all;
close all;
pathMatfile = './mat/pdf/suchai/14628.6768/20180111_125344_pdfEstimator_14628.6768Hz.mat';

pathMatfile = fullfile(pathMatfile);
[directoryOfFile, nameOfFile, extension] = fileparts(pathMatfile);
S = load(pathMatfile);
Sfnames = fieldnames(S);
name = Sfnames{1};
pdfStruct = S.pdfResult;
xbins = S.xbins;

figure('units','normalized','outerposition',[0 0 1 1]);
plot(xbins.raw.LangInj, log10(pdfStruct.raw.LangInj),'*');
grid on;
ylim([-4 -1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
htit = title('PDF injected Power');
xlabel('V^2 \cdot Hz');
set(htit, 'Interpreter', 'none');

