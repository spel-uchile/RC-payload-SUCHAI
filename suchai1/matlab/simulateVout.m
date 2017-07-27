function tsOutput = simulateVout(vin, varargin)

simVin = vin;
simVin.Name = 'Vin';
startTime = simVin.TimeInfo.Start;
stopTime = simVin.TimeInfo.End;
sampleTime = simVin.TimeInfo.Increment;

options = simset('SrcWorkspace','current');
sim('payloadModel',[],options)

simVout.Name = 'Vout';
simVout.DataInfo.Units = 'V';

tsOutput = simVout;
end