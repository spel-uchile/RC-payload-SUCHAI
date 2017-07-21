clear all;
close all;
prefix = '2016_14_01_';
matFileName = strcat(prefix, 'ExpFisTimeSeries.mat');

if ~exist(matFileName,'file')
    matFileName = payloadTimeSeriesBuilder(prefix);
end

load(matFileName);

fcircuitHz = 92;
names = fieldnames ( ExpFisTimeSeries );
for i = 1 : length( fieldnames ( ExpFisTimeSeries ) ) -1    
    
    PayloadTSeries = ExpFisTimeSeries.(names{i});
    
    tsc = PayloadTSeries.tscData;
    vin = tsc.vin; 
    vout = tsc.vout;
    power = tsc.power;
    fsignal = PayloadTSeries.freqSignalHz;
    fsHz = PayloadTSeries.fsHz;

    L = tsc.Length;
    
    Yin = fft( vin.Data );
    Yout = fft( vout.Data );
    
    spectrumDoubleIn = abs( Yin / L );
    spectrumDoubleOut = abs( Yin / L );
    spectrumSingleIn = spectrumDoubleIn( 1 : L / 2 + 1);
    spectrumSingleIn( 2 : end - 1 ) = 2 * spectrumSingleIn( 2 : end - 1 );
    spectrumSingleOut = spectrumDoubleOut( 1 : L / 2 + 1);
    spectrumSingleOut( 2 : end - 1 ) = 2 * spectrumSingleOut( 2 : end - 1 );
    
    f = fsHz * ( 0 : ( L / 2 ) ) / L;
    
    figure;
    ylimit = get(gca,'ylim');
    hold on;
    
    subplot( 2, 1, 1);
    plot(f, spectrumSingleIn );
    hold on;
    plot( [fcircuitHz fcircuitHz] , ylim );
    title(strcat('ExpFis Vin Spectrum , Fsignal = ', num2str(fsignal),...
        ' [Hz] Fcircuit = ', num2str( fcircuitHz ), ' [Hz]'));
    xlabel('f (Hz)');
    ylabel('|A(f)|');
    xlim([0 150]);
    
    subplot( 2, 1, 2);
    hold on;
    plot(f, spectrumSingleOut);
    plot( [fcircuitHz fcircuitHz] , ylim );
    title(strcat('ExpFis Vout Spectrum , Fsampling = ', num2str(fsHz), ...
        ' [Hz]  Fcircuit = ', num2str( fcircuitHz ), ' [Hz]'));
    xlabel('f (kHz)');
    ylabel('|A(f)|');
    xlim([0 150]);

end