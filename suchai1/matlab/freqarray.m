fcutoff = 92;

fmin = fcutoff*0.1;
fmax = fcutoff*150;
f = logspace(log10(fmin), log10(fmax), 15);

cmd = [];
for i = 1 : length(f)
    cmd = [cmd payloadCommandValue(f(i))];
end

