function [buffer, hasExec] = processOneOutput(FID)
regexlOutput = 'dat_set_Payload_Buff(';
regexrOutput = ')';
regexADC =  'adc period = ';
regexEOF = 'pay_exec finished';
values = [];
adcPeriod = 0;
seed = 0;

tline = fgets(FID);
while ischar(tline)
    breakCondition = ~isempty(strfind(tline,regexEOF)) || ...
        (~isempty(strfind(tline, regexADC)) && (adcPeriod > 0));
    if  breakCondition
        if ~ischar(tline)
            hasExec = false;
        else
            hasExec = true;
        end
        break
    elseif ~isempty( strfind(tline, regexADC))
        indexl = strfind( tline, regexADC);
        indexl = indexl + length(regexADC);
        adcPeriod = str2double(tline(indexl: end) );
    elseif  ~isempty(strfind(tline, regexlOutput) )
        indexl = strfind(tline, regexlOutput);
        indexl = indexl + length(regexlOutput);
        indexr = strfind(tline, regexrOutput);
        nextValue = str2double(tline(indexl : indexr - 1) );
        values = [values; nextValue];
    end
    tline = fgets(FID);
end

if adcPeriod == 0 || isempty(values)
    hasExec = false;
else
    hasExec = true;
end
buffer = [adcPeriod; seed; values];
end