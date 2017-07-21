clear all;
close all;

date = '2016_18_05';
matFileName = strcat(date,'_Distributions.mat');
load(matFileName)
names = fieldnames(ExpFisDistributions);
f = zeros(1,length(names));
filtered2Theoretical = zeros(1,length(names));
raw2Simulink = zeros(1,length(names));
filtered2Simulink = zeros(1,length(names));
raw2Filtered = zeros(1,length(names));
raw2Theoretical = zeros(1,length(names));
simulink2Theoretical = zeros(1,length(names));

for i = 1: length(names)
    %% Load counts and edges
    CurrentFreq = ExpFisDistributions.(names{i});
    f(i) = CurrentFreq.freqSignalHz;
    Vin = CurrentFreq.vin;
    
    filtered2Theoretical(i) = kldiv(Vin.supportVector, Vin.filtered, Vin.teo, 'sym');
    raw2Simulink(i) = kldiv(Vin.supportVector, Vin.data, Vin.sim, 'sym');
    filtered2Simulink(i) = kldiv(Vin.supportVector, Vin.filtered, Vin.sim, 'sym'); 
    raw2Filtered(i) = kldiv(Vin.supportVector, Vin.filtered, Vin.data,'sym');
    raw2Theoretical(i) = kldiv(Vin.supportVector, Vin.data, Vin.teo, 'sym');
    simulink2Theoretical(i) = kldiv(Vin.supportVector, Vin.sim, Vin.teo, 'sym');
end
vin.freq = f;
vin.filtered2Theoretical = filtered2Theoretical;
vin.raw2Simulink = raw2Simulink;
vin.filtered2Simulink = filtered2Simulink;
vin.raw2Filtered = raw2Filtered;
vin.raw2Theoretical = raw2Theoretical;
vin.simulink2Theoretical = simulink2Theoretical;

for i = 1: length(names)
    %% Load counts and edges
    CurrentFreq = ExpFisDistributions.(names{i});
    f(i) = CurrentFreq.freqSignalHz;
    Vout = CurrentFreq.vout;
    
    filtered2Theoretical(i) = kldiv(Vout.supportVector, Vout.filtered,Vout.teo, 'sym');
    raw2Simulink(i) = kldiv(Vout.supportVector, Vout.data, Vout.sim, 'sym');
    filtered2Simulink(i) = kldiv(Vout.supportVector, Vout.filtered, Vout.sim, 'sym');
    raw2Filtered(i) = kldiv(Vout.supportVector,Vout.filtered, Vout.data,'sym');
    raw2Theoretical(i) = kldiv(Vout.supportVector, Vout.data, Vout.teo, 'sym');
    simulink2Theoretical(i) = kldiv(Vout.supportVector, Vout.sim, Vout.teo, 'sym');
end
vout.freq = f;
vout.filtered2Theoretical = filtered2Theoretical;
vout.raw2Simulink = raw2Simulink;
vout.filtered2Simulink = filtered2Simulink;
vout.raw2Filtered = raw2Filtered;
vout.raw2Theoretical = raw2Theoretical;
vout.simulink2Theoretical = simulink2Theoretical;

for i = 1: length(names)
    %% Load counts and edges
    CurrentFreq = ExpFisDistributions.(names{i});
    f(i) = CurrentFreq.freqSignalHz;
    Power = CurrentFreq.power;
    
    filtered2Theoretical(i) = kldiv(Power.supportVector, Power.filtered, Power.teo, 'sym');
    raw2Simulink(i) = kldiv(Power.supportVector, Power.data, Power.sim, 'sym'); 
    filtered2Simulink(i) = kldiv(Power.supportVector, Power.filtered, Power.sim, 'sym');
    raw2Filtered(i) = kldiv(Power.supportVector, Power.filtered, Power.data,'sym');
    raw2Theoretical(i) = kldiv(Power.supportVector, Power.data, Power.teo, 'sym'); 
    simulink2Theoretical(i) = kldiv(Power.supportVector, Power.sim, Power.teo, 'sym'); 

end
power.freq = f;
power.filtered2Theoretical = filtered2Theoretical;
power.raw2Simulink = raw2Simulink;
power.filtered2Simulink = filtered2Simulink;
power.raw2Filtered = raw2Filtered;
power.raw2Theoretical = raw2Theoretical;
power.simulink2Theoretical = simulink2Theoretical;

KLDiv.vin = vin;
KLDiv.vout = vout;
KLDiv.power = power;

saveFileName = strcat(date, '_Errors_KLDiv.mat');
save(saveFileName, 'KLDiv','-v7.3');