clear all;
close all;
plotFolder = strcat('./img/kldivFinal/');

prefixMenos = '2016_17_05_';
loadname = strcat(prefixMenos,'Errors_KLDiv.mat');
load(loadname);
KLDivMenos = KLDiv;

prefixMas = '2016_18_05_';
loadname = strcat(prefixMas,'Errors_KLDiv.mat');
load(loadname);
KLDivMas = KLDiv;
fcircuitHz = 92;
fmas = KLDivMas.vin.freq;
fmenos = KLDivMenos.vin.freq;

yMax = 1e2;
yMin = 1e-5;

figure('units','normalized','outerposition',[0 0 1 1]);
% h1 = subplot(2,2,1);
loglog(fmenos, KLDivMenos.vout.filtered2Theoretical,'--o', fmas, KLDivMas.vout.filtered2Theoretical,'-.');
ylim([yMin yMax]);
grid on;
h1 = gca;
line([fcircuitHz fcircuitHz],get(h1,'YLim'),'Color',[.9 .72 0]);
xlabel('Hz');
ylabel('bits');
% title({'KLDiv between theoretical Response',' & filtered Experimental Output Voltage'});
title({'KLDiv between theoretical Response & filtered Experimental Data'});
legend('N = 1.000', 'N = 10.000' , 'fcutoff');
saveas(gcf,strcat(plotFolder,'KLDiv_vout_filtered2Theoretical','.png'));

figure('units','normalized','outerposition',[0 0 1 1]);
% h2 = subplot(2,2,2);
loglog(fmenos, KLDivMenos.vout.raw2Theoretical,'--o', fmas, KLDivMas.vout.raw2Theoretical,'-.');
ylim([yMin yMax]);
grid on;
h2 = gca;
line([fcircuitHz fcircuitHz],get(h2,'YLim'),'Color',[.9 .72 0]);
xlabel('Hz');
ylabel('bits');
% title({'KLDiv between theoretical Response',' & unfiltered Experimental Output Voltage'});
title({'KLDiv between theoretical Response & unfiltered Experimental Data'});
legend('N = 1.000', 'N = 10.000' , 'fcutoff');
saveas(gcf,strcat(plotFolder,'KLDiv_vout_raw2Theoretical','.png'));

figure('units','normalized','outerposition',[0 0 1 1]);
% h3 = subplot(2,2,3);
loglog(fmenos, KLDivMenos.vout.filtered2Simulink,'--o', fmas, KLDivMas.vout.filtered2Simulink,'-.');
ylim([yMin yMax]);
grid on;
h3 = gca;
line([fcircuitHz fcircuitHz],get(h3,'YLim'),'Color',[.9 .72 0]);
xlabel('Hz');
ylabel('bits');
% title({'KLDiv between Simulink',' & filtered Experimental Output Voltage'});
title({'KLDiv between Simulink & filtered Experimental Data'});
legend('N = 1.000', 'N = 10.000' , 'fcutoff');
saveas(gcf,strcat(plotFolder,'KLDiv_vout_filtered2Simulink','.png'));

figure('units','normalized','outerposition',[0 0 1 1]);
% h4 = subplot(2,2,4);
loglog(fmenos, KLDivMenos.vout.raw2Filtered, '--o',fmas, KLDivMas.vout.raw2Filtered,'-.');
ylim([yMin yMax]);
grid on;
h4 =  gca;
line([fcircuitHz fcircuitHz],get(h4,'YLim'),'Color',[.9 .72 0]);
xlabel('Hz');
ylabel('bits');
% title({'KLDiv between filtered',' & unfiltered Experimental Output Voltage'});
title({'KLDiv between filtered & unfiltered Experimental Data'});
legend('N = 1.000', 'N = 10.000' , 'fcutoff');
saveas(gcf,strcat(plotFolder,'KLDiv_vout_raw2Filtered','.png'));
% saveas(gcf,strcat(plotFolder,'KLDiv_vout_allInOne','.png'));