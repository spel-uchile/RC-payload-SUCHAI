function tsCollection = makeExperimentalSeries(inputStruct, outputStruct, varargin)

if nargin < 5
    error('not enough arguments');
end

freqSignalHz = varargin{1};
oversamplingCoeff = varargin{2};
R_ohm = varargin{3};
C_farads = varargin{4};
dampingRateHz = R_ohm*C_farads;

%% Measurements (Vin and Vout)
disp(strcat('Building Vin with freq ', num2str(freqSignalHz), ' Hz'));
vinTimeSeries = createVin(inputStruct, freqSignalHz, oversamplingCoeff);

disp(strcat('Building Vout with freq ', num2str(freqSignalHz), ' Hz'));
voutTimeSeries = createVout(outputStruct, vinTimeSeries.Time);

%% Resistor
vR = timeseries((vinTimeSeries.Data - voutTimeSeries.Data),...
    voutTimeSeries.Time, 'name', 'vR');
vR.DataInfo.Units = 'V';
iR = timeseries((vR.Data).*(1000/R_ohm), voutTimeSeries.Time, ...
    'name', 'injectedPower');
iR.DataInfo.Units = 'mA';
pR = timeseries((iR.Data).*(vR.Data),'name', 'dissipatedPower');
pR.DataInfo.Units = 'mW';

%% Capacitor
x = voutTimeSeries.Data;
t = voutTimeSeries.Time.Data;
dx = x(2:end) - x(1:end-1);
dt = t(2:end) - t(1:end-1);
dValue = dx./dt;
dValue = [0 dValue]; % add a zero
ic = timeseries((1000*C_farads).*dValue,t,'name', 'iC');
ic.DataInfo.Units = 'mA';

x2 = voutTimeSeries.Data.*voutTimeSeries.Data;
t = voutTimeSeries.Time.Data;
dx = x2(2:end) - x2(1:end-1);
dt = t(2:end) - t(1:end-1);
dValue = dx./dt;
dValue = [0 dValue]; % add a zero
pC = timeseries((1000*(C_farads/2)).*dValue,t,'name', 'pC');
pC.DataInfo.Units = 'mW';

%% Injected Power
pIn = timeseries((vinTimeSeries.Data .* iR.Data),...
    voutTimeSeries.Time, 'name', 'pIn');
pIn.DataInfo.Units = 'mW';
tsCollection = tscollection({vinTimeSeries, voutTimeSeries, pIn, pR, pC, iR, iC, vR});
end