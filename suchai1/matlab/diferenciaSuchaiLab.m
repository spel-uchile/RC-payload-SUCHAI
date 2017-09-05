prefixLab = '2016_18_05';
prefixSuchai = '2017_08_24';
dataDirectoryLab = [pwd, '/mat/pdf/', prefixLab];
dataDirectorySuchai = [pwd, '/mat/pdf/', prefixSuchai];

freqs = dir(dataDirectoryLab);
freqs = {freqs.name};
freqs = freqs(3:end);
freqs = sortn(freqs);
freqsFolder = strcat(dataDirectoryLab, '/', freqs);
freqs = lower(freqs);

numeroEjecucionSuchai = 12;
% 
% Ifiltered2Theoretical = zeros(1,length(freqs));
% Iraw2Simulink =  zeros(1,length(freqs));
% Ifiltered2Simulink =  zeros(1,length(freqs));
% Iraw2Filtered =  zeros(1,length(freqs));
% Iraw2Theoretical =  zeros(1,length(freqs));
% Isimulink2Theoretical =  zeros(1,length(freqs));

OrawSuchai2Theoretical =  zeros(1,length(freqs));
OrawSuchai2rawLab =  zeros(1,length(freqs));
OrawLab2Theoretical =  zeros(1,length(freqs));

% Pfiltered2Theoretical = zeros(1,length(freqs));
% Praw2Simulink =  zeros(1,length(freqs));
% Pfiltered2Simulink =  zeros(1,length(freqs));
% Praw2Filtered =  zeros(1,length(freqs));
% Praw2Theoretical =  zeros(1,length(freqs));
% Psimulink2Theoretical =  zeros(1,length(freqs));

for i = numeroEjecucionSuchai : numeroEjecucionSuchai%1 : length(freqs)
    saveFolder = ['./mat/kldiv/',prefixSuchai];
    currFreqFolderLab = freqsFolder{i};
    currFreqFolderSuchai = [dataDirectorySuchai,'/',freqs{i}];
    
    matfilesLab = dir(currFreqFolderLab);
    matfilesLab = {matfilesLab.name};
    matfilesLab = matfilesLab(3:end);
    matfilesLab = sortn(matfilesLab);
    
        
    matfilesSuchai = dir(currFreqFolderLab);
    matfilesSuchai = {matfilesSuchai.name};
    matfilesSuchai = matfilesSuchai(3:end);
    matfilesSuchai = sortn(matfilesSuchai);
    
    fileLab = [currFreqFolderLab,'/', matfilesLab{1}];
    fileSuchai = [currFreqFolderSuchai,'/', matfilesSuchai{1}];
    SLab = load(fileLab);
    pdfsLab = SLab.pdfResult;
    parametersLab = SLab.Parameters;
    xbinsLab = SLab.xbins;
    SSuchai = load(fileSuchai);
    pdfsSuchai = SSuchai.pdfResult;
    parametersSuchai = SSuchai.Parameters;
    xbinsSuchai = SSuchai.xbins;
    
    fsignal = parametersLab.raw.fsignal;
    
    %% compute KLDiv
     
%     Ofiltered2Theoretical(i) = kldiv(xbinsLab.raw.Vout, pdfsLab.filtered.Vout, pdfsLab.theoretical.Vout, 'sym');
%     Oraw2Simulink(i) = kldiv(xbinsLab.raw.Vout, pdfsLab.raw.Vout, pdfsLab.simulation.Vout, 'sym');
%     Ofiltered2Simulink(i) = kldiv(xbinsLab.raw.Vout, pdfsLab.filtered.Vout, pdfsLab.simulation.Vout, 'sym');
%     Oraw2Filtered(i) = kldiv(xbinsLab.raw.Vout, pdfsLab.raw.Vout,pdfsLab.filtered.Vout, 'sym');
%     Oraw2Theoretical(i) = kldiv(xbinsLab.raw.Vout, pdfsLab.raw.Vout, pdfsLab.theoretical.Vout, 'sym');
%     Osimulink2Theoretical(i) = kldiv(xbinsLab.raw.Vout, pdfsLab.simulation.Vout, pdfsLab.theoretical.Vout, 'sym');
OrawSuchai2Theoretical(i) = kldiv(xbinsSuchai.raw.Vout, pdfsSuchai.raw.Vout, pdfsSuchai.theoretical.Vout, 'sym');
OrawSuchai2rawLab(i) = kldiv(xbinsSuchai.raw.Vout, pdfsSuchai.raw.Vout, pdfsLab.raw.Vout, 'sym');
OrawLab2Theoretical(i) = kldiv(xbinsLab.raw.Vout, pdfsLab.raw.Vout, pdfsLab.theoretical.Vout, 'sym');
%     

    
end
% 
% vin.fsignal = fsignal;
% vin.filtered2Theoretical = Ifiltered2Theoretical;
% vin.raw2Simulink = Iraw2Simulink;
% vin.filtered2Simulink = Ifiltered2Simulink;
% vin.raw2Filtered = Iraw2Filtered;
% vin.raw2Theoretical = Iraw2Theoretical;
% vin.simulink2Theoretical = Isimulink2Theoretical;

vout.fsignal = fsignal;
vout.rawSuchai2Theoretical = OrawSuchai2Theoretical;
vout.rawSuchai2rawLab = OrawSuchai2rawLab;
vout.rawLab2Theoretical = OrawLab2Theoretical;
% power.fsignal = fsignal;
% power.filtered2Theoretical = Pfiltered2Theoretical;
% power.raw2Simulink = Praw2Simulink;
% power.filtered2Simulink = Pfiltered2Simulink;
% power.raw2Filtered = Praw2Filtered;
% power.raw2Theoretical = Praw2Theoretical;
% power.simulink2Theoretical = Psimulink2Theoretical;

% KLDiv.vin = vin;
KLDiv.vout = vout;
% KLDiv.power = power;

saveFileName = strcat(saveFolder,'/', date, '_kldiv.mat');
save(saveFileName, 'KLDiv','-v7.3');