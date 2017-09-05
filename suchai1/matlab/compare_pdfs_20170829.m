Slab = load('./mat/pdf/2016_18_05/1020.0011/pdfEstimator_1020.0011Hz.mat'); %carpeta de lab
Ssuchai = load('./mat/pdf/2017_08_29/1020.0011/pdfEstimator_1020.0011Hz.mat'); %carpeta de lab
prefix = '20170829semilogy';

%% Plots
figure('units','normalized','outerposition',[0 0 1 1]);
nPlots = 3;

xbinsLab = Slab.xbins;
xbinsSuchai = Ssuchai.xbins;
pdfResultLab = Slab.pdfResult;
pdfResultSuchai = Ssuchai.pdfResult;
Parameters = Slab.Parameters;

subplot(nPlots,1,1);
plot(xbinsLab.theoretical.Vin, log10(pdfResultLab.theoretical.Vin));
hold on;
plot(xbinsLab.raw.Vin, log10(pdfResultLab.raw.Vin));
plot(xbinsSuchai.raw.Vin, log10(pdfResultSuchai.raw.Vin));
hold off;
grid on;
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['Vin PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel('V');
legend('theoretical', 'lab','suchai');

subplot(nPlots,1,2);
plot(xbinsLab.theoretical.Vout, log10(pdfResultLab.theoretical.Vout));
hold on;
plot(xbinsLab.raw.Vout, log10(pdfResultLab.raw.Vout));
plot(xbinsSuchai.raw.Vout, log10(pdfResultSuchai.raw.Vout));
hold off;
grid on;
ylim([-5 1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['Vout PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel('V');
legend('theoretical', 'lab','suchai');

subplot(nPlots,1,3);
plot(xbinsLab.theoretical.injectedPower, log10(pdfResultLab.theoretical.injectedPower));
hold on;
plot(xbinsLab.raw.injectedPower, log10(pdfResultLab.raw.injectedPower));
plot(xbinsSuchai.raw.injectedPower, log10(pdfResultSuchai.raw.injectedPower));
hold off;
grid on;
ylim([-4 -1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['injected Power PDF at ', num2str(Parameters.raw.fsignal), ' Hz']);
xlabel('V^2 \cdot Hz');
legend('theoretical', 'lab','suchai');

saveas(gcf,['./img/suchai-vs-lab/',prefix,'_diff_pdfs_vinvout_',num2str(Parameters.raw.fsignal),'Hz.png']);
saveas(gcf,['./img/suchai-vs-lab/',prefix,'_diff_pdfs_vinvout_',num2str(Parameters.raw.fsignal),'Hz.eps'],'epsc');