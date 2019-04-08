function [px,ex] = get_distributions(gem)
%% Compute probability distributions of gene expression data
% Compute the distributions of the transcription levels of the genes in the
% gene expression matrix (GEM), by binning and counting the levels. The
% same bins are used for all genes.
% 
% [px,ex] = get_distributions(gem)
% 
% Input:
% gem:  gene expression matrix
% 
% Output:
% px:   matrix where rows store the transcription distributions per gene
% ex:   bin centers (domain of the distributions) ASDKLFJSDKFLJ

ngenes = size(gem,1);
nbins = ceil(1+log2(size(gem,2)));
[~,ex] = histcounts(gem(:),nbins);
px = zeros(ngenes,length(ex)-1);
for i = 1:ngenes
    if sum(gem(i,:)) == 0
        continue;
    end
    px(i,:) = histcounts(gem(i,:),ex);
end

% Normalize distributions
px = px ./ repmat(sum(px,2),1,size(px,2));
px(isnan(px)) = 0;

% Convert bin edges to bin centers
%ex = ex(2:end) - (ex(2)-ex(1))/2;