database = 'lab';
npoints = 100;  %numbins
seedFolder = ['./mat/ts/',database];
freqsDir = dir(seedFolder);
freqsDir = {freqsDir.name};
freqsDir = freqsDir(3:end);
freqsDir = sortn(freqsDir);
freqsDir = lower(freqsDir);

for i = 1 : length(freqsDir)
    freq = freqsDir{i};
    saveFolder = ['./mat/pdf/',database,'/',freq];
    if ~isdir(saveFolder)
        mkdir(saveFolder)
    end
    currFreqFolder = strcat(seedFolder, '/', freq); 
    matfiles = dir(currFreqFolder);
    matfiles = {matfiles.name};
    matfiles = matfiles(3:end);
    matfiles = sortn(matfiles);
    
    foo = strsplit(matfiles{1},'_');
    splittedStrings = cell(numel(matfiles), length(foo));
    for ki = 1 : numel(matfiles)
        splittedStrings(ki,:) = strsplit(matfiles{ki}, '_');
    end
    
    dates = unique(strcat(splittedStrings(:,1),'_',splittedStrings(:,2)));
    for kl = 1: length(dates)
        currentDataDate = dates{kl};
        newMatFileName = strcat(saveFolder,'/', currentDataDate,...
            '_pdfEstimator_',freq,'Hz.mat');
        if exist(fullfile(newMatFileName))
            disp([newMatFileName,' already exists']);
            continue
        end
        disp([newMatFileName,' is being created']);
        dateIndexes = strfind(matfiles, currentDataDate);
        emptyCells = cellfun ('isempty', dateIndexes);
        dateIndexes(emptyCells) = {0};
        dateIndexes = logical(cell2mat(dateIndexes));
        filesWithDate = strcat(currFreqFolder,'/', matfiles(dateIndexes));
        for j = 1 : length(filesWithDate)
            loadMyFile = filesWithDate{j};
            S = load(loadMyFile);
            name = fieldnames(S);
            name = name{1}; %only raw timeserie
            if strfind(name, 'filtered')
                continue
            end
            ts = S.(name);
            [pdfResult.(name), xbins.(name), bw.(name), Parameters.(name)]= pdfEstimator(ts, npoints );
        end
        save(newMatFileName,'pdfResult','xbins','Parameters','-v7.3');
        disp([newMatFileName,' saved sucessfully']);
    end
end