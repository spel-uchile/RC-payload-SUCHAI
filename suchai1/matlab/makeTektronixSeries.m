function tsCollection= makeTektronixSeries(ch1, ch2, t, math, R, C, freqSignalHz)

if nargin < 6
    error('not enough arguments');
end
R_ohm = R;
C_farads = C;
%% Measurements (Vin and Vout)
disp(strcat('makeTektronixSeries Vin noise of bandwith ', num2str(freqSignalHz/1e6), ' MHz'));
vIn_ts = timeseries(ch1, t,'name', 'Vin');
vIn_ts.Data = vIn_ts.Data - mean(vIn_ts.Data);
vIn_ts.DataInfo.Units = 'V';
vIn_ts.DataInfo.Interpolation = tsdata.interpolation('zoh');
vIn_ts.TimeInfo.Units = 'seconds';

disp(strcat('makeTektronixSeries Vout with freq ', num2str(freqSignalHz/1e6), 'MHz'));
vOut_ts = timeseries(ch2, t,'name', 'Vout');
vOut_ts.Data = vOut_ts.Data - mean(vOut_ts.Data);
vOut_ts.DataInfo.Units = 'V';
vOut_ts.DataInfo.Interpolation = tsdata.interpolation('zoh');
vOut_ts.TimeInfo.Units = 'seconds';

disp(strcat('makeTektronixSeries  Vin x Vout (MATH) with freq ', num2str(freqSignalHz/1e6), ' MHz'));
math_ts = timeseries(math, t, 'name', 'Math');
math_ts.Data = math_ts.Data - mean(math_ts.Data);
math_ts.DataInfo.Units = 'mVV';
math_ts.DataInfo.Interpolation = tsdata.interpolation('zoh');
math_ts.TimeInfo.Units = 'seconds';

[vIn, vOut, vR, iR, iC, pR, pC, pIn, deltaPower] = ...
    makeCircuitVariablesFromTimeSeries(vIn_ts, vOut_ts, R_ohm, C_farads);

[langevinDissipated, langevinStored, langevinInjected, langevinDelta ] = ...
    makeLangevinVariablesFromTimeSeries( vIn_ts, vOut_ts, R_ohm, C_farads );


tsCollection = tscollection({vIn, vOut, math_ts, vR, iR, iC, pR, pC, pIn, deltaPower,...
    langevinDissipated, langevinInjected, langevinStored, langevinDelta});
end