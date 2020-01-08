function fetch_results
%% This function is called from compute_MI_PP()
% This function can be interrupted and then called again, as long as the
% Parallel Pool is still intact. If not, call compute_MI_large() with
% PP=true and Cont=true to finish computation.

global jobs outfile tempfile;
ppool = gcp('nocreate');
assert(~isempty(ppool),'No futures running, function aborted');
load(tempfile,'h');

% Fetch results and save to output file
fprintf('Fetching results from parallel jobs\n');
nbatches = numel(jobs);
k = 1; % Number of finished batches
while ~isempty(jobs)
    [j,mi,ix,jx] = fetchNext(jobs);
    jobs(j) = [];
    
    mi = normalize_MI(mi,h(ix),h(jx));
    outfile.mi(ix,jx) = mi;
    if ~isequal(ix,jx) % Not along diagonal
        outfile.mi(jx,ix) = mi';
    end
    % Old normalization
    %mi1 = mi ./ repmat(h(ix),1,length(jx));
    %mi1(isnan(mi1)) = 0;
    %mi2 = mi' ./ repmat(h(jx),1,length(ix));
    %mi2(isnan(mi2)) = 0;
    %outfile.mi(ix,jx) = (mi1+mi2')/2;
    %outfile.mi(jx,ix) = (mi1'+mi2)/2;
    
    fprintf('%s: Saved batch %d out of %d\n',datestr(datetime('now')),k,nbatches);
    k = k+1;
end

% Clean up
delete([tempfile '.mat']);
clearvars -global jobs outfile tempfile;
%delete(ppool);