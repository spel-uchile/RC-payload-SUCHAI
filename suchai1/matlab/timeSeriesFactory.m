function createdTimeSeries = timeSeriesFactory(freqSignalHz, varargin)

if nargin < 2
    error('Second argument missing');
end

freqCircuitHz = 91.5;
R = 1210;
C = 1 / (freqCircuitHz * 2 * pi * R);
dampingRate = 1/ (R*C);
D = 4.7983;    %Vin power spectrum in [mV^2_{rms}/Hz] of PIC24F and Simulink

switch varargin{1}
    case 'tektronix'
        TektronixVin = varargin{2};
        TektronixVout = varargin{3};
        TektronixTime = varargin{4};
        TektronixMath = varargin{5};
        R = varargin{6};
        C = varargin{7};
        TektronixConfig = varargin{8};
        
        tsCollection = makeTektronixSeries(TektronixVin, TektronixVout,...
            TektronixTime, TektronixMath, R, C, freqSignalHz);
        dacBits = Inf;
        adcBits = Inf;
        X = tsCollection.Vin.Data;
        L = length(X);
        Y = fft(X);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        D = rms(P1)*1000;    %Vin power spectrum in [mV^2_{rms}/Hz]
        createdTimeSeries.Din = D;
        createdTimeSeries.TektronixConfig = TektronixConfig;
        tsCollection.Name = strcat( 'tektronix_D_', num2str(D));
        
    case 'divByMean'
        tsStruct = varargin{2};
        tsCollection = tsStruct.tsc;
        originalCollection = tsCollection;
        namesOfVariables = {'Vin','Vout','Vr','Ir','Ic','Pr','Pc','Pin',...
            'DeltaPower','langevinDissipated','langevinInjected',...
            'langevinStored','langevinDeltaPower'};
        for i = 1: length(namesOfVariables)
            currentVariable = namesOfVariables{i};
            X = originalCollection.(currentVariable).Data;
            meanX = mean(X);
            X = X./ meanX;
            tsCollection.(currentVariable).Data = X;
        end
        D = tsStruct.Din;
        dacBits = tsStruct.dacBits;
        adcBits = tsStruct.adcBits;
        dampingRate = tsStruct.dampingRate;
        
        tsCollection.Name = ['divByMean_', originalCollection.Name];
        
    case 'diffByMeanDivByStd'
        tsStruct = varargin{2};
        tsCollection = tsStruct.tsc;
        originalCollection = tsCollection;
        namesOfVariables = {'Vin','Vout','Vr','Ir','Ic','Pr','Pc','Pin',...
            'DeltaPower','langevinDissipated','langevinInjected',...
            'langevinStored','langevinDeltaPower'};
        for i = 1: length(namesOfVariables)
            currentVariable = namesOfVariables{i};
            X = originalCollection.(currentVariable).Data;
            meanX = mean(X);
            sigmaX = rms(X);
            X = (X-meanX)./ sigmaX;
            tsCollection.(currentVariable).Data = X;
        end
        D = tsStruct.Din;
        dacBits = tsStruct.dacBits;
        adcBits = tsStruct.adcBits;
        dampingRate = tsStruct.dampingRate;
        
        tsCollection.Name = ['diffByMeanDivByStd_', originalCollection.Name];
        
    case 'raw'
        S = load(varargin{2});
        Input = S.InputCounts;
        S = load(varargin{3});
        Output = S.OutputCounts;
        
        oversamplingCoeff = varargin{4};
        tsCollection = makeExperimentalSeries(Input, Output, freqSignalHz, ...
            oversamplingCoeff, R, C);
        dacBits = Input.nbits;
        adcBits = Output.nbits;
        maxVin = Input.maxVoltage;
        maxVout = Output.maxVoltage;
        X = tsCollection.Vin.Data;
        L = length(X);
        Y = fft(X);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        D = rms(P1)*1000;
        
        tsCollection.Name = strcat( 'raw_', num2str(freqSignalHz),'Hz');
        
    case 'filtered'
        S = load(varargin{2});
        Input = S.InputCounts;
        S = load(varargin{3});
        Output = S.OutputCounts;
        dacBits = Input.nbits;
        adcBits = Output.nbits;
        D = 146.5910;
        
        oversamplingCoeff = varargin{4};
        rawCollection = makeExperimentalSeries(Input, Output, freqSignalHz, ...
            oversamplingCoeff, R, C);
        buffLen = 200;
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data, buffLen);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        X = tsCollection.Vin.Data;
        L = length(X);
        Y = fft(X);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        D = rms(P1)*1000;
        tsCollection.Name = strcat('filtered_', num2str(freqSignalHz),'Hz');
        
    case 'simulink'
        S = load(varargin{2});
        Input = S.InputCounts;
        dacBits = Input.nbits;
        adcBits = 10;
        maxVin = Input.maxVoltage;
        maxVout = Input.maxVoltage;
        D = 4.8080;
        oversamplingCoeff = varargin{3};
        rawCollection = makeSimulationSeries(Input, freqSignalHz, oversamplingCoeff, R, C);
        buffLen = length(rawCollection.Vin.Data);
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        X = tsCollection.Vin.Data;
        L = length(X);
        Y = fft(X);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        D = rms(P1)*1000;
        tsCollection.Name = strcat( 'simulink_', num2str(freqSignalHz),'Hz');
        
    case 'theoretical'
        Parameters = varargin{2};
        % 'option2' set as default in simualtionSD function
        simResult = simulationFactory(freqSignalHz, 'theoretical', Parameters); % returns a normalized serie
        tsCollection = simResult.tsc;
        tsCollection.Name = strcat( 'theoretical_', num2str(freqSignalHz),'Hz');
        maxVin = simResult.maxVin;
        maxVout = simResult.maxVout;
        dacBits = Parameters.dacBits;
        adcBits = Parameters.adcBits;
        X = tsCollection.Vin.Data;
        L = length(X);
        Y = fft(X);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        D = rms(P1)*1000;
    otherwise
        error(['The argument' ' "' varargin{1} '" ' 'is not recognized.'])
end

createdTimeSeries.fsignal = freqSignalHz;
createdTimeSeries.tsc = tsCollection;
createdTimeSeries.Name = tsCollection.Name;
createdTimeSeries.maxVin = max(tsCollection.Vin.Data);
createdTimeSeries.minVin = min(tsCollection.Vin.Data);
createdTimeSeries.maxVout = max(tsCollection.Vout.Data);
createdTimeSeries.minVout = min(tsCollection.Vout.Data);
createdTimeSeries.maxPower = max(tsCollection.Pin.Data);
createdTimeSeries.minPower = min(tsCollection.Pin.Data);
createdTimeSeries.maxPowerLangevin = max(tsCollection.langevinInjected.Data);
createdTimeSeries.minPowerLangevin = min(tsCollection.langevinInjected.Data);
createdTimeSeries.dacBits = dacBits;
createdTimeSeries.adcBits = adcBits;
createdTimeSeries.dampingRate = dampingRate;
createdTimeSeries.dateOfCreation = datestr(datetime('now','Format',...
    'yyyy/MM/dd-HH:mm:ss'));
createdTimeSeries.Din = D;
end
