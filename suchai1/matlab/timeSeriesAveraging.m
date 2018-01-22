function averagedStruct = timeSeriesAveraging( originalCollection, tratioValue, fsignal)
    
dtIncrement = originalCollection.tsc.TimeInfo.Increment;
t = originalCollection.tsc.Time;
% NvaluesTS = originalCollection.tsc.Length;
tauRCSeconds = 1 / originalCollection.dampingRate;

NwindowSeconds =  tratioValue*tauRCSeconds;
Nwindow = 1;
smoothedFlag = false;
if NwindowSeconds > dtIncrement
    Nwindow = floor(NwindowSeconds/dtIncrement);
    smoothedFlag = true;
end

avgVin = movingAverage(originalCollection.tsc.Vin.Data, Nwindow);
avgVin = timeseries(avgVin, t, 'name', 'Vin');
avgVin.DataInfo.Units = 'V';

avgVout = movingAverage(originalCollection.tsc.Vout.Data, Nwindow);
avgVout = timeseries(avgVout, t, 'name', 'Vout');
avgVout.DataInfo.Units = 'V';

avgVr = movingAverage(originalCollection.tsc.Vr.Data, Nwindow);
avgVr = timeseries(avgVr, t, 'name', 'Vr');

avgIr = movingAverage(originalCollection.tsc.Ir.Data, Nwindow);
avgIr = timeseries(avgIr, t, 'name', 'Ir');
avgIr.DataInfo.Units = 'mA';

avgIc = movingAverage(originalCollection.tsc.Ic.Data, Nwindow);
avgIc = timeseries(avgIc, t, 'name', 'Ic');
avgIc.DataInfo.Units = 'mA';

avgPr = movingAverage(originalCollection.tsc.Pr.Data, Nwindow);
avgPr = timeseries(avgPr, t, 'name', 'Pr');
avgPr.DataInfo.Units = 'mW';

avgPc = movingAverage(originalCollection.tsc.Pc.Data, Nwindow);
avgPc = timeseries(avgPc, t, 'name', 'Pc');
avgPc.DataInfo.Units = 'mW';

avgPin = movingAverage(originalCollection.tsc.Pin.Data, Nwindow);
avgPin = timeseries(avgPin, t, 'name', 'Pin');
avgPin.DataInfo.Units = 'mW';

avgDelta = movingAverage(originalCollection.tsc.DeltaPower.Data, Nwindow);
avgDelta = timeseries(avgDelta, t, 'name', 'DeltaPower');
avgDelta.DataInfo.Units = 'mW';

avgLangInj = movingAverage(originalCollection.tsc.langevinInjected.Data, Nwindow);
avgLangInj = timeseries(avgLangInj, t, 'name', 'LangInj');
avgLangInj.DataInfo.Units = 'V^2 Hz';

avgLangDiss = movingAverage(originalCollection.tsc.langevinDissipated.Data, Nwindow);
avgLangDiss = timeseries(avgLangDiss, t, 'name', 'LangDiss');
avgLangDiss.DataInfo.Units = 'V^2 Hz';

avgLangStored = movingAverage(originalCollection.tsc.langevinStored.Data, Nwindow);
avgLangStored = timeseries(avgLangStored, t, 'name', 'LangStored');
avgLangStored.DataInfo.Units = 'V^2 Hz';

avgLangDelta = movingAverage(originalCollection.tsc.langevinDeltaPower.Data, Nwindow);
avgLangDelta = timeseries(avgLangDelta, t, 'name', 'LangDelta');
avgLangDelta.DataInfo.Units = 'V^2 Hz';

averagedCollection = tscollection({avgVin, avgVout, avgVr, avgIr, avgIc, avgPr,...
    avgPc, avgPin, avgDelta, avgLangInj, avgLangDiss, avgLangStored,...
    avgLangDelta});

averagedStruct.tsc = averagedCollection;
averagedStruct.smoothedFlag = smoothedFlag;
averagedStruct.fsignal = fsignal;
end

