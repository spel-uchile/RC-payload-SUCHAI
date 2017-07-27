function fittedValue = payloadCommandValue( freqHz )

[m, n, ~, ~] = payloadLinearFit(pwd);

old = digits;
digits(64)
period = vpa(1/freqHz);

if period > n
    fittedValue = vpa((period - n)./ m);
    fittedValue = uint16(fittedValue);
else
    disp('Warning: Call this function with a smaller argument or a positive one');
    fittedValue = 1;
end
digits(old)
end