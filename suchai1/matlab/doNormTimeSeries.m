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
                %% divByMean
                saveFolder = ['./mat/ts-divByMean/',database,'/',freq];
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

                disp(['Dividing ',loadMyFile,' timeserie by its mean value']);
                divByMean = timeSeriesFactory(fsignal, 'divByMean', tsStruct);
                newMatFileName = strcat(saveFolder,'/',...
                    currentFile(1:(end-4)),'_divByMean.mat');
                save(newMatFileName,'divByMean','-v7.3');
                disp([newMatFileName,' saved sucessfully']);
                
                %% diffByMeanDivByStd
                saveFolder = ['./mat/ts-diffByMeanDivByStd/',database,'/',freq];
                if ~isdir(saveFolder)
                    disp(['creating directory ', saveFolder]);
                    mkdir(saveFolder)
                end
                
                disp(['Normalization ',loadMyFile,' timeserie by its mean and std value']);
                diffByMeanDivByStd = timeSeriesFactory(fsignal, 'diffByMeanDivByStd', tsStruct);
                newMatFileName = strcat(saveFolder,'/',...
                    currentFile(1:(end-4)),'_diffByMeanDivByStd.mat');
                save(newMatFileName,'diffByMeanDivByStd','-v7.3');
                disp([newMatFileName,' saved sucessfully']);
            end
        end
    end
end

%% Aleluya sound
Data = load('handel.mat');
sound(Data.y, Data.Fs);
