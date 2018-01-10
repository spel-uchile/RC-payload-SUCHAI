function normalizedData = normalize( supportVector, data)
    normalizedData = data./trapz(supportVector, data);
    smallValuesIdx = normalizedData <= eps;
    normalizedData(smallValuesIdx) = eps;
end