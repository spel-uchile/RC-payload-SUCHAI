function createdTimeSeries = timeSeriesFactory(freqSignalHz, varargin)

if nargin < 2
    error('Second argument missing');
end

freqCircuitHz = 91.5;
R = 1210;
C = 1 / (freqCircuitHz * 2 * pi * R);
dampingRate = 1/ (R*C);

switch varargin{1}
     case 'tektronix'
        TektronixVin = varargin{2};
        TektronixVout = varargin{3};
        TektronixTime = varargin{4};
        TektronixMath = varargin{5};
        R = varargin{6};
        C = varargin{7};
        
        tsCollection = makeTektronixSeries(TektronixVin, TektronixVout,...
            TektronixTime, TektronixMath, R, C, freqSignalHz);
        maxVin = max(tsCollection.Vin.Data);
        dacBits = Inf;
        adcBits = Inf;
     
        tsCollection.Name = strcat( 'tektronix_D_', num2str(maxVin));

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
        
        tsCollection.Name = strcat( 'raw_', num2str(freqSignalHz),'Hz');

    case 'filtered'
        S = load(varargin{2});
        Input = S.InputCounts;
        S = load(varargin{3});
        Output = S.OutputCounts;
        dacBits = Input.nbits;
        adcBits = Output.nbits;
        
        oversamplingCoeff = varargin{4};
        rawCollection = makeExperimentalSeries(Input, Output, freqSignalHz, ...
            oversamplingCoeff, R, C);
        buffLen = 200;
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data, buffLen);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat('filtered_', num2str(freqSignalHz),'Hz');
        
    case 'simulink'
        S = load(varargin{2});
        Input = S.InputCounts;
        dacBits = Input.nbits;
        adcBits = 10;
        maxVin = Input.maxVoltage;
        maxVout = Input.maxVoltage;
        
        oversamplingCoeff = varargin{3};
        rawCollection = makeSimulationSeries(Input, freqSignalHz, oversamplingCoeff, R, C);
        buffLen = length(rawCollection.Vin.Data);
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
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
end
