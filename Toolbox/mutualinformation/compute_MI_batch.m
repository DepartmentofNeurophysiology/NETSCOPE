function compute_MI_batch(data, file, varargin)
%% Compute mutual information (MI) matrix from continuous data
% This function computes a normalized MI matrix where each entry (i,j) is
% the MI between genes i and j. This function can be used for datasets that
% are too large to fit in the RAM. This function does not load the entire
% MI matrix in the memory, but computes it in batches and stores the result
% in a file. Optionally, parallel processing can be used (Parallel
% Processing Toolbox is required).
% 
% Does currently not work with Octave.
% 
% compute_MI_batch(data, file, ...)
% 
% Input:
% data: (required) data matrix (rows are variables, columns are samples)
% file: (required) output filename to save MI matrix to.
% 
% Optionally, the following Name-Value argument pairs:
% px:   (optional) distributions matrix from get_distributions(). Will be
%       computed if not provided.
% ex:   (optional) bin edges, required if px is provided.
% h:    (optional) entropy array from get_entropy(). Will be computed if not
%       provided.
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
% mi = compute_MI_batch(data, 'result.mat', 'batch',2000)
% mi = compute_MI_batch(data, 'result.mat', 'pp',true, 'fetch',false)
% 
% See also COMPUTE_MI, NORMALIZE_MI

%% Parse arguments, compute PX, H if necessary
options = struct();
for i = 1:2:length(varargin)
    options.(varargin{i}) = varargin{i+1};
end
if isfield(options,'px')
    px = options.px;
    ex = options.ex;
else
    [px,ex] = get_distributions(data);
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
    if options.pp
        if ~isfield(options,'fetch')
            options.fetch = true;
        end
        compute_MI_PP(data,file,px,ex,h,options.batch,options.fetch,options.cont);
        return;
    end
end

%% Set up batch structure
fprintf('Start time: %s\n',datestr(datetime('now')));
nvars = size(data,1);
% Open output file, allocate matrix if it doesn't exist
outfile = matfile(file,'Writable',true);
if ~options.cont
    fprintf('Allocating memory for matrix\n');
    outfile.mi = zeros(nvars);
end
data = struct('data', data, 'px', px, 'ex', ex);

%% Create parallel pool and parallel batch jobs (stored in f)
lp = 1:options.batch:nvars; % Loop index
nbatches = 0.5*length(lp)*(length(lp)+1);
k = 0;
for i = 1:length(lp)
    ix = lp(i):min(nvars,lp(i)+options.batch-1);
    
    for j = 1:i
        jx = lp(j):min(nvars,lp(j)+options.batch-1);
        k = k+1;
        
        if options.cont && sum(sum(outfile.mi(ix,jx)))>0
            continue;
        end

        mi = process_batch(data,ix,jx);
        mi = normalize_MI(mi,h(ix),h(jx));
        outfile.mi(ix,jx) = mi;
        if i ~= j % Not along diagonal
            outfile.mi(jx,ix) = mi';
        end
        fprintf('%s: Saved batch %d out of %d\n',datestr(datetime('now')),k,nbatches);
    end
end