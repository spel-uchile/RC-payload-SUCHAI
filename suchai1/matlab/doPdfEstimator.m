database = 'suchai';
%% KDE bandwidth automaticos
% bandwidth
% bwVin = [0.0886    0.0589    0.0584    0.0646    0.1032    0.1180    0.0974    0.0589];
% bwVout = [0.0867    0.0564    0.0514    0.0278    0.0437    0.0328    0.0241    0.0135];
% bwVr = [0.0017    0.0013    0.0079    0.0579    0.0975    0.1199    0.1020    0.0603];
% bwIc = [0.0001    0.0009    0.0070    0.0140    0.0641    0.0969    0.1241    0.0811];
% bwIr = [0.0014    0.0011    0.0065    0.0478    0.0806    0.0991    0.0843    0.0499];
% bwPin = [0.0005    0.0005    0.0019    0.0170    0.0275    0.0329    0.0277    0.0164];
% bwPr = [0.0000    0.0000    0.0003    0.0152    0.0269    0.0346    0.0311    0.0176];
% bwPc =[0.0000    0.0002    0.0019    0.0020    0.0086    0.0079    0.0103    0.0046];
% bwLangInj =[14.4104    9.3053    8.6282    4.9747    7.8445    6.0418    4.7907    2.5713];
% bwLangDiss =[16.3958   10.4852    8.7650    2.6410    3.8605    1.9379    1.2959    0.7449];
% bwDeltaP = [0.0008    0.0007    0.0017    0.0065    0.0127    0.0101    0.0120    0.0060];
% bwLangDeltaP = [0.5550    0.4978    1.2081    4.5116    8.8711    7.0543    8.4196    4.2067];
% bwLangStored = [0.0271    0.1683    1.3406    1.4233    6.0074    5.5448    7.2081    3.2312];

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
% others
npoints = 100;  %numbinsç
kernel = 'normal';
%% Loop
seedFolder = ['./mat/ts/',database];
freqsDir = dir('./mat/ts/suchai');  %pair only with suchi
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
        %         if exist(fullfile(newMatFileName))
        %             disp([newMatFileName,' already exists']);
        %             continue
        %         end
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
%             bwStruct.Vin = bwVin(i);
%             bwStruct.Vout = bwVout(i);
%             bwStruct.Vr = bwVr(i);
%             bwStruct.Ir =  bwIr(i);
%             bwStruct.Ic = bwIc(i);
%             bwStruct.Pin = bwPin(i);
%             bwStruct.Pr =  bwPr(i);
%             bwStruct.Pc = bwPc(i);
%             bwStruct.DeltaP = bwDeltaP(i);
%             bwStruct.LangInj = bwLangInj(i);
%             bwStruct.LangDiss = bwLangDiss(i);
%             bwStruct.LangStored = bwLangStored(i);
%             bwStruct.LangDeltaP = bwLangDeltaP(i);
            
%             [pdfResult.(name), xbins.(name), bandWidth.(name), Parameters.(name)]= pdfEstimator(ts, npoints, kernel, bwStruct );
                        [pdfResult.(name), xbins.(name), bandWidth.(name), Parameters.(name)]= pdfEstimator(ts, npoints, kernel, []);
            save(newMatFileName,'pdfResult','xbins','Parameters','bandWidth','-v7.3');
            disp([newMatFileName,' saved sucessfully']);
        end
    end
end