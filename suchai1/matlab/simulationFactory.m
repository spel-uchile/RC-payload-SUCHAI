function varargout = simulationFactory(freqSignalHz, varargin)

if nargin < 2
    error('Second argument missing');
end

freqCircuitHz = 92;
R = 1210;
C = 1 / (freqCircuitHz * 2 * pi * R);
dampingRate = 1/ (R*C);

option =  varargin{1};
switch option
    case 'theoretical'
        Parameters = varargin{2};
        numberOfValues = Parameters.numberOfRandomValues;
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^(dacBits-1))-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);% returns a normalized serie
        nWaitingUnits = 0;
        valuesPerRound = length(tsInput.Data);
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, 'option2');
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        rawCollection = tscollection({tsInput, tsOutput, tsInjPower});
        buffLen = length(rawCollection.Vin.Data);
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data, buffLen);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        nonSampledValuesPerRound = Parameters.nonSampledValuesPerRound;
        nWaitingUnits = Parameters.nWaitingUnits;
        
    case 'option1'
        Parameters = varargin{2};
        nonSampledValuesPerRound = Parameters.nonSampledValuesPerRound;
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        rounds = Parameters.rounds;
        numberOfValues = rounds * (nonSampledValuesPerRound + sampledValuesPerRound);
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^(dacBits-1))-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        nWaitingUnits = Parameters.nWaitingUnits;
        valuesPerRound = nonSampledValuesPerRound + sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, option);
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscOption1_', num2str(freqSignalHz),'Hz');
        
    case'option2'
        Parameters = varargin{2};
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        nonSampledValuesPerRound = 0;
        rounds = Parameters.rounds;
        numberOfValues = rounds * sampledValuesPerRound;
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^(dacBits-1))-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        nWaitingUnits = Parameters.nWaitingUnits;
        valuesPerRound = sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, option);
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscOption2_', num2str(freqSignalHz),'Hz');
        
    case'option3'
        Parameters = varargin{2};
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        nonSampledValuesPerRound = 0;
        rounds = Parameters.rounds;
        numberOfValues = rounds *  sampledValuesPerRound;
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^(dacBits-1))-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        nWaitingUnits = Parameters.nWaitingUnits;
        valuesPerRound = sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, option);
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscoption3_', num2str(freqSignalHz),'Hz');
        
    case'option1+3'
        Parameters = varargin{2};
        nonSampledValuesPerRound = Parameters.nonSampledValuesPerRound;
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        rounds = Parameters.rounds;
        numberOfValues = rounds * (nonSampledValuesPerRound + sampledValuesPerRound);
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^(dacBits-1))-1), ...
            numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        nWaitingUnits = Parameters.nWaitingUnits;
        valuesPerRound = nonSampledValuesPerRound + sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, 'option3');
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)),...
            tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscOption1+3Full_', num2str(freqSignalHz),'Hz');
        
    otherwise
        error(['The argument' ' "' option '" ' 'is not recognized.']);
end

%% physical signals
maxVin = Input.maxVoltage;
maxVout = Input.maxVoltage;
varargout{1}.Name = tsCollection.Name;
varargout{1}.maxVin = max(tsCollection.Vin.Data);
varargout{1}.minVin = min(tsCollection.Vin.Data);
varargout{1}.maxVout = max(tsCollection.Vout.Data);
varargout{1}.minVout = max(tsCollection.Vout.Data);
varargout{1}.minPower = min(tsCollection.injectedPower.Data);
varargout{1}.maxPower = max(tsCollection.injectedPower.Data);
varargout{1}.fsignal = freqSignalHz;
varargout{1}.tsc = tsCollection;

%% filtered/sampled signals
[tsSampledVin, tsSampledVout] = filterMemSDSimulation(tsInput, tsOutput, ...
    sampledValuesPerRound, nonSampledValuesPerRound, nWaitingUnits);
tsSampledPower = timeseries((dampingRate.* (tsSampledVin.Data .* ...
    tsSampledVout.Data)), tsSampledVout.Time);
tsSampledPower.Name = tsInjPower.Name;
tsSampledPower.DataInfo.Units = tsInjPower.DataInfo.Units;
tsSampledCollection = tscollection({tsSampledVin, tsSampledVout, tsSampledPower});
tsSampledCollection.Name = strcat( 'tscOption1+3Sampled_', num2str(freqSignalHz),'Hz');
varargout{2}.fsignal = freqSignalHz;
varargout{2}.tsc = tsSampledCollection;
varargout{2}.Name = tsSampledCollection.Name;
varargout{2}.maxVin = max(tsCollection.Vin.Data);
varargout{2}.minVin = min(tsCollection.Vin.Data);
varargout{2}.maxVout = max(tsCollection.Vout.Data);
varargout{2}.minVout = min(tsCollection.Vout.Data);
varargout{2}.minPower = min(tsSampledCollection.injectedPower.Data);
varargout{2}.maxPower = max(tsSampledCollection.injectedPower.Data);

end