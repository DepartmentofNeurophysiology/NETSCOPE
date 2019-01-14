function corr_par_send(dm,fileout,varargin)
%% Create parallel futures computing the correlation between gene pairs.
% dm: gene expression matrix
% fileout: output filename
% varargin: Name-Value pairs specifying options, possible options are:
% % batchsize: batch size for parallel pool (default=1000)
% % function: correlation function - 'mi', 'pearson', ... (default='mi')
% % normalize: whether to sample-normalize the GE data (default=false)
% % fetch: whether to fetch results immediately (true), or let the
% % computations run in the background (false) (default=true)
% % continue: set to true to continue a previous run (default=false)

%% Set options default values
options = struct();
for i = 1:2:length(varargin)
    options.(varargin{i}) = varargin{i+1};
end
if ~isfield(options,'batchsize')
    options.batchsize = 1000;
end
if ~isfield(options,'function')
    options.function = 'mi';
end
if ~isfield(options,'normalize')
    options.normalize = false;
end
if ~isfield(options,'fetch')
    options.fetch = true;
end
if ~isfield(options,'continue')
    options.continue = false;
end

%fprintf('Start: %s\n',datestr(datetime('now')));
clearvars -global f out tempf;
global f out tempf; % Declare as global so corr_par_fetch can use them
%fprintf('Created global variables f, out, tempf\n');

ng = size(dm,1); % Number of genes
ns = size(dm,2); % Number of samples
tempf = tempname(); % Temporary file for provisional results
save(tempf,'ng','ns');

% Open output file, allocate matrix if it doesn't exist
%fprintf('Opening output file %s, allocating memory for matrix\n',fileout);
out = matfile(fileout,'Writable',true);
if ~options.continue
    out.corr = zeros(ng);
end

%fprintf('Normalizing gene expression matrix\n');
% Normalize gene expression matrix
%dm = log(double(dm)+1); % Log-transform
if options.normalize
    dm = double(dm) ./ repmat(sum(dm),ng,1); % Normalize sample expression
end

%% Choose measure of association
switch options.function
    case 'mi'
%        fprintf('Calculating gene entropy for %d genes\n',ng);
        [px,ex,h] = calcEntropy(dm); % Entropy for normalization
        save(tempf,'px','ex','h','-append');
        func = @mtinf_comp;
    case 'pearson'
        % Pearson correlation no autocorrelation normalization
        h = ones(ng,1);
        save(tempf,'h','-append');
        dm = (dm - repmat(mean(dm,2),1,ns)) ./ repmat(std(dm,[],2),1,ns);
        func = @corr_comp;
    case 'euclidean'
        h = ones(ng,1);
        save(tempf,'h','-append');
        func = @eucl_comp;
    case 'kldiv'
        h = ones(ng,1);
        [px,ex] = getpdfs(dm); % Gene distribution proobability density functions
        save(tempf,'px','ex','h','-append');
        func = @kldiv_comp;
    otherwise
        error('Unknown similarity function');
end
save(tempf,'dm','-append');

%% Create parallel pool and parallel batch jobs (stored in f)
gcp();
f = [];
lp = 1:options.batchsize:ng; % Loop index
%fprintf('Sending out parallel function evaluations\n');
for i = 1:length(lp)
    indexi = lp(i):min(ng,lp(i)+options.batchsize-1);
    
    for j = 1:length(lp)
        indexj = lp(j):min(ng,lp(j)+options.batchsize-1);
        
        if options.continue && sum(sum(out.corr(indexi,indexj)))>0
            continue;
        end

        if i<j
            continue;
        elseif i==j
            f = [f;parfeval(func,3,tempf,indexi,0)];
        else
            f = [f;parfeval(func,3,tempf,indexi,indexj)];
        end
    end
end

% Start fetching data right away
if options.fetch
    clear;
    corr_par_fetch;
end