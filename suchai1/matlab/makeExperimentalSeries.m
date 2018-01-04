function tsCollection= makeExperimentalSeries(inputStruct, outputStruct, varargin)

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
vIn = createVin(inputStruct, freqSignalHz, oversamplingCoeff);

disp(strcat('Building Vout with freq ', num2str(freqSignalHz), ' Hz'));
vOut = createVout(outputStruct, vIn.Time);

%% Circuit equation timeseries
%Resistor
vR = timeseries((vIn.Data - vOut.Data),...
    vOut.Time, 'name', 'Vr');
vR.DataInfo.Units = 'V';
iR = timeseries((vR.Data).*(1000/R_ohm), vOut.Time, ...
    'name', 'Ir');
iR.DataInfo.Units = 'mA';
pR = timeseries((iR.Data).*(vR.Data),vOut.Time,'name', 'Pr');
pR.DataInfo.Units = 'mW';

% Capacitor
v = vOut.Data;
t = vOut.Time;
dv = v(2:end) - v(1:end-1);
dt = t(2:end) - t(1:end-1);
dValue = dv./dt;
dValue = [0; dValue]; % add a zero
iC = timeseries((1000*C_farads).*dValue, vOut.Time,'name', 'Ic');
iC.DataInfo.Units = 'mA';

v2 = vOut.Data.*vOut.Data;
t = vOut.Time;
dv2 = v2(2:end) - v2(1:end-1);
dt = t(2:end) - t(1:end-1);
dValue2 = dv2./dt;
dValue2 = [0; dValue2]; % add a zero
pC = timeseries((1000*(C_farads/2)).*dValue2, vOut.Time,'name', 'Pc');
pC.DataInfo.Units = 'mW';

%Injected Power
pIn = timeseries((vIn.Data .* iR.Data),...
    vOut.Time, 'name', 'Pin');
pIn.DataInfo.Units = 'mW';

deltaPower = timeseries((pIn.Data - (pR.Data + pC.Data)),...
    vOut.Time, 'name', 'DeltaPower');
deltaPower.DataInfo.Units = 'mW';

%% Langevin equation variables
% Resistor
dissFactorLangevin = v2.*dampingRateHz;
langevinDissipated = timeseries(dissFactorLangevin,vOut.Time,'name','langevinDissipated');
langevinDissipated.DataInfo.Units = 'V^2 Hz';

% Capacitor
langevinStored = timeseries((dValue2)./2, vOut.Time,'name', 'langevinStored');
langevinStored.DataInfo.Units = 'V^2 Hz';

%Injected Power
langevinInjected = timeseries(dampingRateHz.*(vIn.Data .* vOut.Data),...
    vOut.Time, 'name', 'langevinInjected');
langevinInjected.DataInfo.Units = 'V^2 Hz';

langevinDeltaPower = timeseries((langevinInjected.Data - (langevinDissipated.Data + langevinStored.Data)),...
    vOut.Time, 'name', 'langevinDeltaPower');
langevinDeltaPower.DataInfo.Units = 'V^2 Hz';

tsCollection = tscollection({vIn, vOut, vR, iR, iC, pR, pC, pIn, deltaPower,...
    langevinDissipated, langevinInjected, langevinDeltaPower});
end