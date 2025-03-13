function [px, ex] = get_distributions(data, varargin)
%% Compute probability distributions of gene expression data
% Compute the data distributions per variable across samples, by binning
% and counting the levels. Number of bins is determined by Sturges' rule.
% The distributions are later used in the entropy- and MI-computations.
% 
% [px, ex] = get_distributions(data)
% 
% Input:
% data: data matrix (rows are variables, columns are samples)

% Optionally, the following Name-Value argument pair:
% log:      whether to log-transform the data before binning, default is
%           false.
% 
% Output:
% px:       matrix where rows are the distributions per variable.
% ex:       bin edges
% 
% See also GET_ENTROPY

options = struct();
for i = 1:2:length(varargin)
    options.(varargin{i}) = varargin{i+1};
end
if isfield(options,'log')
    if options.log
        data = log(data + 1);
    end
else
    options.log = false;
end

nvars = size(data,1);
nbins = ceil(1+log2(size(data,2)));
px = zeros(nvars,nbins);
ex = zeros(nvars,nbins+1);
for i = 1:nvars
    if sum(data(i,:)) == 0
        continue;
    end
    ex(i,:) = linspace(min(data(i,:)),max(data(i,:)),nbins+1);
    px(i,:) = histcounts(data(i,:),ex(i,:));
end

% Normalize distributions
px = px ./ repmat(sum(px,2),1,size(px,2));
px(isnan(px)) = 0;

if options.log
    ex = exp(ex) - 1;
end