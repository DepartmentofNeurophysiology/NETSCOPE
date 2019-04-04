function sgem = shuffle_gem(gem)
%% Column-wise shuffle the gene expression matrix (GEM)
% Shuffle each column of the GEM to remove any correlations between genes
% but preserve the transcriptional profile of the cells
% 
% Input:
% gem: gene expression matrix
% 
% Output:
% sgem: shuffled gene expression matrix

sgem = zeros(size(gem));
for i = 1:size(gem,2)
    sgem(:,i) = gem(randperm(size(gem,1)),i);
end