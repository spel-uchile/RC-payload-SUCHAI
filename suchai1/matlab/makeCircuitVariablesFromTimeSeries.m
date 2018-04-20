function [vIn, vOut, vR, iR, iC, pR, pC, pIn, deltaPower] = ...
    makeCircuitVariablesFromTimeSeries(vIn_ts, vOut_ts, R_ohm, C_farads)
%% Circuit equation timeseries
disp('making vIn, vOut, vR, iR, iC, pR, pC, pIn, deltaPower');
vIn = vIn_ts;
vOut = vOut_ts;
%Resistor
vR = timeseries((vIn_ts.Data - vOut_ts.Data),...
    vOut_ts.Time, 'name', 'Vr');
vR.DataInfo.Units = 'V';
iR = timeseries((vR.Data).* R_ohm, vOut_ts.Time, ...
    'name', 'Ir');
iR.DataInfo.Units = 'A';
pR = timeseries((iR.Data).*(vR.Data),vOut_ts.Time,'name', 'Pr');
pR.DataInfo.Units = 'W';

% Capacitor
v = vOut_ts.Data;
t = vOut_ts.Time;
dv = v(2:end) - v(1:end-1);
dt = t(2:end) - t(1:end-1);
dValue = dv./dt;
dValue = [0; dValue]; % add a zero
iC = timeseries((C_farads).*dValue, vOut_ts.Time,'name', 'Ic');
iC.DataInfo.Units = 'A';

v2 = vOut_ts.Data.*vOut_ts.Data;
t = vOut_ts.Time;
dv2 = v2(2:end) - v2(1:end-1);
dt = t(2:end) - t(1:end-1);
dValue2 = dv2./dt;
dValue2 = [0; dValue2]; % add a zero
pC = timeseries(((C_farads/2)).*dValue2, vOut_ts.Time,'name', 'Pc');
pC.DataInfo.Units = 'W';

%Injected Power
pIn = timeseries((vIn_ts.Data .* iR.Data),...
    vOut_ts.Time, 'name', 'Pin');
pIn.DataInfo.Units = 'W';

deltaPower = timeseries(-(pIn.Data - (pR.Data + pC.Data)),...
    vOut_ts.Time, 'name', 'DeltaPower');
deltaPower.DataInfo.Units = 'mW';

end

