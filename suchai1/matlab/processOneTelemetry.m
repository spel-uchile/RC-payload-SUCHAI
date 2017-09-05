function [buffer, tmParameters] = processOneTelemetry(FID, adcPeriod)
regexBeginCmd =  '0x0100,0x0000,0x0008,';
regexContinueCmd = '0x0300';
regexEndCmd = '0x0200';
framesReceived = [];
dataLost = [];
dataReceived = [];
dataParsed = [];
frameCounter = 0;
uintsPerFrame = 30;
uintsFirstFrame = uintsPerFrame-3;
lastframe = -1;
lastdatareceived = [];
sizeTMSended = 4000;
payloadStatus = 0;
values = [];
seed = 0;   %fijo

tline = fgets(FID);
while ischar(tline)
    if ~isempty( strfind(tline(1:21), regexBeginCmd))
        indexl = strfind( tline, regexBeginCmd);
        indexl = indexl + length(regexBeginCmd);
        tmp = sscanf(tline(indexl: end), '%x,');
        values = [values; dataParsed];
        dataParsed = tmp(3 : end);
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
               dataLost(end)
            if currframe >=2
                howMany = currframe - 1;
                tmp = dataLost(end)+ linspace(1, ...
                    howMany*uintsPerFrame, howMany*uintsPerFrame);
                dataLost = [dataLost tmp];
                   dataLost(end)
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
               dataLost(end)
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
        values = [values; dataParsed];
        framesReceived = [framesReceived, currframe];
        frameCounter = frameCounter + 1;
        if (lastframe == -1)
            dataLost = 0 : uintsFirstFrame-1;
            if currframe >=2
                howMany = currframe - 2;
                tmp = dataLost(end)+ linspace(1, ...
                    howMany*uintsPerFrame, howMany*uintsPerFrame);
                dataLost = [dataLost tmp];
                dataLost(end)
                lastdatareceived = 0;
                tmp = dataLost(end) + linspace(1, 13, 1);
                dataReceived = [dataReceived, tmp];
            else
                lastdatareceived = 0;
                tmp = dataLost(end) + linspace(1, uintsPerFrame, uintsPerFrame);
                dataReceived = [dataReceived, tmp];
                   dataLost(end)
            end
        elseif (lastframe >= 0) && (currframe - lastframe) > 1
            howMany = currframe - lastframe - 1;
            tmp = lastdatareceived + linspace(1, ...
                howMany*13, howMany*13);
            dataLost = [dataLost tmp];
               dataLost(end)
            tmp = dataLost(end) + linspace(1, 13, 13);
            dataReceived = [dataReceived, tmp];
        else
            tmp = lastdatareceived + linspace(1, 13, 13);
            dataReceived = [dataReceived, tmp];
            
        end
        lastframe = currframe;
        lastdatareceived = dataReceived(end);
    end
    tline = fgets(FID);
end

if length(values) > sizeTMSended
    values = values(1: sizeTMSended);
end
tmParameters.framesReceived = framesReceived;
tmParameters.sizeTelemetrySended = sizeTMSended;
tmParameters.sizeTelemetryReceived = length(values);
tmParameters.payloadStatus = payloadStatus;
tmParameters.dataReceived = dataReceived;
tmParameters.dataLost = dataLost;
tmParameters.totalFrames = frameCounter;
buffer = [adcPeriod; seed; values];
end