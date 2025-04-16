function [px, ex] = get_distributions(data, varargin)
%% Compute probability distributions of gene expression data
% Compute the data distributions per variable across samples, by binning
% and counting the levels. Bins are determined by either by Sturges', or
% the Freedman-Diaconis rule. The distributions are later used in the
% entropy- and MI-computations.
% 
% [px, ex] = get_distributions(data)
% 
% Input:
% data: data matrix (rows are variables, columns are samples)

% Optionally, the following Name-Value argument pair:
% binning:  which binning rule to use, default is Freedman-Diaconis
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
if isfield(options, 'log')
    if options.log
        data = log(data + 1);
    end
else
    options.log = false;
end
if ~isfield(options, 'binning')
    options.binning = 'freedman';
end

nvars = size(data, 1);
bin_factor = nthroot(size(data, 2), 3);
px = cell(nvars, 1);
ex = cell(nvars, 1);
for i = 1:nvars
    if sum(data(i,:)) == 0
        continue;
    end
    
    if contains(lower(options.binning), 'freedman')
        % Freedman-Diaconis rule to calculate bin width
        iqr_value = iqr(data(i, :));
        bin_width = 2 * iqr_value / bin_factor;

        % Handle edge cases
        if bin_width <= 0
            bin_width = range(data(i, :)) / 10;
        end
        if bin_width <= 0
            bin_width = 2;
        end
    
        % Create bin edges
        min_edge = min(data(i, :));
        max_edge = max(data(i, :));
        ex{i} = min_edge:bin_width:max_edge;
    else
        % Sturges' rule for bin width and number
        nbins = ceil(1 + log2(size(data, 2)));
        ex{i} = linspace(min(data(i, :)), max(data(i, :)), nbins + 1);
    end
    
    % Calculate distributions
    px{i} = histcounts(data(i, :), ex{i});
    px{i} = px{i} ./ sum(px{i});
    px{i}(isnan(px{i})) = 0;
end

if options.log
    for i = 1:nvars
        ex{i} = exp(ex{i}) - 1;
    end
end