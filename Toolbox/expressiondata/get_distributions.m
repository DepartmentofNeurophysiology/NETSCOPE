function [px,ex] = get_distributions(gem,varargin)
%% Compute probability distributions of gene expression data
% Compute the distributions of the transcription levels of the genes in the
% gene expression matrix (GEM), by binning and counting the levels. Number
% of bins is determined by Sturges' rule. The distributions data is later
% used by the Entropy- and MI-computation functions.
% 
% [px,ex] = get_distributions(gem)
% 
% Input:
% gem:      gene expression matrix
% Optionally, the following Name-Value argument pair:
% log:      whether to log-transform the data before binning, default is
%           false.
% 
% Output:
% px:       matrix where rows are the distributions per gene.
% ex:       bin edges

options = struct();
for i = 1:2:length(varargin)
    options.(varargin{i}) = varargin{i+1};
end
%if ~isfield(options,'method')
%    options.method = 'separate';
%end
if isfield(options,'log')
    if options.log
        gem = log(gem + 1);
    end
else
    options.log = false;
end

ngenes = size(gem,1);
nbins = ceil(1+log2(size(gem,2)));
%{
Old way of choosing bins
if strcmp(options.method,'uniform')
    [~,ex] = histcounts(gem(:),nbins);
    ex = repmat(ex,ngenes,1);
elseif strcmp(options.method,'separate')
    ex = zeros(ngenes,nbins+1);
end
%}
px = zeros(ngenes,nbins);
ex = zeros(ngenes,nbins+1);
for i = 1:ngenes
    if sum(gem(i,:)) == 0
        continue;
    end
    ex(i,:) = linspace(min(gem(i,:)),max(gem(i,:)),nbins+1);
    px(i,:) = histcounts(gem(i,:),ex(i,:));
    %{
    Old way of binning
    if sum(ex(i,:)) == 0
        [px(i,:),ex(i,:)] = histcounts(gem(i,:),nbins);
    else
        px(i,:) = histcounts(gem(i,:),ex(i,:));
    end
    %}
end

% Normalize distributions
px = px ./ repmat(sum(px,2),1,size(px,2));
px(isnan(px)) = 0;

if options.log
    ex = exp(ex) - 1;
end