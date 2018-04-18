normalization  = 'diffByMeanDivByStd';
dataset = 'tektronix';
overwrite = 'yes';

%% KDE parameters manual
% bandwidth
bwVin = [0.0886    0.0589    0.0584    0.0646    0.1032    0.1180    0.0974    0.0589];
bwVout = [0.0867    0.0564    0.0514    0.0278    0.0437    0.0328    0.0241    0.0135];
bwVr = [0.0017    0.0013    0.015   0.015    0.015    0.015    0.0150    0.015];
bwIc = [0.0001    0.0009    0.0070    0.0140    0.0641    0.0969    0.1241    0.0811];
bwIr = [0.0478    0.0478    0.0478    0.0478    0.0478    0.0478    0.0478    0.0478];
bwPin = [0.0329    0.0329      0.0329      0.0329      0.0329     0.0329    0.0329     0.0329 ];
bwPr = [0.0346   0.0346    0.0346    0.0346    0.0346    0.0346    0.0346    0.0346];
bwPc =[0.0346   0.0346    0.0346    0.0346   0.0346    0.0346    0.0346    0.0346];
bwLangInj =[14.4104    9.3053    8.6282    4.9747    7.8445    6.0418    4.7907    2.5713];
bwLangDiss =[8.7650   8.7650   8.7650    8.7650   8.7650    8.7650    8.7650     8.7650];
bwDeltaP = [0.015    0.015    0.015    0.015    0.015    0.015    0.015   0.015];
bwLangDeltaP = [8.8711    8.8711    8.8711    8.8711   8.8711    8.8711    8.8711    8.8711];
bwLangStored = [5.5448    5.5448    5.5448    5.5448    5.5448    5.5448    5.5448    5.5448];
npoints = 100;  %numbins
kernel = 'normal';
% kernel = 'epanechnikov';
%% Loop
if ~exist('normalization','var')
    normalization = 'raw';
end
seedFolder = ['./mat/ts-',normalization,'/',dataset];
freqsDir = dir(['./mat/ts-',normalization,'/',dataset]);  %pair only with suchai frequencies
freqsDir = {freqsDir.name};
freqsDir = freqsDir(3:end);
freqsDir = sortn(freqsDir);
freqsDir = lower(freqsDir);

for i = 1 : length(freqsDir)
    freq = freqsDir{i};
    saveFolder = ['./mat/pdf-',normalization,'/',dataset,'/',freq];
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
    for kl = 1 : length(dates)
        currentDataDate = dates{kl};
        dateIndexes = strfind(matfiles, currentDataDate);
        emptyCells = cellfun ('isempty', dateIndexes);
        dateIndexes(emptyCells) = {0};
        dateIndexes = logical(cell2mat(dateIndexes));
        filesWithDate = strcat(currFreqFolder,'/', matfiles(dateIndexes));
        filesWithDateShort = matfiles(dateIndexes);
        
        for j = 1 : length(filesWithDate)
            newMatFileName = strcat(saveFolder,'/', 'pdfEstimator_',...
                filesWithDateShort{j});
            if ~exist(fullfile(newMatFileName))
                disp([newMatFileName,' is being created']);
            elseif exist(fullfile(newMatFileName)) && exist('overwrite') %&& exist('prefix');
                tmpPrefix = currentDataDate;
                if strfind(currentDataDate,tmpPrefix)
                    disp([newMatFileName,' is being created']);
                else
                    disp([newMatFileName,' already exists']);
                    continue;
                end
            else
                disp([newMatFileName,' already exists']);
                continue;
            end
            
            loadMyFile = filesWithDate{j};
            S = load(loadMyFile);
            name = fieldnames(S);
            name = name{1}; %raw, simulation, theoretical, divByMean, etc.
            if strfind(name, 'filtered') %never use this timeserie
                continue
            end
            ts = S.(name);
            [pdfResult.(name), xbins.(name), bandWidth.(name), ...
                Parameters.(name)]= pdfEstimator(ts, npoints, kernel, normalization, []);
            if overwrite
                save(newMatFileName,'pdfResult','xbins','Parameters','bandWidth','-v7.3');
                disp([newMatFileName,' saved sucessfully']);
            end
        end
    end
end
