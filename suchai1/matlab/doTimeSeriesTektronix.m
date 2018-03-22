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
    [t, ch1, ch2, math] = importfileFromTektronix(filename);
    
    %raw timeserie
    raw = timeSeriesFactory(fsignal, 'tektronix', ch1, ch2, t, math, R, C);
    
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
