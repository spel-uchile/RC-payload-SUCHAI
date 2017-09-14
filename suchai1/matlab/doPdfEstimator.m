seedFolder = './mat/ts/lab';
freqsDir = dir(seedFolder);
freqsDir = {freqsDir.name};
freqsDir = freqsDir(3:end);
freqsDir = sortn(freqsDir);
freqsDir = lower(freqsDir);

for i = 1 : length(freqsDir)
    
    freq = freqsDir{i};
    saveFolder = ['./mat/pdf/lab/',freq];
    if ~isdir(saveFolder)
        mkdir(saveFolder)
    end
    currFreqFolder = strcat(seedFolder, '/', freq);
    
    freqCircuitHz = 92;
    R = 1210;
    C = 1 / (freqCircuitHz * 2 * pi * R);
    dampingRate = 1/ (R*C);
    npoints = 100;
    
    matfiles = dir(currFreqFolder);
    matfiles = {matfiles.name};
    matfiles = matfiles(3:end);
    matfiles = sortn(matfiles);
    
    foo = strsplit(matfiles{1},'_');
    splittedStrings = cell(numel(matfiles), length(foo));
    for k = 1 : numel(matfiles)
        splittedStrings(k,:) = strsplit(matfiles{k}, '_');
    end
    
    dates = unique(strcat(splittedStrings(:,1),'_',splittedStrings(:,2)));
    for k = 1: length(dates)
        currentDataDate = dates{k};
        dateIndexes = strfind(matfiles, currentDataDate);
        emptyCells = cellfun ('isempty', dateIndexes);
        dateIndexes(emptyCells) = {0};
        dateIndexes = logical(cell2mat(dateIndexes));
        filesWithDate = strcat(currFreqFolder,'/', matfiles(dateIndexes));
        for j = 1 : length(filesWithDate)
            loadMyFile = filesWithDate{j};
            S = load(loadMyFile);
            name = fieldnames(S);
            name = name{1};
            if strfind(name, 'filtered')
                continue
            end
            ts = S.(name);
            [pdfResult.(name), xbins.(name),Parameters.(name)]= pdfEstimator(ts, [], npoints );
        end
        save(strcat(saveFolder,'/', currentDataDate,'_pdfEstimator_',...
            freq,'Hz.mat'),'pdfResult','xbins','Parameters','-v7.3');
    end
end