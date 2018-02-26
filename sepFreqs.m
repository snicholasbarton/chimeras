function sortedBins = sepFreqs(n, bin, indices)
    [bin, sort_index] = sort(bin);
    indices = indices(sort_index); %reorder node indeces to match sorted bins
    maxn = max(n);
    sortedBins = {};
    count = 1;
    for i = 1:size(n)
        if n(i) > 1
            sortedBins{count} = indices(bin == i);
            count = count + 1;
        end
    end
    
end