function normalizedData = normalize( supportVector, data)
normalizedData = data./trapz(supportVector, data);
end