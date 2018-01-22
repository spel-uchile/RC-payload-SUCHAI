databases = {'lab','suchai'};
tratios = [3 5 8 10 15 20 25 30 40 50 75 100 200];

for ii = 1 : length(databases)
    database = databases{ii};
    npoints = 100;  %numbins
    seedFolder = ['./mat/ts/',database];
    freqsDir = dir(seedFolder);
    freqsDir = {freqsDir.name};
    freqsDir = freqsDir(3:end);
    freqsDir = sortn(freqsDir);
    freqsDir = lower(freqsDir);
    
    for i = 1 : length(freqsDir)
        freq = freqsDir{i};
        saveFolder = ['./mat/ts-averaged/',database,'/',freq];
        if ~isdir(saveFolder)
            mkdir(saveFolder)
        end
        currFreqFolder = strcat(seedFolder, '/', freq);
        matfiles = dir(currFreqFolder);
        matfiles = {matfiles.name};
        matfiles = matfiles(3:end);
        matfiles = sortn(matfiles);
        
        for ttauIndex = 1 : length(tratios)
            tvalue = tratios(ttauIndex);
            for kl = 1: length(matfiles)
                isRawOrTheoretical = ~isempty(strfind(matfiles{kl},'raw')) ||...
                    ~isempty(strfind(matfiles{kl},'theoretical'));
                if isRawOrTheoretical
                    currentFile = matfiles{kl};
                    newMatFolderName = strcat(saveFolder,'/ttau_', num2str(tvalue));
                    if ~isdir(fullfile(newMatFolderName))
                        disp(['creating directory ', newMatFolderName]);
                        mkdir(fullfile(newMatFolderName));
                    end
                    newMatFileName = strcat(newMatFolderName,'/',...
                        currentFile(1:(end-4)),'_ttau_',num2str(tvalue),'.mat');
                    if exist(fullfile(newMatFileName))
                        disp([newMatFileName,' already exists']);
                        loadMyFile = strcat(currFreqFolder,'/', matfiles{kl});
                        S1 = load(loadMyFile);
                        name = fieldnames(S1);
                        name = name{1}; %only raw timeserie
                        ts = S1.(name);
                        fsignal = ts.fsignal;
                        
                        S2 = load(newMatFileName);
                        name2 = fieldnames(S2);
                        name2 = name2{1};
                        averagedStruct = S2.(name2);
                        averagedStruct.fsignal = fsignal;
                        save(newMatFileName, 'averagedStruct','-v7.3');
                        continue
                    end
                    loadMyFile = strcat(currFreqFolder,'/', matfiles{kl});
                    S = load(loadMyFile);
                    name = fieldnames(S);
                    name = name{1}; %only raw timeserie
                    ts = S.(name);
                    fsignal = ts.fsignal;
                    
                    averagedStruct= timeSeriesAveraging(ts, tvalue, fsignal);
                    if ~(averagedStruct.smoothedFlag)
                        disp([loadMyFile, ' could not be averaged '...
                            'at t/tc ', num2str(tvalue),char(10),'bc sampling'...
                            'time is larger than tvalue and is convoluted with'...
                            'a kernel of size 1']);
                    end
                    
                    save(newMatFileName,'averagedStruct','-v7.3');
                    disp([newMatFileName,' saved sucessfully']);
                end
            end
        end
    end
end