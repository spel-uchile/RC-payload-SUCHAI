function parseMATFileName = parserOutput(fileName, savePrefix, varargin)
disp(['parsing ' fileName '...']);
if length(varargin) < 4
    error('Not enough arguments');
end

regexADC =  'adcPeriod = ';
regexSeed = 'seed = ';

values = [];
adcPeriod = 0;
seed = 0;

fid = fopen(fileName);
tline = fgets(fid);

while ischar(tline)
    if ~isempty( strfind(tline, regexADC) )
        indexl = strfind( tline, regexADC);
        indexl = indexl + length(regexADC);
        adcPeriod = str2double( tline(indexl: end) );
        
    elseif ~isempty( strfind(tline, regexSeed) )
        indexl = strfind( tline, regexSeed);
        indexl = indexl + length(regexSeed);
        seed = str2double( tline(indexl: end) );
    else
        nextValue = str2double(tline);
        values = [values; nextValue];
    end
    tline = fgets(fid);
end
fclose(fid);

OutputCounts.file = fileName;
OutputCounts.len = length(values);
OutputCounts.counts = values;
OutputCounts.nbits = varargin{1};
OutputCounts.minVoltage = varargin{2};
OutputCounts.maxVoltage = varargin{3};
OutputCounts.oversamplingCoeff = varargin{4};
OutputCounts.adcPeriod = adcPeriod;
OutputCounts.seed = seed;

parseMATFileName = strcat(savePrefix,'.mat');
save(parseMATFileName, 'OutputCounts');
end