function sgem = shuffle_GEM(gem)
%% Column-wise shuffle the gene expression matrix (GEM)
% Shuffle each column of the GEM to remove any correlations between genes
% but preserve the transcriptional profile of the cells.
% 
% sgem = shuffle_GEM(gem)
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