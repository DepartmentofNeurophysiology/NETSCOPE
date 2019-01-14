function corr_par_fetch
%% Fetch parallel functions created by corr_par_send. Function is interruptible.

global f out tempf;
ppool = gcp('nocreate');
assert(~isempty(ppool),'No futures running, function aborted');

% Normalization factor
load(tempf,'h');

% Fetch results and save to output file
%fprintf('Fetching parallel function results and saving...\n');
nbatches = numel(f);
k = 0; % Number of finished batches
while ~isempty(f)
    [j,c,ix,jx] = fetchNext(f);
    f(j) = [];
    k = k+1;
    
    % Normalize data
    m = c ./ repmat(h(ix),1,length(jx));
    m(isnan(m)) = 0;
    out.corr(ix,jx) = m;
    % Insert transposed batch
    if ~isequal(ix,jx)
        m = c' ./ repmat(h(jx),1,length(ix));
        m(isnan(m)) = 0;
        out.corr(jx,ix) = m;
    end
    
    fprintf('%s: Saved batch no. %d out of %d\n',datestr(datetime('now')),k,nbatches);
end

% Save autocorrelation/normalization coefficients
out.h = h;

% Clean up
delete([tempf '.mat']);
clearvars -global f out tempf;