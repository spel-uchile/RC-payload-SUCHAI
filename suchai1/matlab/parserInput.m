function parseMATFileName = parserInput(fileName, savePrefix, varargin)
if length(varargin) < 3
    error('Not enough arguments');
end

disp(['parsing ' fileName '...']);
values = [];
regexMode = 'mode = ';
mode = 'TBD';
regexSeed = 'seed = ';
seed = 0;

fid = fopen(fileName);
tline = fgets(fid);
while ischar(tline)
    if ~isempty( strfind(tline, regexSeed) )
        indexl = strfind( tline, regexSeed);
        indexl = indexl + length(regexSeed);
        seed = str2double( tline(indexl: end) );
    elseif ~isempty( strfind(tline, regexMode) )
        indexl = strfind( tline, regexMode);
        indexl = indexl + length(regexMode);
        mode = tline(indexl: end);
    else
        nextValue = str2double( tline );
        values = [values; nextValue];
    end
    tline = fgets(fid);
end
fclose(fid);

InputCounts.file = fileName;
InputCounts.len = length(values);
InputCounts.counts = values;
InputCounts.nbits = varargin{1};
InputCounts.minVoltage = varargin{2};
InputCounts.maxVoltage = varargin{3};
InputCounts.seed = seed;
InputCounts.mode = mode;

parseMATFileName = strcat(savePrefix,'.mat');
save(parseMATFileName, 'InputCounts');
end