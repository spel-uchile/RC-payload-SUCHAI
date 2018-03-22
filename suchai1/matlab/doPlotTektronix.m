close all;
% clear all;
filename = '20180320_000003';
pdfRootDir= './mat/pdf/tektronix/14628.6768';
tsRootDir = './mat/ts/tektronix/14628.6768';
tspathfile = [tsRootDir, '/', filename,'_tektronix_D_1.0202.mat'];
pdfpathfile = [pdfRootDir, '/', filename,'_pdfEstimator_14628.6768Hz.mat'];

%% FFT
load(tspathfile);
figure;
for names = {'Vin','Vout','Math'}
    variableName = names{1};
    X = raw.tsc.(variableName).Data;
    t =  raw.tsc.Time;
    dt = t(2)-t(1);
    Fs = 1/dt;
    L = length(X);
    Y = fft(X);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    if strfind(variableName, 'Vin')
        D = rms(P1)*1000    %m V^2_{rms} / Hz
    end
    f = Fs*(0:(L/2))/L;
    plot((f./1e6),P1) 
    hold on;
end
legend('Vin','Vout','Vin x Vout');
title(['FFT for white noise input D = ', num2str(D),' mV^2_{rms}/Hz of BW=20Mhz']);
xlabel('MHz');
xlim([0 200]);
ylabel('mV^2 / Hz');

%% TimeSeries
figure;
subplot(2,1,1);
t = raw.tsc.Time;
for names = {'Vin','Vout'}
    variableName = names{1};
    plot(t, raw.tsc.(variableName).Data);
    hold on;
end
legend('Vin','Vout');
title(['TS for white noise input D = ', num2str(D),' mV^2_{rms}/Hz of BW=20Mhz']);
xlabel('seconds');
ylabel('V');

subplot(2,1,2);
for names = {'Math'}
    variableName = names{1};
    plot(t, raw.tsc.(variableName).Data);
    hold on;
end 
legend('Vin x Vout');
title(['FFT for white noise input D = ', num2str(D),' mV^2_{rms}/Hz of BW=20Mhz']);
xlabel('seconds');
ylabel('mV^2');

%% Probabilty Density Function
load(pdfpathfile);
figure;
for names = {'Vin','Vout', 'Math'}
    variableName = names{1};
    mkrsize = 6;
    plot(xbins.raw.(variableName), log10(pdfResult.raw.(variableName)),'*','MarkerSize', mkrsize);
    hold on;
end
legend('Vin','Vout','Vin x Vout');
title(['PDF for white noise input D = ', num2str(D),' mV^2_{rms}/Hz of BW=20Mhz']);
xlabel('V');
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');


figure;
for names = {'LangInj', 'LangDiss'}
    variableName = names{1};
    mkrsize = 6;
    plot(xbins.raw.(variableName), log10(pdfResult.raw.(variableName)),'*','MarkerSize', mkrsize);
    hold on;
end
legend('LangInj', 'LangDiss');
title(['PDF for white noise input D = ', num2str(D),' mV^2_{rms}/Hz of BW=20Mhz']);
xlabel('V^2 \cdot Hz');
yt = get(gca, 'YTick');
myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
set(gca,'YTickLabel', myylabels);
set(gca, 'YMinorTick','on', 'YMinorGrid','on');