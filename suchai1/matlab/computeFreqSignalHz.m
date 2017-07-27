function freq = computeFreqSignalHz(adcValue, samplingCoeff)

[m, n, ~, ~] = payloadLinearFit(pwd);
dTSampling = m*adcValue + n;
dTSignal = dTSampling * samplingCoeff;
freq = 1 / dTSignal;

end