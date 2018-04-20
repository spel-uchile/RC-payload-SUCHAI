function [langevinDissipated, langevinStored, langevinInjected, langevinDelta] = ...
    makeLangevinVariablesFromTimeSeries( vIn_ts, vR_ts, R_ohm, C_farads )

disp('making langevinDissipated, langevinStored, langevinInjected, langevinDelta');

dampingRateHz = 1/ (R_ohm*C_farads);
v2 = vR_ts.Data.*vR_ts.Data;
t = vR_ts.Time;
dv2 = v2(2:end) - v2(1:end-1);
dt = t(2:end) - t(1:end-1);
dValue2 = dv2./dt;
dValue2 = [0; dValue2]; % add a zero

%% Langevin equation variables
% Resistor
dissFactorLangevin = v2.*dampingRateHz;
langevinDissipated = timeseries(dissFactorLangevin,vR_ts.Time,'name','langevinDissipated');
langevinDissipated.DataInfo.Units = 'V^2 Hz';

% Capacitor
langevinStored = timeseries((dValue2)./2, vR_ts.Time,'name', 'langevinStored');
langevinStored.DataInfo.Units = 'V^2 Hz';

%Injected Power
langevinInjected = timeseries(dampingRateHz.*(vIn_ts.Data .* vR_ts.Data),...
    vR_ts.Time, 'name', 'langevinInjected');
langevinInjected.DataInfo.Units = 'V^2 Hz';

langevinDelta = timeseries(-(langevinInjected.Data - (langevinDissipated.Data + langevinStored.Data)),...
    vR_ts.Time, 'name', 'langevinDeltaPower');
langevinDelta.DataInfo.Units = 'V^2 Hz';
end

