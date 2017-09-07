function [buffer, tmParameters] = processOneTelemetry(FID, adcPeriod)
regexBeginCmd =  '0x0100,0x0000,0x0008,';
regexContinueCmd = '0x0300';
regexEndCmd = '0x0200';
framesReceived = [];
dataLost = [];
dataReceived = [];
frameCounter = 0;
uintsPerFrame = 30;
uintsFirstFrame = uintsPerFrame-3;
uintsLastFrame = 13;
lastframe = -1;
lastdatareceived = [];
sizeTMSended = 4000;
payloadStatus = 0;
values = [];
seed = 0;   %fijo
oversamplingcoeff = 4; %fijo
oldline = '';

tline = fgets(FID);
while ischar(tline)
    if ~isempty( strfind(tline(1:21), regexBeginCmd))
        indexl = strfind( tline, regexBeginCmd);
        indexl = indexl + length(regexBeginCmd);
        tmp = sscanf(tline(indexl: end), '%x,');
        dataParsed = tmp(3 : end);
        values = [values; dataParsed];
        framesReceived = 0;
        currframe = 0;
        frameCounter = 1;
        lastframe = 0;
        payloadStatus = tmp(2);
        dataReceived = 0 : uintsFirstFrame-1;
        lastdatareceived = dataReceived(end);
    elseif  ~isempty(strfind(tline(1:6), regexContinueCmd))
        indexfl = strfind( tline, regexContinueCmd);
        indexfl = indexfl + length(regexContinueCmd)+1;
        indexfr = indexfl + 5 ;
        currframe = tline(indexfl: indexfr);
        currframe(3:4) = '00';
        currframe = sscanf(currframe, '%x');
        dataParsed = sscanf(tline(indexfr + 2: end), '%x,');
        values = [values; dataParsed];
        framesReceived = [framesReceived, currframe];
        frameCounter = frameCounter + 1;
        if (lastframe == -1)
            dataLost = 0 : uintsFirstFrame-1;
            if currframe >=2
                howMany = currframe - 1;
                tmp = dataLost(end)+ linspace(1, ...
                    howMany*uintsPerFrame, howMany*uintsPerFrame);
                dataLost = [dataLost tmp];
                lastdatareceived = 0;
                tmp = dataLost(end) + linspace(1, uintsPerFrame, uintsPerFrame);
                dataReceived = [dataReceived, tmp];
            else
                lastdatareceived = 0;
                tmp = dataLost(end) + linspace(1, uintsPerFrame, uintsPerFrame);
                dataReceived = [dataReceived, tmp];
            end
        elseif (lastframe >= 0) && (currframe - lastframe) > 1
            howMany = currframe - lastframe - 1;
            tmp = lastdatareceived + linspace(1, ...
                howMany*uintsPerFrame, howMany*uintsPerFrame);
            dataLost = [dataLost tmp];
            tmp = dataLost(end) + linspace(1, uintsPerFrame, uintsPerFrame);
            dataReceived = [dataReceived, tmp];
        else
            tmp = lastdatareceived + linspace(1, uintsPerFrame, uintsPerFrame);
            dataReceived = [dataReceived, tmp];
        end
        lastframe = currframe;
        lastdatareceived = dataReceived(end);
        
    elseif  ~isempty(strfind(tline(1:6), regexEndCmd)) ...
            && ~isempty(framesReceived);
        indexfl = strfind( tline, regexEndCmd);
        indexfl = indexfl + length(regexEndCmd)+1;
        indexfr = indexfl + 5 ;
        currframe = tline(indexfl: indexfr);
        currframe(3:4) = '00';
        currframe = sscanf(currframe, '%x');
        dataParsed = sscanf(tline(indexfr + 2: end), '%x,');
        values = [values; dataParsed(1:uintsLastFrame)];
        framesReceived = [framesReceived, currframe];
        frameCounter = frameCounter + 1;
        if (lastframe == -1)
            dataLost = 0 : uintsFirstFrame-1;
            if currframe >=2
                howMany = currframe - 2;
                tmp = dataLost(end)+ linspace(1, ...
                    howMany*uintsPerFrame, howMany*uintsPerFrame);
                dataLost = [dataLost tmp];
                lastdatareceived = 0;
                tmp = dataLost(end) + linspace(1, uintsLastFrame, uintsLastFrame);
                dataReceived = [dataReceived, tmp];
            else
            lastdatareceived = 0;
            tmp = dataLost(end) + linspace(1, uintsPerFrame, uintsPerFrame);
            dataReceived = [dataReceived, tmp];
            end
        elseif (lastframe >= 0) && (currframe - lastframe) > 1
            howMany = currframe - lastframe - 1;
            tmp = lastdatareceived + linspace(1, ...
                howMany*uintsPerFrame, howMany*uintsPerFrame);
            dataLost = [dataLost tmp];
            tmp = dataLost(end) + linspace(1, uintsLastFrame, uintsLastFrame);
            dataReceived = [dataReceived, tmp];
        else
            tmp = lastdatareceived + linspace(1, uintsLastFrame, uintsLastFrame);
            dataReceived = [dataReceived, tmp];
            
        end
        lastframe = currframe;
        lastdatareceived = dataReceived(end);
    end
    oldline = tline;
    tline = fgets(FID);
end

if length(values) > sizeTMSended
    values = values(1: sizeTMSended);
end

%% frames
maxFramesReceived = ((sizeTMSended - uintsFirstFrame - uintsLastFrame)...
    /uintsPerFrame)+2;
totalFrames = 0:maxFramesReceived-1;
framesrxIndex = arrayfun(@(x)find(totalFrames==x,1),framesReceived);%lost frames
framesLost = totalFrames;
framesLost(framesrxIndex) = [];
tmParameters.framesReceived = framesReceived;
tmParameters.framesLost = framesLost;
tmParameters.totalFrames = frameCounter;

%% Pairing samples & points
[pairedValues, Samples, Points] = pairSamplesWithPoints(values, dataReceived,...
    sizeTMSended, oversamplingcoeff);
tmParameters.rawReceivedSamples = dataReceived;
tmParameters.rawLostSamples = dataLost;
tmParameters.pairedReceivedSamples = Samples.received;
tmParameters.pairedLostSamples = Samples.lost;
tmParameters.pairedReceivedPoints = Points.received;
tmParameters.pairedLostPoints = Points.lost;

%% Values
tmParameters.rawValues = values;
tmParameters.pairedValues = pairedValues;
buffer = [adcPeriod; seed; pairedValues];

%% Status
tmParameters.sizeTelemetrySended = sizeTMSended;
tmParameters.sizeTelemetryReceivedPaired = length(pairedValues);
tmParameters.sizeTelemetryReceivedRaw = length(values);
tmParameters.payloadStatus = payloadStatus;

end