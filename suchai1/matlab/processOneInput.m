function [buffer, hasExec] = processOneInput(FID, mode)
regexlInput = 'rand() = ';
switch mode
    case 'default'
        regexSeed = 'fis_payload_print_seed ';
    case 'full'
        regexSeed = 'fis_payload_print_seed_full ';
    otherwise
        regexSeed = 'fis_payload_print_seed ';
end
        
regexEOF = 'pay_print_seed ... finished';
values = [];
seed = -1;

tline = fgets(FID);
while ischar(tline)
    breakCondition = ~isempty(strfind(tline,regexEOF)) || ...
        (~isempty(strfind(tline, regexSeed)) && (seed >= 0));
    if  breakCondition
        if ~ischar(tline)
            hasExec = false;
        else
            hasExec = true;
        end
        break
    elseif ~isempty( strfind(tline, regexSeed))
        indexl = strfind( tline, regexSeed);
        indexl = indexl + length(regexSeed);
        seed= str2double(tline(indexl: end) );
    elseif  ~isempty(strfind(tline, regexlInput) )
        indexl = strfind(tline, regexlInput);
        indexl = indexl + length(regexlInput);
        nextValue = str2double(tline(indexl : end) );
        values = [values; nextValue];
    end
    tline = fgets(FID);
end

if seed == -1 || isempty(values)
    hasExec = false;
end
buffer = [seed; values];
end