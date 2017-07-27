function replacedData = nanReplace( data, indexes )

for i = 1:length(indexes)
    currentIndex = indexes(i);
    if isnan( data( currentIndex ) )
        data(currentIndex) = data(currentIndex - 1);
    end
end

replacedData = data;

end