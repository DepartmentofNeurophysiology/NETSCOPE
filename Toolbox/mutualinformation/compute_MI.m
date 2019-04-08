function mi = compute_MI(gem,varargin)
%% Compute mutual information (MI) matrix from gene expression data
% This function computes a MI matrix where each entry (i,j) is the MI
% between genes i and j. The MI is normalized w.r.t. the entropy of i, and
% then averaged with its transpose so that the final product is a
% symmetric matrix.
% This function should be used for datasets that are small enough to fit in
% the RAM and where no parallel processing is needed to speed up the
% process.
% 
% mi = compute_MI(gem,...)
% 
% Input:
% gem:  (required) gene expression matrix
% Optionally, the following Name-Value argument pairs:
% px:   (optional) distributions matrix from GEM_distributions(). Will be
%       computed if not provided.
% ex:   (optional) required if Px is provided.
% h:    (optional) entropy array from get_entropy(). Will be computed if not
%       provided.
% norm: (optional) true/false whether the GEM should be normalized before
%       computing the distributions. Default: false.
% 
% Output:
% mi:   MI matrix
% 
% Examples:
% mi = compute_MI_small(gem, 'norm',true)

%% Parse arguments, compute px, h if necessary
options = struct();
for i = 1:2:length(varargin)
    options.(varargin{i}) = varargin{i+1};
end
if isfield(options,'norm')
    if options.norm
        gem = normalize_GEM(gem);
    end
end
if isfield(options,'px')
    px = options.px;
    ex = options.ex;
else
    [px,ex] = get_distributions(gem);
end
if isfield(options,'h')
    h = options.h;
else
    h = get_entropy(px);
end

%% Compute MI matrix
ngenes = size(px,1);
mi = zeros(ngenes);
for i = 1:ngenes
    if sum(gem(i,:)) == 0
        continue;
    end
    for j = 1:(i-1)
        if sum(gem(j,:)) == 0
            continue;
        end
        % Compute joint distribution and MI
        pxy = histcounts2(gem(i,:),gem(j,:),ex(i,:),ex(j,:));
        pxy = pxy / sum(pxy(:));
        mi(i,j) = sum(nansum(pxy .* log(pxy ./ (px(i,:)'*px(j,:)))));
    end
end

%% Normalize and symmetrize MI matrix
mi = mi+mi';
mi = mi ./ repmat(h,1,ngenes);
mi(isnan(mi)) = 0;
mi = (mi+mi')/2;