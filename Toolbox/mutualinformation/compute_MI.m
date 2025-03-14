function mi = compute_MI(data, varargin)
%% Compute mutual information (MI) matrix from continuous data
% This function computes an MI matrix where each entry (i,j) is the MI
% between variables i and j. This function can be used for datasets that
% are small enough to fit in the RAM and where no parallel processing is
% needed to speed up the process.
% 
% mi = compute_MI(data, ...)
% 
% Input:
% data: (required) data matrix (rows are variables, columns are samples)
% 
% Optionally, the following Name-Value argument pairs:
% px:   (optional) distributions matrix from get_distributions(). Will be
%       computed if not provided.
% ex:   (optional) bin edges, required if px is provided.
% h:    (optional) entropy array from get_entropy(). Will be computed if not
%       provided.
% 
% Output:
% mi:   MI matrix (normalized w.r.t. joint entropy)
% 
% Examples:
% mi = compute_MI(data)
% mi = compute_MI(data, 'px', pxdata, 'ex', exdata)
% 
% See also COMPUTE_MI_BATCH, NORMALIZE_MI

%% Parse arguments, compute px, h if necessary
options = struct();
for i = 1:2:length(varargin)
    options.(varargin{i}) = varargin{i+1};
end
if isfield(options,'px')
    px = options.px;
    ex = options.ex;
else
    [px, ex] = get_distributions(data);
end
if isfield(options,'h')
    h = options.h;
else
    h = get_entropy(px);
end

%% Compute MI matrix
nvars = size(px, 1);
mi = zeros(nvars);
for i = 1:nvars
    if sum(data(i,:)) == 0
        continue;
    end
    for j = 1:(i-1)
        if sum(data(j,:)) == 0
            continue;
        end
        % Compute joint distribution and MI
        pxy = histcounts2(data(i,:), data(j,:), ex{i}, ex{j});
        pxy = pxy / sum(pxy(:));
        mi(i,j) = sum(nansum(pxy .* log(pxy ./ (px{i}'*px{j}))));
    end
end

%% Normalize and symmetrize MI matrix
mi = normalize_MI(mi+mi', h);