function compute_MI_PP(data, file, px, ex, h, batch, fetch, cont)
%% This internal function is called from compute_MI_batch()

%% Set up batch structure
fprintf('Start time: %s\n',datestr(datetime('now')));
nvars = size(data,1);
% Declare global variables that can be used by fetching function
clearvars -global jobs outfile tempfile;
global jobs outfile tempfile;
tempfile = tempname(); % Temporary file for provisional results
save(tempfile, 'data', 'px', 'ex', 'h');

% Open output file, allocate matrix if it doesn't exist
outfile = matfile(file,'Writable',true);
if ~cont
    fprintf('Allocating memory for matrix\n');
    outfile.mi = zeros(nvars);
end

%% Create parallel pool and parallel batch jobs
gcp();
jobs = [];
lp = 1:batch:nvars; % Loop index
for i = 1:length(lp)
    ix = lp(i):min(nvars,lp(i)+batch-1);
    
    for j = 1:i
        jx = lp(j):min(nvars,lp(j)+batch-1);
        
        if cont && sum(sum(outfile.mi(ix,jx)))>0
            continue;
        end
        
        jobs = [jobs;parfeval(@process_batch,3,tempfile,ix,jx)];
    end
end

% Start fetching data right away
if fetch
    clear;
    fetch_results;
end