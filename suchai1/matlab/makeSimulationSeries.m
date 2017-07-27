function tsCollection = makeSimulationSeries(inputStruct, varargin)

if nargin < 4
    error('not enough arguments');
end

freqSignalHz = varargin{1};
oversamplingCoeff = varargin{2};
dampingRateHz = varargin{3};

disp(strcat('Building Vin with freq ', num2str(freqSignalHz), ' Hz'));
vinTimeSeries = createVin(inputStruct, freqSignalHz, oversamplingCoeff);

disp(strcat('Building Vout with freq ', num2str(freqSignalHz), ' Hz'));
voutTimeSeries = simulateVout(vinTimeSeries);

powerTimeSeries = timeseries(dampingRateHz.*(vinTimeSeries.Data .* voutTimeSeries.Data),...
    voutTimeSeries.Time, 'name', 'injectedPower');
powerTimeSeries.DataInfo.Units = 'V^2 Hz';

tsCollection = tscollection({vinTimeSeries, voutTimeSeries, powerTimeSeries});
end