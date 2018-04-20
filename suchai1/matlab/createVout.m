function tsOutput = createVout(outputStruct, vinTimeArray, varargin)

if nargin >= 3
    removeDC = varargin{1};
end

countsArray = outputStruct.counts;
adcMaxVoltage = outputStruct.maxVoltage;
adcMinVoltage = outputStruct.minVoltage;
adcBits = outputStruct.nbits;

vout = timeseries(countsArray, vinTimeArray, 'name', 'Vout');
vout.Data = count2voltage(vout.Data, adcMaxVoltage, adcMinVoltage, adcBits);
if strfind(removeDC, 'yes')
    vout.Data = vout.Data - mean(vout.Data);
end
vout.DataInfo.Units = 'V';
vout.DataInfo.Interpolation = tsdata.interpolation('zoh');
vout.TimeInfo.Units = 'seconds';

tsOutput = vout;
end