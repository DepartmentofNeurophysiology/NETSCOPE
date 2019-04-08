function ngem = normalize_GEM(gem)
%% Normalize gene expression matrix (GEM)
% Normalize GEM w.r.t. the total transcription of a cell.
% 
% ngem = normalize_GEM(gem)
% 
% Input:
% gem:  gene expression matrix
% 
% Output:
% ngem: normalized gene expression matrix

ngem = gem ./ repmat(sum(gem),size(gem,1),1);