function sortedBins = sepFreqs(n, bin, indices)
%sepFreqs Separates frequencies in the data into groups (size > 1) with
%matching frequency, in order to find AC later
% INPUT:
%   n: vector, length = number of distinct frequencies and entries are the
%      number of nodes with each distinct frequency
%   bin: assignment of indices to frequency bins
%   indices: the global indices of the nodes we're searching
% OUTPUT:
%   sortedBins: cell array containing vectors of node indices with matching
%               frequencies

[bin, sort_index] = sort(bin);
indices = indices(sort_index); %reorder node indeces to match sorted bins

sortedBins = {};
count = 1;

for i = 1:size(n)
    if n(i) > 1
        sortedBins{count} = indices(bin == i);
        count = count + 1;
    end
end

end