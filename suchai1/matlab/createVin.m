function tsInput = createVin(inputStruct, varargin)

freqSignalHz = varargin{1};
oversamplingCoeff = varargin{2};
freqSamplingHz = freqSignalHz * oversamplingCoeff;
deltaTSampling = 1 / freqSamplingHz;

bitsDAC = inputStruct.nbits;
countsDACArray = inputStruct.counts;
tADC = deltaTSampling .* (0 : oversamplingCoeff*length(countsDACArray) - 1);
tDAC = downsample(tADC, oversamplingCoeff);

countsDAC = timeseries( countsDACArray, tDAC, 'name', 'DAC');
countsDAC.DataInfo.Units = 'Counts';
countsDAC.TimeInfo.Units = 'seconds';
countsDAC.DataInfo.Interpolation = tsdata.interpolation('zoh');

countsDAC = resample(countsDAC, tADC);
nanRows = find(isnan(countsDAC.Data));
countsDAC.Data = nanReplace(countsDAC.Data, nanRows);

vin = timeseries(countsDAC.Data, countsDAC.Time, 'name', 'Vin');
dacMaxVoltage = inputStruct.maxVoltage;
dacMinVoltage = inputStruct.minVoltage;
vin.Data = count2voltage(vin.Data, dacMaxVoltage, dacMinVoltage, bitsDAC);
% vin.Data = vin.Data - mean(vin.Data);
vin.DataInfo.Units = 'V';
vin.DataInfo.Interpolation = tsdata.interpolation('zoh');
vin.TimeInfo.Units = 'seconds';

tsInput = vin;
end