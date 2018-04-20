function tsCollection= makeExperimentalSeries(inputStruct, outputStruct, varargin)

if nargin < 6
    error('not enough arguments');
end

freqSignalHz = varargin{1};
oversamplingCoeff = varargin{2};
R_ohm = varargin{3};
C_farads = varargin{4};
removeDC = 'no';
if nargin >= 6
    switch varargin{5}
        case 'removeDC'
            removeDC = 'yes';
        otherwise
            removeDC = 'no';
    end
end

%% Measurements (Vin and Vout)
disp(strcat('makeExperimentalSeries Vin with freq ', num2str(freqSignalHz), ' Hz'));
vIn_ts = createVin(inputStruct, freqSignalHz, oversamplingCoeff, removeDC);

disp(strcat('makeExperimentalSeries Vout with freq ', num2str(freqSignalHz), ' Hz'));
vOut_ts = createVout(outputStruct, vIn_ts.Time, removeDC);

[vIn, vOut, vR, iR, iC, pR, pC, pIn, deltaPower] = ...
    makeCircuitVariablesFromTimeSeries(vIn_ts, vOut_ts, R_ohm, C_farads);

[langevinDissipated, langevinStored, langevinInjected, langevinDelta ] = ...
    makeLangevinVariablesFromTimeSeries( vIn_ts, vR, R_ohm, C_farads );

tsCollection = tscollection({vIn, vOut, vR, iR, iC, pR, pC, pIn, deltaPower,...
    langevinDissipated, langevinInjected, langevinStored, langevinDelta});
end