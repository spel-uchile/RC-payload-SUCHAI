databases = {'suchai','tektronix','lab'};

for i = 1 : length(databases)
    database = databases{i};
    npoints = 100;  %numbins
    seedFolder = ['./mat/ts-raw/',database];
    freqsDir = dir(seedFolder);
    freqsDir = {freqsDir.name};
    freqsDir = freqsDir(3:end);
    freqsDir = sortn(freqsDir);
    freqsDir = lower(freqsDir);
    
    for ii = 1 : length(freqsDir)
        freq = freqsDir{ii};
        currFreqFolder = strcat(seedFolder, '/', freq);
        matfiles = dir(currFreqFolder);
        matfiles = {matfiles.name};
        matfiles = matfiles(3:end);
        matfiles = sortn(matfiles);
        
        for kl = 1: length(matfiles)
            isRawOrTheoretical = ~isempty(strfind(matfiles{kl},'raw')) ||...
                ~isempty(strfind(matfiles{kl},'theoretical'));
            isTektronix = ~isempty(strfind(lower(database), 'tektronix'));
            if isRawOrTheoretical || isTektronix    
                saveFolder = ['./mat/ts-', normalization, '/',database,'/',freq];
                if ~isdir(saveFolder)
                    disp(['creating directory ', saveFolder]);
                    mkdir(saveFolder)
                end
                currentFile = matfiles{kl};
                loadMyFile = strcat(currFreqFolder,'/', matfiles{kl});
                S = load(loadMyFile);
                name = fieldnames(S);
                name = name{1}; %only raw timeserie
                tsStruct = S.(name);
                fsignal = tsStruct.fsignal;

                disp(['Making normalization: ', normalization, 'at file ',loadMyFile]);
                tsNormalized = timeSeriesFactory(fsignal, normalization, tsStruct);
                newMatFileName = strcat(saveFolder,'/',...
                    currentFile(1:(end-4)),'_', normalization,'.mat');
                save(newMatFileName,'tsNormalized','-v7.3');
                disp([newMatFileName,' saved sucessfully']);
            end
        end
    end
end

%% Aleluya sound
Data = load('handel.mat');
sound(Data.y, Data.Fs);
