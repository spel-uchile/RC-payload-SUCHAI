function restoredData = repairZeros( zeroValuedData, eps )

restoredData = zeroValuedData;
I = find(zeroValuedData == 0);
restoredData(I) = eps;
end

