function normalized = normalize_data(data)
%% Normalize data matrix
% Normalize data w.r.t. the sample total.
% 
% normalized = normalize_data(data)
% 
% Input:
% data: data matrix (rows are variables, columns are samples)
% 
% Output:
% normalized: normalized data matrix

normalized = data ./ repmat(sum(data),size(data,1),1);