S21 = load('/home/jose/Documents/UNIVERSIDAD/SUCHAI/Proyectos GitHub/RC-payload-SUCHAI/suchai1/matlab/mat/pdf/2017_08_24/2937.9922/pdfEstimator_2937.9922Hz.mat'); %carpeta de lab
S61 = load('/home/jose/Documents/UNIVERSIDAD/SUCHAI/Proyectos GitHub/RC-payload-SUCHAI/suchai1/matlab/mat/pdf/2017_08_29/1020.0011/pdfEstimator_1020.0011Hz.mat'); %carpeta de lab
prefix = '20170824-vs-20170829';

%% Plots
figure('units','normalized','outerposition',[0 0 1 1]);
nPlots = 3;

xbins21 = S21.xbins;
xbins61 = S61.xbins;
pdfResult21 = S21.pdfResult;
pdfResult61 = S61.pdfResult;
Parameters = S21.Parameters;

subplot(nPlots,1,1);
plot(xbins21.raw.Vin, log10(pdfResult21.raw.Vin));
hold on;
plot(xbins61.raw.Vin, log10(pdfResult61.raw.Vin));
hold off;
grid on;
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['Vin PDFs']);
xlabel('V');
legend('32.21 \cdot f_{RC}','11.18 \cdot f_{RC}');

subplot(nPlots,1,2);
plot(xbins21.raw.Vout, log10(pdfResult21.raw.Vout));
hold on;
plot(xbins61.raw.Vout, log10(pdfResult61.raw.Vout));
hold off;
grid on;
ylim([-5 1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['Vout PDFs']);
xlabel('V');
legend('32.21 \cdot f_{RC}','11.18 \cdot f_{RC}');

subplot(nPlots,1,3);
plot(xbins21.raw.injectedPower, log10(pdfResult21.raw.injectedPower));
hold on;
plot(xbins61.raw.injectedPower, log10(pdfResult61.raw.injectedPower));
hold off;
grid on;
ylim([-4 -1]);
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');
title(['injected Power PDFs']);
xlabel('V^2 \cdot Hz');
legend('32.21 \cdot f_{RC}','11.18 \cdot f_{RC}');

saveas(gcf,['./img/suchai-vs-lab/','telemetries_so_far_',prefix,'.png']);
saveas(gcf,['./img/suchai-vs-lab/','telemetries_so_far_',prefix,'.eps'],'epsc');