dataset = 'tektronix';
overwrite = 'yes';
fsignal = 20*1e6; %20 MHz
R = 1207; %ohms medidos
C = 1.454*(1e-6); %farads medidos
logsDirName = [pwd,'/logs/tektronix'];
dirStruct = dir(logsDirName);
dirNames = {dirStruct.name};
dirNames = dirNames(3:end);
dirNames = sortn(dirNames);

for i = 1: length(dirNames)
    currDir = [logsDirName,'/',dirNames{i}];
    files = dir(currDir);
    files = {files.name};
    files = files(3:end);
    files = sortn(files);
    
    filename = [currDir, '/', files{1}];
    %get oscilloscope parameters
    [voffCh1, voffCh2, voffMath] = getVerticalOffset(filename); %number: zero of vertical.
    [vuCh1, vuCh2, vuMath] = getVerticalUnits(filename);    %text: 'V', 'VV', 'dB', etc
    [vsCh1, vsCh2, vsMath] = getVerticalScale(filename);    %number: vertical value
    [attCh1, attCh2, attMath] = getProbesAttenuation(filename); %number: 1x
    [dtCh1, dtCh2, dtMath] = getSamplingIntervalHorizontal(filename);  %number: dt
    [huCh1, huCh2, huMath] = getHorizontalUnits(filename);  %text: time units
    [hsCh1, hsCh2, hsMath] = getHorizontalScale(filename);  %number: time scale
    
    
    [t, ch1, ch2, math] = importTektronixTraces(filename);
    ch1 = ch1-voffCh1;
    ch2 = ch2-voffCh1;
    math = math-voffMath;
    ch1 = (ch1.*vsCh1)./attCh1;   %amplify by the Scale and adjust attenuation
    ch2 = (ch2.*vsCh2)./attCh2;
    math = (math.*vsMath)./attMath;

    TektronixConfig.Names = {'CH1', 'CH2', 'MATH'};
    TektronixConfig.VerticalOffset = [voffCh1, voffCh2, voffMath];
    TektronixConfig.VerticalUnits = [vuCh1, vuCh2, vuMath];
    TektronixConfig.VerticalScale = [vsCh1, vsCh2, vsMath];
    TektronixConfig.ProbesAttenuation =[attCh1, attCh2, attMath];
    TektronixConfig.SamplingInterval = [dtCh1, dtCh2, dtMath];
    TektronixConfig.HorizontalUnits = [huCh1, huCh2, huMath];
    TektronixConfig.HorizontalScale = [hsCh1, hsCh2, hsMath];
    
    %raw timeserie
    raw = timeSeriesFactory(fsignal, 'tektronix', ch1, ch2, t, math, R, C, ...
        TektronixConfig);
    
    saveFolder = [pwd,'/mat/ts/tektronix'];
    saveFolder = strcat(saveFolder, '/', raw.maxVin);
    prefix = dirNames{i};
    prefixjoin = [prefix(1:4), prefix(6:7), prefix(9:end)];
    if ~isdir(saveFolder)
        mkdir(saveFolder)
    end
    newRawFile = strcat(saveFolder, '/',prefixjoin,'_', raw.Name,'.mat');
    save(newRawFile,'raw','-v7.3');
end