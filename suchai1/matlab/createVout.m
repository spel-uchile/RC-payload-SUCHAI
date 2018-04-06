function tsOutput = createVout(outputStruct, vinTimeArray, varargin)

countsArray = outputStruct.counts;
adcMaxVoltage = outputStruct.maxVoltage;
adcMinVoltage = outputStruct.minVoltage;
adcBits = outputStruct.nbits;

vout = timeseries(countsArray, vinTimeArray, 'name', 'Vout');
vout.Data = count2voltage(vout.Data, adcMaxVoltage, adcMinVoltage, adcBits);
% vout.Data = vout.Data - mean(vout.Data);
vout.DataInfo.Units = 'V';
vout.DataInfo.Interpolation = tsdata.interpolation('zoh');
vout.TimeInfo.Units = 'seconds';

tsOutput = vout;
end