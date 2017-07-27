function filteredCollection = filterCollection( tsCollection , indexes, buffLen)

if ~isempty(tsCollection)
    series = fieldnames(tsCollection);
    series = series(5:end);
    numberOfSeries = length(series);
    
    filteredCollection = tscollection();
    for i = 1 : numberOfSeries
        nextTimeSerie = tsCollection.(series{i});
        filteredSerie = filterTimeSerie(nextTimeSerie, indexes, buffLen);
        filteredCollection = addts(filteredCollection, filteredSerie);
    end
end
end

