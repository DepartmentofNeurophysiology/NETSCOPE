function compute_MI_batch(gem,file,varargin)
%% Compute mutual information (MI) matrix from gene expression data
% This function computes a MI matrix where each entry (i,j) is the MI
% between genes i and j. The MI is normalized w.r.t. the entropy of i, and
% then averaged with its transpose so that the final product is a
% symmetric matrix.
% This function should be used for datasets that are too large to fit in
% the RAM. This function does not load the entire MI matrix in the memory,
% but computes it in batches and stores the result in a file. Optionally,
% parallel processing can be used (Parallel Processing Toolbox is
% required).
% 
% compute_MI_batch(gem,file,...)
% 
% Input:
% gem:  (required) gene expression matrix
% file: (required) output filename to save MI matrix to.
% Optionally, the following Name-Value argument pairs:
% px:   (optional) distributions matrix from GEM_distributions(). Will be
%       computed if not provided.
% ex:   (optional) required if px is provided.
% h:    (optional) entropy array from get_entropy(). Will be computed if not
%       provided.
% norm: (optional, default=false) whether the GEM should be normalized 
%       before computing the distributions.
% batch:(optional, default=1000) batch size
% pp:   (optional, default=false) whether to use parallel processing for
%       faster computation.
% fetch:(optional, default=true) whether to wait for the function to finish
%       (i.e. fetch results immediately) or let it run in the background.
%       Only useful when PP=true.
% cont: (optional, default=false) whether to continue from a previous,
%       unfinished run.
% 
% Examples:
% mi = compute_MI_large(gem, 'result.mat', 'norm',true)
% mi = compute_MI_large(gem, 'result.mat', 'pp',true, 'fetch',false)

%% Parse arguments, compute PX, H if necessary
options = struct();
for i = 1:2:length(varargin)
    options.(varargin{i}) = varargin{i+1};
end
if isfield(options,'norm')
    if options.norm
        disp('ddd');
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
if ~isfield(options,'batch')
    options.batch = 1000;
end
if ~isfield(options,'cont')
    options.cont = false;
end

% Use separate function for parallel procesing
if isfield(options,'pp')
    if ~isfield(options,'fetch')
        options.fetch = true;
    end
    compute_MI_PP(gem,file,px,ex,h,options.batch,options.fetch,options.cont);
    return;
end

%% Set up batch structure
fprintf('Start time: %s\n',datestr(datetime('now')));
ngenes = size(gem,1);
% Open output file, allocate matrix if it doesn't exist
outfile = matfile(file,'Writable',true);
if ~options.cont
    fprintf('Allocating memory for matrix\n');
    outfile.mi = zeros(ngenes);
    %outfile.h = h;
end
data = struct('gem',gem,'px',px,'ex',ex);

%% Create parallel pool and parallel batch jobs (stored in f)
lp = 1:options.batch:ngenes; % Loop index
nbatches = 0.5*length(lp)*(length(lp)+1);
k = 0;
for i = 1:length(lp)
    ix = lp(i):min(ngenes,lp(i)+options.batch-1);
    
    for j = 1:i
        jx = lp(j):min(ngenes,lp(j)+options.batch-1);
        k = k+1;
        
        if options.cont && sum(sum(outfile.mi(ix,jx)))>0
            continue;
        end

        if i==j
            mi = process_batch(data,ix,0);
            %mi = mi ./ repmat(h(ix),1,length(ix));
            %mi(isnan(mi)) = 0;
            outfile.mi(ix,ix) = (mi+mi')/2;
        else
            mi = process_batch(data,ix,jx);
            %mi1 = mi ./ repmat(h(ix),1,length(jx));
            %mi1(isnan(mi1)) = 0;
            %mi2 = mi' ./ repmat(h(jx),1,length(ix));
            %mi2(isnan(mi2)) = 0;
            %outfile.mi(ix,jx) = (mi1+mi2')/2;
            %outfile.mi(jx,ix) = (mi1'+mi2)/2;
            outfile.mi(ix,jx) = mi;
            outfile.mi(jx,ix) = mi';
        end
        fprintf('%s: Saved batch %d out of %d\n',datestr(datetime('now')),k,nbatches);
    end
end