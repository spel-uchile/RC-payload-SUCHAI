function data = interpolateDataFromCounts(counts, edges)

data = ones(1,sum(counts));
beginIndex = 1;
for i = 1 : length(counts)
  binCount = counts(i);
  endIndex = beginIndex + binCount - 1;
  data(beginIndex : endIndex) = data(beginIndex : endIndex).* mean(edges(i:i+1));
  beginIndex = endIndex + 1;
end

end