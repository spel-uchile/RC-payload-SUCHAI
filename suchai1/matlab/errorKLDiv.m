prefix = '2016_18_05';
dataDirectory = [pwd, '/mat/pdf/', prefix];

freqs = dir(dataDirectory);
freqs = {freqs.name};
freqs = freqs(3:end);
freqs = sortn(freqs);
freqsFolder = strcat(dataDirectory, '/', freqs);
freqs = lower(freqs);

Ifiltered2Theoretical = zeros(1,length(freqs));
Iraw2Simulink =  zeros(1,length(freqs));
Ifiltered2Simulink =  zeros(1,length(freqs));
Iraw2Filtered =  zeros(1,length(freqs));
Iraw2Theoretical =  zeros(1,length(freqs));
Isimulink2Theoretical =  zeros(1,length(freqs));

Ofiltered2Theoretical = zeros(1,length(freqs));
Oraw2Simulink =  zeros(1,length(freqs));
Ofiltered2Simulink =  zeros(1,length(freqs));
Oraw2Filtered =  zeros(1,length(freqs));
Oraw2Theoretical =  zeros(1,length(freqs));
Osimulink2Theoretical =  zeros(1,length(freqs));

Pfiltered2Theoretical = zeros(1,length(freqs));
Praw2Simulink =  zeros(1,length(freqs));
Pfiltered2Simulink =  zeros(1,length(freqs));
Praw2Filtered =  zeros(1,length(freqs));
Praw2Theoretical =  zeros(1,length(freqs));
Psimulink2Theoretical =  zeros(1,length(freqs));

for i = 1 : length(freqs)
    saveFolder = ['./mat/kldiv/',prefix];
    currFreqFolder = freqsFolder{i};
    matfiles = dir(currFreqFolder);
    matfiles = {matfiles.name};
    matfiles = matfiles(3:end);
    matfiles = sortn(matfiles);
    
    file = [currFreqFolder,'/', matfiles{1}];
    S = load(file);
    name = fieldnames(S);
    pdfs = S.pdfResult;
    parameters = S.Parameters;
    xbins = S.xbins;
    
    fsignal =parameters.raw.fsignal;
    rawPDF = pdfs.raw;
    filteredPDF = pdfs.filtered;
    simulationPDF = pdfs.simulation;
    theoreticalPDF = pdfs.theoretical;
    
    %% compute KLDiv
    Ifiltered2Theoretical(i) = kldiv(xbins.raw.Vin, pdfs.filtered.Vin, pdfs.theoretical.Vin, 'sym');
    Iraw2Simulink(i) = kldiv(xbins.raw.Vin, pdfs.raw.Vin, pdfs.simulation.Vin, 'sym');
    Ifiltered2Simulink(i) = kldiv(xbins.raw.Vin, pdfs.filtered.Vin, pdfs.simulation.Vin, 'sym');
    Iraw2Filtered(i) = kldiv(xbins.raw.Vin, pdfs.raw.Vin,pdfs.filtered.Vin, 'sym');
    Iraw2Theoretical(i) = kldiv(xbins.raw.Vin, pdfs.raw.Vin, pdfs.theoretical.Vin, 'sym');
    Isimulink2Theoretical(i) = kldiv(xbins.raw.Vin, pdfs.simulation.Vin, pdfs.theoretical.Vin, 'sym');
    
    Ofiltered2Theoretical(i) = kldiv(xbins.raw.Vout, pdfs.filtered.Vout, pdfs.theoretical.Vout, 'sym');
    Oraw2Simulink(i) = kldiv(xbins.raw.Vout, pdfs.raw.Vout, pdfs.simulation.Vout, 'sym');
    Ofiltered2Simulink(i) = kldiv(xbins.raw.Vout, pdfs.filtered.Vout, pdfs.simulation.Vout, 'sym');
    Oraw2Filtered(i) = kldiv(xbins.raw.Vout, pdfs.raw.Vout,pdfs.filtered.Vout, 'sym');
    Oraw2Theoretical(i) = kldiv(xbins.raw.Vout, pdfs.raw.Vout, pdfs.theoretical.Vout, 'sym');
    Osimulink2Theoretical(i) = kldiv(xbins.raw.Vout, pdfs.simulation.Vout, pdfs.theoretical.Vout, 'sym');
    
    Pfiltered2Theoretical(i) = kldiv(xbins.raw.injectedPower, pdfs.filtered.injectedPower, pdfs.theoretical.injectedPower, 'sym');
    Praw2Simulink(i) = kldiv(xbins.raw.injectedPower, pdfs.raw.injectedPower, pdfs.simulation.injectedPower, 'sym');
    Pfiltered2Simulink(i) = kldiv(xbins.raw.injectedPower, pdfs.filtered.injectedPower, pdfs.simulation.injectedPower, 'sym');
    Praw2Filtered(i) = kldiv(xbins.raw.injectedPower, pdfs.raw.injectedPower,pdfs.filtered.injectedPower, 'sym');
    Praw2Theoretical(i) = kldiv(xbins.raw.injectedPower, pdfs.raw.injectedPower, pdfs.theoretical.injectedPower, 'sym');
    Psimulink2Theoretical(i) = kldiv(xbins.raw.injectedPower, pdfs.simulation.injectedPower, pdfs.theoretical.injectedPower, 'sym');
    
end

vin.fsignal = fsignal;
vin.filtered2Theoretical = Ifiltered2Theoretical;
vin.raw2Simulink = Iraw2Simulink;
vin.filtered2Simulink = Ifiltered2Simulink;
vin.raw2Filtered = Iraw2Filtered;
vin.raw2Theoretical = Iraw2Theoretical;
vin.simulink2Theoretical = Isimulink2Theoretical;

vout.fsignal = fsignal;
vout.filtered2Theoretical = Ofiltered2Theoretical;
vout.raw2Simulink = Oraw2Simulink;
vout.filtered2Simulink = Ofiltered2Simulink;
vout.raw2Filtered = Oraw2Filtered;
vout.raw2Theoretical = Oraw2Theoretical;
vout.simulink2Theoretical = Osimulink2Theoretical;

power.fsignal = fsignal;
power.filtered2Theoretical = Pfiltered2Theoretical;
power.raw2Simulink = Praw2Simulink;
power.filtered2Simulink = Pfiltered2Simulink;
power.raw2Filtered = Praw2Filtered;
power.raw2Theoretical = Praw2Theoretical;
power.simulink2Theoretical = Psimulink2Theoretical;

KLDiv.vin = vin;
KLDiv.vout = vout;
KLDiv.power = power;

saveFileName = strcat(saveFolder,'/', date, '_kldiv.mat');
save(saveFileName, 'KLDiv','-v7.3');